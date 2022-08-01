ESX = nil

local cruiser

Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped, false)
		local sleep = true
		Citizen.Wait(0)
		if veh then
			sleep = false
			local fuel = GetVehicleFuelLevel(veh)
			local speed = GetEntitySpeed(veh)*3.6 -- Value in KM/H
			local gear = GetVehicleCurrentGear(veh)
			SendNUIMessage({
				isInCoche = veh;
				speed = speed;
				fuel = fuel;
				vidatexto = ESX.Math.Round(GetVehicleEngineHealth(veh) / 10),
				fueltexto = ESX.Math.Round(GetVehicleFuelLevel(veh)),
				gear = gear;
				vehicleCruiser = vehicleCruiser,
			})
		else
			SendNUIMessage({
				isInCoche = veh;
			})
		end
		if sleep then Citizen.Wait(500) end
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		local vehicleClass = GetVehicleClass(vehicle)

		-- Vehicle Cruiser
		if IsPedInAnyVehicle(player, false) and GetIsVehicleEngineRunning(vehicle) and IsControlJustPressed(1, 243) and GetPedInVehicleSeat(vehicle, player) then
			
			local vehicleSpeedSource = GetEntitySpeed(vehicle)

			if vehicleCruiser == 'on' then
				vehicleCruiser = 'off'
				SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
				
			else
				vehicleCruiser = 'on'
				SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
			end
        end

	end
end)
