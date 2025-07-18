RegisterNetEvent("av_business:products", function(data)
    local type = data['zoneType']
    if not type then print("[ERROR] av_business:products received null instead of type") return end
    local job = data['zoneJob']
    if not job then print("[ERROR] av_business:products received null instead of job") return end
    local products = lib.callback.await('av_business:getProducts', false, type, job)
    local options = {}
    for k, v in pairs(products) do
        local ingredientsLabel = ""
        if v['ingredients'] and next(v['ingredients']) then
            for k, v in pairs(v['ingredients']) do
                if tonumber(k) == 1 then
                    ingredientsLabel = getItemLabel(v)
                else
                    ingredientsLabel = ingredientsLabel.." | "..getItemLabel(v)
                end
            end
        end
        local description = v['description']
        if string.len(ingredientsLabel) > 1 then
            description = Lang['ingredients']..": "..ingredientsLabel
        end
        options[#options+1] = {
            title = v['label'],
            description = description,
            event = "av_business:craft",
            args = {
                item = v['name'],
                job = job,
                type = type,
                ingredients = v['ingredients'],
                label = v['label'],
                prop = v['prop'],
                description = v['description']
            }
        }
    end
    lib.registerContext({
        id = 'products',
        title = data['label'] or "Products",
        options = options,
    })
    lib.showContext('products')
end)

function getItemLabel(name)
    if not name then return '' end
    local label = name
    for i = 1, #Config.Ingredients do
        local ingredient = Config.Ingredients[i]
        if name == ingredient.value then
            label = ingredient.label
            break
        end
    end
    return label:gsub("^%l", string.upper)
end