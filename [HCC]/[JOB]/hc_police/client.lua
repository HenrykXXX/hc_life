local isHandcuffed = false

local function getPoliceGear()
    TriggerServerEvent("hc:police:getGear")
end

AddEventHandler("hc:police:getGear", function()
    getPoliceGear()
end)

RegisterNetEvent("hc:police:recieveGear")
AddEventHandler("hc:police:recieveGear", function(rank)
    if rank > 0 then
		TriggerEvent("hc:hint:show", "Welcome!")
		
		local continue = false
		TriggerEvent('skinchanger:loadDefaultModel', true, function()
			continue = true
		end)
		
		while not continue do
			Wait(100)
		end

		local pp = PlayerPedId()
		if not pp then
			print("Coudl not get player ped...")
			return
		end

		-- Remove all weapons
		RemoveAllPedWeapons(pp, true)

		-- Add stun gun
		GiveWeaponToPed(pp, GetHashKey("WEAPON_STUNGUN"), 60, false, true)
	
		-- Add police baton
		GiveWeaponToPed(pp, GetHashKey("WEAPON_NIGHTSTICK"), 1, false, true)
		
		TriggerEvent('skinchanger:getSkin', function(skin)
			uniformObject = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
	
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		end)
	else
		TriggerEvent("hc:hint:show", "You are not a cop!")
	end
end)

RegisterNetEvent('hc_police:handcuff')
AddEventHandler('hc_police:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		RemoveAnimDict('mp_arresting')

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed, true)
		DisplayRadar(false)
	else
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterCommand("hc.cop.handcuff", function()
    TriggerEvent("hc_police:handcuff")
end, false)