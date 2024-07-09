local function addBag()
    TriggerEvent('skinchanger:getSkin', function(skin)
        uniformObject = {
            bags_1 = 44
        }

    	TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
    end)
end

RegisterNetEvent("hc:clothing:getBag")
AddEventHandler("hc:clothing:getBag", function()
    addBag()
    TriggerServerEvent("hc:clothing:bagAdded")
end)