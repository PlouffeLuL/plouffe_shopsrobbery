Sh = {}
TriggerServerEvent("plouffe_shopsrobbery:sendConfig")
local cookie

cookie = RegisterNetEvent("plouffe_shopsrobbery:getConfig", function(list)
	if list then
		for k,v in pairs(list) do
			Sh[k] = v
		end
	else
		Sh = nil
	end

	RemoveEventHandler(cookie)
end)