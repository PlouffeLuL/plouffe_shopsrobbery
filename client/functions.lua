local Utils = exports.plouffe_lib:Get("Utils")
local Lang = exports.plouffe_lib:Get("Lang")
local Interface = exports.plouffe_lib:Get("Interface")

local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId

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
    local closest = Sh:GetClosestSafe()

    if not closest then
        return Interface.Notifications.Show({
            style = "error",
            header = "Shops",
            message = Lang.shops_no_safe
        })
    end

    for k,v in pairs(Sh.lockpick_items) do
        if Utils:GetItemCount(k) < v then
            return Interface.Notifications.Show({
                style = "error",
                header = "Shops",
                message = Lang.missing_something
            })
        end
    end

    Utils:PlayAnim(nil, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" , 1, 2.0, 1.0, 100000, false, true, true)

    local succes = Interface.Lockpick.New({
        amount = 18,
        range = 40,
        maxKeys = 6
    })

    Utils:StopAnim()

    if not succes then
        if GetResourceState("plouffe_dispatch") == "started" then
            exports.plouffe_dispatch:SendAlert("10-90 A")
        end

        return
    end

    TriggerServerEvent("plouffe_shopsrobbery:request_loots", Sh.Utils.MyAuthKey)
end
exports("TryRob", Sh.TryRob)