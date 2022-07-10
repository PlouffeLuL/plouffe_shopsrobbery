local Utils = exports.plouffe_lib:Get("Utils")

local Wait = Wait
local Core = nil
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId

function Sh:Start()
    TriggerEvent('ooc_core:getCore', function(Core)
        while not Core.Player:IsPlayerLoaded() do
            Wait(500)
        end

        self.Player = Core.Player:GetPlayerData()

        -- self:ExportAllZones()
        self:RegisterEvents()
    end)
end

function Sh:ExportAllZones()
    for k,v in pairs(self.Territories) do
        for x,y in pairs(v.coords) do
            exports.plouffe_lib:ValidateZoneData(y)
        end
    end
end

function Sh:RegisterEvents()
    RegisterNetEvent("plouffe_lib:inVehicle", function(inVehicle, vehicle)
        self.Utils.inVehicle = inVehicle
        self.Utils.vehicle = vehicle
    end)
end

function Sh:GetItemCount(item)
    local count = exports.ox_inventory:Search(2, item)
    count = count and count or 0
    return count, item
end

function Sh:GetClosestSafe()
    local pedCoords = GetEntityCoords(PlayerPedId())
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

function Sh.TryRob()
    if Sh.Utils.inVehicle or LocalPlayer.state.dead then
        return
    end

    local closest = Sh:GetClosestSafe()

    if not closest then
        return Utils:Notify("Il n'y a aucun coffre a proximité")
    end

    if Sh:GetItemCount("card_shop") < 1 then
        return
    end

    Utils:PlayAnim(nil, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" , 1, 3.0, 2.0, nil, true, true, true)

    local success = exports.icon_memory:start(math.random(2,4), 5000)

    Utils:StopAnim()

    if not success then
        return exports.plouffe_dispatch:SendAlert("10-90 A")
    end

    TriggerServerEvent("plouffe_shopsrobbery:request_loots", Sh.Utils.MyAuthKey)
end
exports("TryRob", Sh.TryRob)