local Auth = exports.plouffe_lib:Get("Auth")
local Inventory = exports.plouffe_lib:Get("Inventory")
local Lang = exports.plouffe_lib:Get("Lang")

local GetEntityCoords = GetEntityCoords
local GetPlayerPed = GetPlayerPed

function Sh.Init()
    Sh.ValidateConfig()

    for k,v in pairs(Sh.Shops) do
        local money = GetResourceKvpInt(("money_%s"):format(k))
        v.currentMoney = money or 0
    end

    Sh:Process()

    Server.ready = true
end

function Sh.LoadPlayer()
    local playerId = source
    local registred, key = Auth.Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local data = Sh:GetData()
        data.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_shopsrobbery:getConfig", playerId, data)
    else
        TriggerClientEvent("plouffe_shopsrobbery:getConfig", playerId, nil)
    end
end

function Sh.ValidateConfig()
    Sh.MoneyItem = GetConvar("plouffe_shopsrobbery:money_item", "")
    Sh.addMoneyIntervall = (tonumber(GetConvar("plouffe_shopsrobbery:add_money_interval", "")))
    Sh.minMoneyAddition = tonumber(GetConvar("plouffe_shopsrobbery:min_money_addition", ""))
    Sh.maxMoneyAddition = tonumber(GetConvar("plouffe_shopsrobbery:max_money_addition", ""))
    Sh.maxShopsMoney = tonumber(GetConvar("plouffe_shopsrobbery:max_shops_money", ""))

    local data = json.decode(GetConvar("plouffe_shopsrobbery:lockpick_items", ""))
    if data and type(data) == "table" then
        Sh.lockpick_items = {}

        for k,v in pairs(data) do
            local one, two = v:find(":")
            Sh.lockpick_items[v:sub(0,one - 1)] = tonumber(v:sub(one + 1,v:len()))
        end
        data = nil
    end

    if not Sh.lockpick_items or type(Sh.lockpick_items) ~= "table" then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'lockpick_items' convar. Refer to documentation")
        end
    elseif not Sh.addMoneyIntervall then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'add_money_interval' convar. Refer to documentation")
        end
    elseif not Sh.minMoneyAddition then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'min_money_addition' convar. Refer to documentation")
        end
    elseif not Sh.maxMoneyAddition then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'max_money_addition' convar. Refer to documentation")
        end
    elseif not Sh.maxShopsMoney then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'max_shops_money' convar. Refer to documentation")
        end
    end

    Sh.addMoneyIntervall *= (1000 * 60)
end

function Sh:GetData()
    local retval = {}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

function Sh:Process()
    CreateThread(function()
        while true do
            Wait(self.addMoneyIntervall)

            for k,v in pairs(self.Shops) do
                local addition = math.ceil(math.random(self.minMoneyAddition, self.maxMoneyAddition))
                v.currentMoney = addition + v.currentMoney <= self.maxShopsMoney and addition + v.currentMoney or 0
                SetResourceKvpInt(("money_%s"):format(k), v.currentMoney)
            end
        end
    end)
end

function Sh:GetClosestSafe(playerId)
    local pedCoords = GetEntityCoords(GetPlayerPed(playerId))
    local closest, distance = nil, 2.0

    for k,v in pairs(self.Shops) do
        local dstCheck = #(pedCoords - v.coords)

        if dstCheck < distance then
            distance = dstCheck
            closest = k
        end
    end

    return closest
end

function Sh.RequestLoots(authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_shopsrobbery:request_loots") then
        return
    end

    local closest = Sh:GetClosestSafe(playerId)

    if not closest then
        return
    end

    if Sh.Shops[closest].currentMoney < 1 then
        return TriggerClientEvent("plouffe_lib:notify", playerId,  {style = "inform", message = Lang.shops_empty})
    end

    for k,v in pairs(Sh.lockpick_items) do
        local reduced, reason = Inventory.ReduceDurability(playerId,k,(60 * 60 * 48))

        if not reduced then
            return
        end
    end

    Inventory.AddItem(playerId, Sh.MoneyItem, Sh.Shops[closest].currentMoney)

    Sh.Shops[closest].currentMoney = 0
    SetResourceKvpInt(("money_%s"):format(closest), 0)
end

CreateThread(Sh.Init)