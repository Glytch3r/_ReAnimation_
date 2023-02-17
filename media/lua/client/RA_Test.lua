
local function OnInteractAction(key)
    if key == 18 then
        print("RA: Pressed E, searching for windows")
        local player = getPlayer()
        local found_window = false


        local square = getCell():getGridSquare(player:getX(), player:getY(), player:getZ())
        if square and not square:isSomethingTo(player:getSquare()) then

            local wobs = square:getSpecialObjects()
            for i = 0, wobs:size() - 1 do
                local o = wobs:get(i)
                if instanceof(o, "IsoWindow") then
                    print("RA: Found Window")
                    if luautils.walkAdjWindowOrDoor(player, square, o) then
                        found_window = true
                        ISTimedActionQueue.add(ISClimbThroughWindow:new(player, o, 0))
                        break
                    end
                end
            end

        end



        --
        --
        --for i=1, wobs:size()-1 do
        --    if instanceof(wobs:get(i), "IsoWindow") then
        --        print("RA: Found window")
        --        local window = wobs:get(i)
        --        if luautils.walkAdjWindowOrDoor(player, square, window) then
        --            ISTimedActionQueue.add(ISClimbThroughWindow:new(player, window, 0))
        --        end
        --    end
        --end






        --
        --    for i=0, wobs:size()-1 do
        --        local o = wobs:get(i)
        --        if o:getItem():getFullType() == "Base.PropaneTank" then
        --            if o:getItem():getUsedDelta() > 0 then
        --                return o
        --            end
        --        end
        --    end
        --    if luautils.walkAdjWindowOrDoor(player, square, window) then
        --        ISTimedActionQueue.add(ISClimbThroughWindow:new(playerObj, window, 0));
        --    end
    end
end
Events.OnKeyPressed.Add(OnInteractAction)

