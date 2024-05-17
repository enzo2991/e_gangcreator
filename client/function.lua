lib.callback.register("o_gang_creator:GetPosPlayer",function()
	local playerId = PlayerPedId()
	while true do
		local posPlayer = GetEntityCoords(playerId)
		if IsControlPressed(1, 51) then
			print(posPlayer)
			return posPlayer
		end
		Citizen.Wait(1)
	end
end)