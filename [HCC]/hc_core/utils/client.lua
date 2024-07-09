HC = {}
HC.Utils = {}

local function rotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- Function to get the entity the player is currently looking at
function HC.Utils.GetCursorTargetEntity()
    local playerPed = GetPlayerPed(-1)
    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local direction = rotationToDirection(camRot)

    local distance = 5.0 -- Maximum distance to check
    local dest = vector3(camCoord.x + direction.x * distance, camCoord.y + direction.y * distance, camCoord.z + direction.z * distance)

    local rayHandle = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, dest.x, dest.y, dest.z, -1, playerPed, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 then
        return entityHit
    else
        return nil
    end
end

exports('GetHC', function() return HC end)