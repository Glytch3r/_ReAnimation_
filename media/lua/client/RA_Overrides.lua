
function OverrideZedPlayerActions()
    require("TimedActions/ISOpenCloseDoor")


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


    function ISBaseTimedAction:isValidStart() return false end

    -- Hotbar override
    ISHotbar.onKeyStartPressed = function(key) return end
    ISHotbar.onKeyPressed = function(key) return end
    ISHotbar.onKeyKeepPressed = function(key) return end




end

