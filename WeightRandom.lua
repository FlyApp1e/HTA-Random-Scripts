function weighted_random(items, weights)
    if table.getn(items) ~= table.getn(weights) then
        println( "Error: Количество предметов и весов должно быть одинаковым" )
    end

    local total_weight = 0
    for i = 1, table.getn(weights) do
        total_weight = total_weight + weights[i]
    end

    local random_value = math.random() * total_weight

    local cumulative_weight = 0
    for i = 1, table.getn(weights) do
        cumulative_weight = cumulative_weight + weights[i]
        if random_value <= cumulative_weight then
            return items[i]
        end
    end
end
