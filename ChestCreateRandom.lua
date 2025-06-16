function ChestCreateRandom(pos, items, minCount, maxCount)
    -- Проверка аргументов
    if type(items) ~= "table" or table.getn(items) == 0 then
        println("Error: Invalid items list")
        LOG("Error: Invalid items list")
        return
    end
    if minCount > maxCount or minCount < 1 then
        println("Error: Invalid count range")
        LOG("Error: Invalid count range")
        return
    end

    -- Создание сундука
    local randomSuffix = math.random(10000)
    local chestID = CreateNewObject{
        prototypeName = "someChest",
        objName = "DynamicChest_"..tostring(randomSuffix)
    }
    local MyChest = GetEntityByID(chestID)
    MyChest:SetPosition(pos)

    -- Генерация общего количества предметов
    local totalItems = math.random(minCount, maxCount)
    if totalItems == 0 then return end

    -- Преобразование предметов в таблицы с флагом ценности
    local availableItems = {}
    for i = 1, table.getn(items) do
        local item = items[i]
        if type(item) == "string" then
            table.insert(availableItems, {name = item, isValuable = false})
        else
            table.insert(availableItems, {name = item.name, isValuable = item.isValuable})
        end
    end

    -- Выбор предметов для добавления
    local selectedItems = {}
    local remaining = totalItems
    local maxPossible = math.min(table.getn(availableItems), totalItems)

    -- Выбираем первый предмет
    if table.getn(availableItems) == 0 then return end
    local firstIndex = math.random(1, table.getn(availableItems))
    table.insert(selectedItems, availableItems[firstIndex])
    table.remove(availableItems, firstIndex)
    remaining = remaining - 1

    -- Распределение оставшихся предметов
    while remaining > 0 do
        -- Определяем доступные для добавления типы
        local canAddNew = table.getn(availableItems) > 0 and table.getn(selectedItems) < maxPossible
        local hasOrdinary = false
        for _, item in ipairs(selectedItems) do
            if not item.isValuable then
                hasOrdinary = true
                break
            end
        end

        -- Выбираем стратегию добавления
        if canAddNew and (math.random() < 0.25 or not hasOrdinary) then
            -- Добавляем новый тип предмета
            local newIndex = math.random(1, table.getn(availableItems))
            local newItem = availableItems[newIndex]
            table.insert(selectedItems, newItem)
            table.remove(availableItems, newIndex)
            remaining = remaining - 1
        else
            -- Увеличиваем количество обычных предметов
            local ordinaryItems = {}
            for _, item in ipairs(selectedItems) do
                if not item.isValuable then
                    table.insert(ordinaryItems, item)
                end
            end
            
            if table.getn(ordinaryItems) > 0 then
                -- Выбираем случайный обычный предмет
                local targetIndex = math.random(1, table.getn(ordinaryItems))
                table.insert(selectedItems, ordinaryItems[targetIndex])
                remaining = remaining - 1
            elseif canAddNew then
                -- Вынужденно добавляем новый тип
                local newIndex = math.random(1, table.getn(availableItems))
                local newItem = availableItems[newIndex]
                table.insert(selectedItems, newItem)
                table.remove(availableItems, newIndex)
                remaining = remaining - 1
            else
                break -- Невозможно добавить предметы
            end
        end
    end

    -- Подсчет итогового количества
    local itemCounts = {}
    for _, item in ipairs(selectedItems) do
        local itemName = item.name
        itemCounts[itemName] = (itemCounts[itemName] or 0) + 1
    end

    -- Добавление предметов в сундук
    for itemName, count in pairs(itemCounts) do
        for i = 1, count do
            local id = CreateNewObject{
                prototypeName = itemName,
                objName = "ItemsChest"..tostring(math.random(1000))
            }
            MyChest:AddChild(GetEntityByID(id))
        end
    end
end
