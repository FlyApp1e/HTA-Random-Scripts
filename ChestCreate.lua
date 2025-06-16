function ChestCreate(pos, ListOfItems, ListOfCounts)    
    local count = getn(ListOfItems)
    local countC = getn(ListOfCounts)
    if (1 > count) or (1 > countC) or (count ~= countC) then
        println("Error!")
        LOG ("Error!")
    else 
        local chestID = CreateNewObject{ prototypeName = "someChest", objName = "someChest" }
        local MyChest=GetEntityByID(chestID)
        MyChest:SetPosition(pos)
        local id = -1      
        for i=1, count do
            for n=1, ListOfCounts[i] do
                id = CreateNewObject{ prototypeName = ListOfItems[i], objName = "ItemsChest"..random(1000) } 
                MyChest:AddChild(GetEntityByID(id))
            end
        end
    end
end
