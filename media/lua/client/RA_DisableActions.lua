



RA_DisableMapActions = function()
    -- Removes some keybinds to prevent player from using the map
    Events.OnKeyStartPressed.Remove(ISWorldMap.onKeyStartPressed)
    Events.OnKeyKeepPressed.Remove(ISWorldMap.onKeyKeepPressed)
    Events.OnKeyPressed.Remove(ISWorldMap.onKeyReleased)
    ISWorldMap.isAllowed = false
end

RA_DisableVariousClickInteractions = function()
    function ISObjectClickHandler.doClickSpecificObject(object, playerNum, playerObj)

        return false
    end
    function ISOpenCloseCurtain:isValid()
        return false
    end
    function ISBarricadeAction:isValid()
        return false
    end
    function ISOpenCloseDoor:isValid()
        return false
    end
end

RA_DisableHotbarUsage = function()
    -- Hotbar override
    ISHotbar.onKeyStartPressed = function(key) return end
    ISHotbar.onKeyPressed = function(key) return end
    ISHotbar.onKeyKeepPressed = function(key) return end

    -- TODO Find a way to hide it
end





local function CheckForInteractable(dir, player)
    local square1 = player:getCurrentSquare()
    local square2 = square1:getAdjacentSquare(dir)
    local obj = player:getContextDoorOrWindowOrWindowFrame(dir)


    if obj then

        if instanceof(obj, "IsoDoor") then
            if not obj:IsOpen() then
                obj:ToggleDoor(player)     --Basically opens it and close it at the same time.
                return true
            end
        elseif instanceof(obj, "IsoWindow") then
            if not obj:IsOpen() then
                player:closeWindow(obj)
                return true
            end
        end



    end

    return false


end

RA_DisableDoorAndWindowInteraction = function(player)
    if key == 18 then

        if getCell():getDrag(player:getPlayerNum()) then return end     -- TODO What does this do?
        if player:getIgnoreMovement() or player:isAsleep() then return end

        if player:getVehicle() then return end

        local square = player:getCurrentSquare()
        if not square then return end

        local dir = player:getDir()
        local found = nil

        local directions = {
            IsoDirections.N,
            IsoDirections.E,
            IsoDirections.S,
            IsoDirections.W,
        }

        for _,v in pairs(directions) do
            found = CheckForInteractable(v, player)
            if found then
                break
            end
        end

    end

end