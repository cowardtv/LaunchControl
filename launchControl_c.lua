toggleLaunch = false
RegisterKeyMapping('lcv', 'Launch Control', 'keyboard', 'j')

local speedomulti = 3.6
local SpecificCarsOnly = true
LaunchCars = {
    "rs318", "subwrx","cowardm4","golfmk6","m3f80","rmodgt64","rmodrs6","urus","urustc","765lt","m3e46","toysupmk4","r8v10abt","gtr","r6","r1m","20r1","panigale","hayabusa","h2carb","bmwg07","pista",
    }


RegisterCommand('lcv', function()
	local vehicleModel = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	if SpecificCarsOnly then
		for _,cars in pairs(LaunchCars) do
			if GetHashKey(cars) == vehicleModel then
				if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then
				local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * speedomulti)
				if speed < 1 then
				toggleLaunchControl()
				else
				-- TriggerEvent("notification","Cant use while Driving...",2)
				QBCore.Functions.Notify('Cant use while Driving...', 'error')
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
				-- TriggerEvent("notification","Cant use while Driving...",2)
				QBCore.Functions.Notify('Cant use while Driving...', 'error')
				end
				end
	end
end, false)






function toggleLaunchControl()
	
		if toggleLaunch then
			toggleLaunch = false
			QBCore.Functions.Notify('Launch Control OFF', 'error')
			-- TriggerEvent("notification","Launch Control OFF",2)
		else
			if cooldownSecondsRemaining <= 0 then
			handleCooldown()
			toggleLaunch = true
			QBCore.Functions.Notify('Launch Control On', 'success')
			else
	local minutes = math.floor(cooldownSecondsRemaining / 60) -- divide the total seconds remaining by 60 to get minutes, pass it to math.floor to strip off the decimals
		local seconds = cooldownSecondsRemaining - minutes * 60 -- get the seconds left that don't make up a full minute
		local cooldownMessage = string.format(" Launch Control is On Cooldown... Wait:  %dm, %ds", minutes, seconds)
	QBCore.Functions.Notify(cooldownMessage, 'error')
	end
		-- TriggerEvent("notification","Launch Control On",1)
		end
end
local toggleBoost = false

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
				QBCore.Functions.Notify('Launch Control Successful !', 'success')
				-- TriggerEvent("notification","Launch Control Successful !",2)
				-- AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
				toggleBoost = true
				Citizen.Wait(4400)
				toggleBoost = false
				QBCore.Functions.Notify('Launch Control OFF !', 'error')
				end
			else
			toggleLaunch = false
			QBCore.Functions.Notify('Launch Control OFF, exited a vehicle...', 'error')
			-- TriggerEvent("notification","Launch Control OFF, exited a vehicle...",2)
			end
        end
     end
end )




Citizen.CreateThread(function()
    while true do
        while toggleBoost do
            SetVehicleCheatPowerIncrease(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.2)
            Citizen.Wait(0)
        end
        SetVehicleCheatPowerIncrease(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0)
        Citizen.Wait(0)
    end
end)
