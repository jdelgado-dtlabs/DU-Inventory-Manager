if not StorageReady then
    local pass = true
    for i,_ in ipairs(Hubs) do
        if DEBUG then system.print("Hub"..i..": "..rslib.toString(Hubs[i]["storeAcq"])) end
        if not Hubs[i]["storeAcq"] then
            pass = false
        end
    end
    StorageReady = pass
else
    if not DataStart then
        --if DEBUG then system.print("DataStart = false") end
        waitForAck()
    else
        if not MsgList then
        local items, core = {}, {}
        for i, _ in ipairs(Hubs) do
            local item = getItems(Hubs[i]["hub"])
            table.insert(items, item)
        end
        if Ship then
            core = getShip()
        elseif Land then
            core = getLand()
        elseif Space then
            core = getSpace()
        end
        MsgList = createMessageList(items, core)
        DataStart = false
        sendOutput("READY")
    else
        if ACK then
            if DEBUG then system.print("ACK = true") end
                ACK = false
                MsgList = processOutput(MsgList)
                if not MsgList then DataStart = false end
            else
                if DEBUG then system.print("ACK = false") end
                waitForAck()
            end
        end
    end
end