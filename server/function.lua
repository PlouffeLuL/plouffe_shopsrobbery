local GetEntityCoords = GetEntityCoords
local GetPlayerPed = GetPlayerPed

local function tlen(t)
	local retval = 0

	for k,v in pairs(t) do
		retval = retval + 1
	end

	return retval
end

function Sh.Init()
    for k,v in pairs(Sh.Shops) do
        local money = GetResourceKvpInt(("money_%s"):format(k))
        v.currentMoney = money or 0
    end

    Sh:Process()

    Server.ready = true
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
            local sleepTimer = math.random(60 * 1000 * 60 * 1, 60 * 1000 * 60 * 3)
            
            Wait(sleepTimer)

            for k,v in pairs(self.Shops) do
                local addition = math.ceil(math.random(v.min or 100, v.max or 500))
                local max = v.max or 5000
                v.currentMoney = addition + v.currentMoney <= max and addition + v.currentMoney or 0
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

function Sh:RequestLoots(playerId)
    local closest = self:GetClosestSafe(playerId)

    if not closest then
        return
    end
    
    if self.Shops[closest].currentMoney < 1 then
        return TriggerClientEvent("plouffe_lib:notify", playerId,  { type = "inform", txt = "Le coffre est vide", length = 5000})
    end
    
    local reduced, reason = Utils:ReduceDurability(playerId,"card_shop",(60 * 60 * 48))

    if not reduced then
        return 
    end

    exports.ox_inventory:AddItem(playerId, "money", self.Shops[closest].currentMoney)
    
    self.Shops[closest].currentMoney = 0
    SetResourceKvpInt(("money_%s"):format(closest), 0)
end

RegisterCommand("add_shop_money", function(s,a,r)
    if not a[1] then
        return
    end

    local key =  a[1]:lower()

    if not Sh.Shops[key] then
        return print("No exist kek")
    end

    Sh.Shops[key].currentMoney = tonumber(a[2]) or 100

    SetResourceKvpInt(("money_%s"):format(key), Sh.Shops[key].currentMoney)
end, true)