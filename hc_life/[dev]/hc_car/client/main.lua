RegisterCommand("car", function(_, args)
    local vehicleName = args[1] or 'adder'

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent("chat:addMessage", {
            args = {"A "..vehicleName.." is not a vehicle!"}
        })

        return
    end
    
    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(1)
    end

    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local vehicle = CreateVehicle(
        vehicleName,
        pos.x,
        pos.y,
        pos.z,
        heading,
        true
    )

    SetPedIntoVehicle(playerPed, vehicle, -1)

end)