CreateThread(Sh.Init)

RegisterNetEvent("plouffe_shopsrobbery:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local cbArray = Sh:GetData()
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_shopsrobbery:getConfig", playerId, cbArray)
    else
        TriggerClientEvent("plouffe_shopsrobbery:getConfig", playerId, nil)
    end
end)

RegisterNetEvent("plouffe_shopsrobbery:request_loots",function(authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_shopsrobbery:request_loots") then
        Sh:RequestLoots(playerId)
    end
end)