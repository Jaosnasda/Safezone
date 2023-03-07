--[[ 

    ==== Safezone - Jaosnasda#2222 ====

	Set up Safezones to protect your players at a certain point
    
    Coder: Jaosnasda#2222

    ==== Safezone - Jaosnasda#2222 ====

]]

local zones = {
	{ ['x'] = X Coords, ['y'] = Y Coords, ['z'] = Y Coords}
}

local notifIn = false
local notifOut = false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)

		if dist <= 25.0 then
			if not notifIn then
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
                exports['Your Notify']:Noti("Notify Color", "Mona Service", "Du bist in einer Safezone")
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
                exports['Your Notify']:Noti("Notify Color", "Mona Service", "Du bist nicht mehr in einer Safezone")
				notifOut = true
				notifIn = false
			end
		end
		if notifIn then
		DisableControlAction(2, 37, true)
		DisablePlayerFiring(player,true)
      	DisableControlAction(0, 106, true)
			if IsDisabledControlJustPressed(2, 37) then
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
			end
			if IsDisabledControlJustPressed(0, 106) then
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
			end
	 	end
	end
end)
