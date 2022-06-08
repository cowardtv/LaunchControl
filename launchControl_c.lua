toggleLaunch = false
local SpecificCarsOnly = true
RegisterKeyMapping('lcv', 'Launch Control', 'keyboard', 'j')

local speedomulti = 3.6
RegisterCommand('lcv', function()
	local vehicleModel = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	if SpecificCarsOnly then
		for _,cars in pairs(Config.LaunchCars) do
			if GetHashKey(cars) == vehicleModel then
				if IsPedInAnyVehicle(PlayerPedId(), false) then
				local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * speedomulti)
				if speed < 1 then
				toggleLaunchControl()
				else
				TriggerEvent("notification","Cant use while Driving...",2)
				end
				end
			end
		end
	else
		if IsPedInAnyVehicle(PlayerPedId(), false) then
				local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * speedomulti)
				if speed < 1 then
				toggleLaunchControl()
				else
				TriggerEvent("notification","Cant use while Driving...",2)
				end
				end
	end
end, false)






function toggleLunchControl()
    if toggleLaunch then
        toggleLaunch = false
		QBCore.Functions.Notify('Launch Control OFF', 'error')
    else
        toggleLunch = true
		QBCore.Functions.Notify('Launch Control On', 'success')
    end
end


Citizen.CreateThread( function()


     while true do
        Citizen.Wait( 3 )
	
        if toggleLaunch then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local vehiclePos = GetEntityCoords(vehicle)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local rpm = GetVehicleCurrentRpm(vehicle)
				local speed = math.floor(GetEntitySpeed(vehicle) * speedomulti)
				if speed < 1 then
				SetVehicleCurrentRpm(vehicle , 0.7)
				else
				toggleLaunch = false
				QBCore.Functions.Notify('Launch Control OFF, too fast....', 'error')
				end

			else
			toggleLaunch = false
			QBCore.Functions.Notify('Launch Control OFF, exited a vehicle...', 'error')
			end
        end
     end
end )


