-- Required Libraries
json = require('dkjson')
rslib = require('rslib')

-- Don't turn this on unless you know that your chat will get spammed.
DEBUG = true

-- global variables
MaxVolume = 1150000 --export: (Default 1150000) Put the maximum volume of your containers in L. 1 kL = 1000 L
DataStart = false

-- find my hubs
local hublist = { hub1, hub2, hub3, hub4, hub5, hub6, hub7, hub8 }
Hubs = {}

for i,v in ipairs(hublist) do
    if hublist[i] then
        local t = { eId = hublist[i].getId(), storeAcq = false, hub = hublist[i] }
        table.insert(Hubs, t)
    end
end

-- base functions to be used later
function round2 (num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end

function maxForceForward ()
    local axisCRefDirection = vec3(core.getConstructOrientationForward())
    local longitudinalEngineTags = 'thrust analog longitudinal'
    local maxKPAlongAxis = core.getMaxKinematicsParametersAlongAxis(longitudinalEngineTags, {axisCRefDirection:unpack()})
    if unit.getAtmosphereDensity() == 0 then -- we are in space
        return maxKPAlongAxis[3]
    else
        return maxKPAlongAxis[1]
    end
end

function getItems (hub)
    local c = json.decode(hub.getItemsList())
    local out = {}
    if DEBUG then system.print("container: "..rslib.toString(c)) end
    for i, v in ipairs(c) do
        local item = c[i]
        local t = {}
        t["id"] = i
        t["name"] = item["name"]
        t["qty"] = item["quantity"]
        t["unitv"] = round2(item["unitVolume"], 2)
        t["unitm"] = round2(item["unitMass"], 2)
        table.insert(out,i,t)
    end
    return out
end

function createMessageList (items, core)
    local t = {}
    if DEBUG then system.print("Processed: "..rslib.toString(items)) end
    table.insert(t,1,"START")
    for h=1,#Hubs do
        for i,_ in ipairs(items[h]) do
            table.insert(t, i+1, items[h][i])
        end
    end
    table.insert(t, core)
    table.insert(t, "DONE")
    return t
end

function sendOutput (message)
    if message ~= nil then
        message = json.encode(message)
        if DEBUG then system.print("Raw: "..rslib.toString(message)) end
        screen1.setScriptInput(message)
    end
end

function processOutput (messages)
    if DEBUG then system.print("Sending "..rslib.toString(messages[1])) end
    if messages[1] == "START" then
        sendOutput("START")
        table.remove(messages, 1)
        waitForAck()
        return messages
    elseif messages[1] == "DONE" then
        sendOutput("DONE")
        return false
    else
        sendOutput(messages[1])
        table.remove(messages, 1)
        waitForAck()
        return messages
    end
end

function waitForAck ()
    local ack = screen1.getScriptOutput() or false
    if ack and ack ~= "" then
        if DEBUG then system.print(ack.." received.") end
        if ack == "START" then
            DataStart = true
            ACK = true
            screen1.clearScriptOutput()
            ack = nil
        end
        if ack == "ACK" then
            sendOutput("SYN")
            screen1.clearScriptOutput()
            ack = nil
        end
        if ack == "ACKSYN" then
            DataStart = true
            ACK = true
            screen1.clearScriptOutput()
            ack = nil
        end
    end
end

function hubsItems (hubs)
    local m = 0
    local l = 0
    for i=1,#hubs do
        m = m + hubs[i]["hub"].getItemsMass()
        l = l + hubs[i]["hub"].getItemsVolume()
    end
    return m, l
end

function getShip ()
    local hM, hV = hubsItems(Hubs)
    local tM = core.getConstructMass()
    local g = core.g()
    local mt = maxForceForward()
    local t = {}
    t["name"] = "ship"
    t["mass"] = round2(tM, 2)
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    t["g"] = round2(g, 2)
    t["maxth"] = round2(mt, 2)
    if DEBUG then system.print("Ship: "..rslib.toString(t)) end
    return t
end

function getLand ()
    local hM, hV = hubsItems(Hubs)
    local t = {}
    t["name"] = "land"
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    if DEBUG then system.print("Land: "..rslib.toString(t)) end
    return t
end

function getSpace ()
    local hM, hV = hubsItems(Hubs)
    local tM = core.getConstructMass()
    local g = core.g()
    local t = {}
    t["name"] = "space"
    t["mass"] = round2(tM, 2)
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    t["g"] = round2(g, 5)
    if DEBUG then system.print("Space: "..rslib.toString(t)) end
    return t
end

-- Initializations
if #Hubs == 0 or not core or not screen1 then
    system.print("Error: Elements not found. Please attach your screen, core, and/or hubs. Exiting.")
    unit.exit()
else
    screen1.clearScriptOutput()
    local coreData = json.decode(core.getData())
    if DEBUG then system.print("Core: "..rslib.toString(coreData)) end
    if coreData["name"]:find("Dynamic") then
        if DEBUG then system.print("Ship") end
        Ship = true
    elseif coreData["name"]:find("Static") then
        if DEBUG then system.print("Land") end
        Land = true
    elseif coreData["name"]:find("Space") then
        if DEBUG then system.print("Space") end
        Space = true
    end

    system.print("Acquiring Storage...")
    for i, v in ipairs(Hubs) do
        if DEBUG then system.print("Opening hub "..i) end
        v["hub"].acquireStorage()
    end

    -- Activate Timers
    unit.setTimer("comms",0.0666667)
end