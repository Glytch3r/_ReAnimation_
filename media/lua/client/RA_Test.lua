local CheckDoorOrWindow = function(obj)

end


local CheckForInteractable = function(dir, player)
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




local function OnInteractAction(key)
    -- TODO Use Dhert addKeyBind as a base





    if key == 18 then
        --print("RA: Pressed E, searching for windows")
        local player = getPlayer()
        local found_window = false


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

        --local square = getCell():getGridSquare(player:getX(), player:getY(), player:getZ())
        --if square and not square:isSomethingTo(player:getSquare()) then
        --
        --    local wobs = square:getSpecialObjects()
        --    for i = 0, wobs:size() - 1 do
        --        local o = wobs:get(i)
        --        if instanceof(o, "IsoWindow") then
        --            --print("RA: Found Window")
        --            if luautils.walkAdjWindowOrDoor(player, square, o) then
        --                found_window = true
        --                ISTimedActionQueue.add(ISClimbThroughWindow:new(player, o, 0))
        --                break
        --            end
        --        end
        --    end
        --
        --end



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
Events.OnKeyPressed.Add(OnInteractAction)

