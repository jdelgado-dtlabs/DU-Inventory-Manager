local eId = 0
for i,v in ipairs(Hubs) do
    eId = v["hub"].getId()
    if v["eId"] == eId then
        v["storeAcq"] = true
    end
end