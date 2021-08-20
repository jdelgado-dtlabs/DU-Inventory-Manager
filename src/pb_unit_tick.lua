local json = require('dkjson')

local currContVol = hub1.getItemsVolume()
local contMass = hub1.getItemsMass()
local shipMass = core.getConstructMass()
local currGravity = core.g()

function prettyStr (x)
    if type(x) == 'table' then
        local elems = {}
        for k, v in pairs(x) do
            table.insert(elems, string.format('%s = %s', prettyStr(k), prettyStr(v)))
        end
        return string.format('{%s}', table.concat(elems, ', '))
    else
        return tostring(x)
    end
end

function round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end

function maxForceForward()
    local axisCRefDirection = vec3(core.getConstructOrientationForward())
    local longitudinalEngineTags = 'thrust analog longitudinal'
    local maxKPAlongAxis = core.getMaxKinematicsParametersAlongAxis(longitudinalEngineTags, {axisCRefDirection:unpack()})
    if unit.getAtmosphereDensity() == 0 then -- we are in space
        return maxKPAlongAxis[3]
    else
        return maxKPAlongAxis[1]
    end
end

local maxThrust = maxForceForward()

function getStorage ()
    system.print("Acquiring Storage...")
    hub1.acquireStorage()
    storeCall = true
end

function getItems ()
    local container = json.decode(hub1.getItemsList())
    if container then
        local out = {}
        system.print("container: "..prettyStr(container))
        for i, v in ipairs(container) do
            local item = container[i]
            local t = {}
            t["id"] = i
            t["name"] = item["name"]
            t["qty"] = item["quantity"]
            t["unitv"] = round2(item["unitVolume"], 2)
            t["unitm"] = round2(item["unitMass"], 2)
            table.insert(out,i,t)
        end
        Items = out
    end
end

function getShip ()
    Ship = {}
    Ship["name"] = "ship"
    Ship["shipm"] = round2(shipMass, 2)
    Ship["contm"] = round2(contMass, 2)
    Ship["maxv"] = round2(maxContVol, 2)
    Ship["contv"] = round2(currContVol, 2)
    Ship["g"] = round2(currGravity, 2)
    Ship["maxth"] = round2(maxThrust, 2)
    system.print("Ship: "..prettyStr(Ship))
end

function sendOutput (message)
    if message ~= nil then
        local encodedMessage = json.encode(message)
        --system.print("Raw: "..prettyStr(message))
        screen1.setScriptInput(encodedMessage)
    end
end

function waitForAck()
    ack = screen1.getScriptOutput() or false
    if not ack then
        system.print("Waiting for ACK.")
    elseif ack == "ACK" then
        screen1.clearScriptOutput()
        system.print("ACK Received.")
        Ack = true
    end
end

function processMessages (Items, Ship)
    MsgList = {}
    for i,_ in ipairs(Items) do
        table.insert(MsgList, i, Items[i])
    end
    table.insert(MsgList, Ship)
    table.insert(MsgList, "DONE")
end

function processOutput ()
    if not Init then
        Init = true
        Ack = true
        sendOutput("")
    end
    if Ack then
        if MsgList[1] == "DONE" then
            sendOutput(MsgList[1])
            MsgList = false
        else
            sendOutput(MsgList[1])
            table.remove(MsgList, 1)
        end
        Ack = false
    else
        waitForAck()
    end
end

function main ()
    if not MsgList then
        if not Items then
            getItems()
        end
        if not Ship then
            getShip()
        end
        processMessages(Items, Ship)
        Items = false
        Ship = false
    else
        processOutput()
    end
end

if not storageAcq and not storeCall then
    getStorage()
end
if storageAcq then
    main()
end