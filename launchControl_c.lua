local initialCooldownSeconds = 20
local cooldownSecondsRemaining = 0

function handleCooldown()
    cooldownSecondsRemaining = initialCooldownSeconds
    Citizen.CreateThread(function()
        while cooldownSecondsRemaining > 0 do
            Citizen.Wait(1000)
            cooldownSecondsRemaining = cooldownSecondsRemaining - 1
        end
    end)
end



toggleLaunch = false
RegisterKeyMapping('lcv', 'Launch Control', 'keyboard', 'j')

local speedomulti = 3.6
local SpecificCarsOnly = true
local toggleBoost = false



LaunchCars = {
	
	["rs5"] = {
		["model"] = "rs5",
		["redline"] = 0.8,
	},
	
	["rs318"] = {
		["model"] = "rs318",
		["redline"] = 0.8,
	},
	
	["yzfr7"] = {
		["model"] = "yzfr7",
		["redline"] = 0.8,
	},
	
	["rs6c8"] = {
		["model"] = "rs6c8",
		["redline"] = 0.7,
	},
	
	["pista"] = {
		["model"] = "pista",
		["redline"] = 0.8,
	},
	
	["bmwg07"] = {
		["model"] = "bmwg07",
		["redline"] = 0.8,
	},
	
	["h2carb"] = {
		["model"] = "h2carb",
		["redline"] = 0.7,
	},
	
	["hayabusa"] = {
		["model"] = "hayabusa",
		["redline"] = 0.8,
	},
	
	["panigale"] = {
		["model"] = "panigale",
		["redline"] = 0.8,
	},
	
	["20r1"] = {
		["model"] = "20r1",
		["redline"] = 0.8,
	},
	
	["r1m"] = {
		["model"] = "r1m",
		["redline"] = 0.8,
	},
	
	["r6"] = {
		["model"] = "r6",
		["redline"] = 0.85,
	},
	
	["gtr"] = {
		["model"] = "gtr",
		["redline"] = 0.85,
	},
	
	["r8v10abt"] = {
		["model"] = "r8v10abt",
		["redline"] = 0.7,
	},
	
	["toysupmk4"] = {
		["model"] = "toysupmk4",
		["redline"] = 0.85,
	},
	
	["m3e46"] = {
		["model"] = "m3e46",
		["redline"] = 0.7,
	},
	
	["765lt"] = {
		["model"] = "765lt",
		["redline"] = 0.85,
	},
	
	["urustc"] = {
		["model"] = "urustc",
		["redline"] = 0.8,
	},
	
	["rmodrs6"] = {
		["model"] = "rmodrs6",
		["redline"] = 0.8,
	},
	
	["rmodgt64"] = {
		["model"] = "rmodgt64",
		["redline"] = 0.85,
	},
	
	["m3f80"] = {
		["model"] = "m3f80",
		["redline"] = 0.75,
	},
	
	["golfmk6"] = {
		["model"] = "golfmk6",
		["redline"] = 0.75,
	},
	
	["cowardm4"] = {
		["model"] = "cowardm4",
		["redline"] = 0.85,
	},
	
	["subwrx"] = {
		["model"] = "subwrx",
		["redline"] = 0.75,
	},
}

RegisterCommand('lcv', function()
	local vehicleModel = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	local tempVehicleModel = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	if SpecificCarsOnly then
		for model, data in pairs(LaunchCars) do
			 if (tempVehicleModel == GetHashKey(model)) then
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
			
			toggleLaunch = true
			QBCore.Functions.Notify('Launch Control On', 'success')
		else
			local minutes = math.floor(cooldownSecondsRemaining / 60) -- divide the total seconds remaining by 60 to get minutes, pass it to math.floor to strip off the decimals
			local seconds = cooldownSecondsRemaining - minutes * 60 -- get the seconds left that don't make up a full minute
			local cooldownMessage = string.format(" Launch Control is On Cooldown... Wait:  %dm, %ds", minutes, seconds)
		QBCore.Functions.Notify(cooldownMessage, 'error')
		end
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
				-- SetVehicleCurrentRpm(vehicle , RPM)
				redline = 0.7
				local tempVehicleModel = GetEntityModel(vehicle)
				for model, data in pairs(LaunchCars) do -- QBCore.Shared.Vehicles
					if (tempVehicleModel == GetHashKey(model)) then
						redline = data.redline
						break
					end
				end
				SetVehicleCurrentRpm(vehicle , redline)
				
				
				else
				toggleLaunch = false
				QBCore.Functions.Notify('Launch Control Successful !', 'success')
				-- TriggerEvent("notification","Launch Control Successful !",2)
				-- AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
				toggleBoost = true
				Citizen.Wait(4400)
				toggleBoost = false
				handleCooldown()
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
