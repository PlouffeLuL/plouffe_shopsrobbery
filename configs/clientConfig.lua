Sh = {}
TriggerServerEvent("plouffe_shopsrobbery:sendConfig")

RegisterNetEvent("plouffe_shopsrobbery:getConfig",function(list)
	if not list then
		while true do
			Sh = nil
		end
	else
		for k,v in pairs(list) do
			Sh[k] = v
		end

		Sh:Start()
	end
end)