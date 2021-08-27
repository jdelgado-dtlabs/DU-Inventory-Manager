if timerId == "storage" then
    if not StorageReady then
        local pass = true
        for i,_ in ipairs(Hubs) do
            if DEBUG then system.print("Hub"..i..": "..rslib.toString(Hubs[i]["storeAcq"])) end
            if not Hubs[i]["storeAcq"] then
                pass = false
            end
        end
        StorageReady = pass
        if StorageTimeout > 0 then
            StorageTimeout = StorageTimeout-1
        else
            system.print("Error: Storage Timeout exceeded. Check for standby timer. Exiting.")
            unit.exit()
        end
    else
        unit.stopTimer("storage")
        unit.setTimer("ingestion",30)
    end
elseif timerId == "ingestion" then
    unit.stopTimer("consumer")
    sendOutput("POLLING")
    if DEBUG then system.print("Sent Polling.") end
    ItemsList = sortItems(getItems(Hubs))
    if DEBUG then system.print("ItemsList populated.") end
    TotalPages = round2((#ItemsList/12),0)
    if DEBUG then system.print("Total Pages: "..tostring(TotalPages)) end
    unit.setTimer("consumer",0.066667)
elseif timerId == "consumer" then
    if not DataStart then
        waitForAck()
    else
        if not MsgList then
            MsgList = createMessageList()
            if DEBUG then system.print("MsgList populated.") end
        else
            if not DataReady then
                DataReady = true
                DataStart = false
                sendOutput("READY")
            else
                if ACK then
                    if DEBUG then system.print("ACK = true") end
                    ACK = false
                    MsgList = processOutput(MsgList)
                    if not MsgList then DataStart, DataReady = false, false end
                else
                    if DEBUG then system.print("ACK = false") end
                    waitForAck()
                end
            end
        end
    end
end
