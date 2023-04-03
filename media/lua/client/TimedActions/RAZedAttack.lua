-- TODO Remove this stuff






require "TimedActions/ISBaseTimedAction"

RAZedAttack = ISBaseTimedAction:derive("RAZedAttack");

local Reanimation = require("Reanimation")

-- Based on Brutal Handwork for now
local GetAvailableTargetCount = function(player, weapon)
    local prone = ArrayList.new()
    local stand = ArrayList.new()
    -- we want a player, and a hand weapon
    --if not checkValid(player, weapon) then return end

    SwipeStatePlayer.instance():calcValidTargets(player, weapon, true, prone, stand)
    local pC = prone:size()
    local sC = stand:size()

    --prone:clear()
    --stand:clear()

    return pC, sC
end

local directions = {
    [0] = IsoDirections.N,
    [1] = IsoDirections.NW,
    [2] = IsoDirections.W,
    [3] = IsoDirections.SW,
    [4] = IsoDirections.S,
    [5] = IsoDirections.SE,
    [6] = IsoDirections.E,
    [7] = IsoDirections.NE,
}
local getAttackSquares = function(player)
    local psquare = player:getSquare()
    if not psquare then return nil end
    local squares = {psquare}
    local currentDir = player:getDir():index()
    local leftIndex = currentDir+1
    if leftIndex > 7 then leftIndex=0 end
    --local middleIndex = currentDir
    local rightIndex = currentDir-1
    if rightIndex < 0 then rightIndex=7 end
    -- this should collect any additional squares, only if we nothing is in the way
    local sq = psquare:getAdjacentSquare(directions[leftIndex])
    if sq and not sq:isBlockedTo(psquare) then
        squares[#squares+1] = sq
    end
    sq = psquare:getAdjacentSquare(directions[currentDir])
    if sq and not sq:isBlockedTo(psquare) then
        squares[#squares+1] = sq
    end
    sq = psquare:getAdjacentSquare(directions[rightIndex])
    if sq and not sq:isBlockedTo(psquare) then
        squares[#squares+1] = sq
    end
    return squares
end
local addToHitList = function(list, obj, player, weapon, extraRange, vec)
    if obj and obj:isZombie() and obj:isAlive() then
        obj:getPosition(vec)
        if player:IsAttackRange(weapon, obj, vec, extraRange) then
            -- Add our zed, cache the distance to the player
            list[#list+1] = { obj = obj, dist = obj:DistTo(player) }
            if isDebugEnabled() then
                print("Found: " .. tostring(#list) .. " | Distance: " .. tostring(list[#list].dist))
            end
        end
    end
end

local FindAndAttackTargets = function(player, weapon, extraRange)
    -- honor the max hit
    local maxHit = (SandboxVars.MultiHitZombies and weapon:getMaxHitCount()) or 1

    -- this seems to be the default sooooooooo
    if extraRange == nil then extraRange = true end

    -- We do everything so we can attack non-zeds too
    --local objs = getCell():getObjectList()
    local found = {}
    local psquare = player:getSquare()
    if not psquare then return end -- can't attack
    local attackSquares = getAttackSquares(player)
    if not attackSquares then return end -- no squares?
    local vec = Vector3.new() -- reuse this
    for i=1, #attackSquares do
        local objs = attackSquares[i]:getMovingObjects()
        if objs then
            for j=0, objs:size()-1 do
                addToHitList(found, objs:get(j), player, weapon, extraRange, vec)
            end
        end
    end

    if #found > 0 then
        -- sort our found list by the closest zed
        table.sort(found, function(a,b)
            if a.obj:isZombie() then return true end
            if b.obj:isZombie() then return false end
            return a.dist < b.dist
        end)
        local count = 1
        local sound = false
        for _,v in ipairs(found) do
            -- hit em!
            --local damage, dmgDelta = BrutalAttack.calcDamage(player, weapon, v.obj, count)
            local damage = 1000
            local dmgDelta = 1
            if isDebugEnabled() then
                print("Damage: " .. tostring(damage) .. " | Delta: " .. tostring(dmgDelta))
            end
            v.obj:Hit(weapon, player, damage, false, dmgDelta)

            --v.zed:splatBloodFloor()
            if not sound then
                -- if we haven't played the sound yet, do so
                sound = true
                local zSound = weapon:getZombieHitSound()
                if zSound then v.obj:playSound(zSound) end
            end

            -- stop at maxhit
            if count >= maxHit then break end
            count = count + 1
        end

        luautils.weaponLowerCondition(weapon, player)
    else
        -- Swing and collide with anything not a zed
        SwipeStatePlayer.instance():ConnectSwing(player, weapon)
    end
end

















function RAZedAttack:isValid()
    return true
end

function RAZedAttack:waitToStart()
    return false
end

function RAZedAttack:update()
    -- we need to force the current facing direction until the animation starts
    if self.lockDir then
        self.character:setDirectionAngle(self.vec)
    end
end

-- safeguard to make sure that the action is ended
function RAZedAttack:beDone()
    self.character:setVariable("AttackAnim", false)
    self.character:setBlockMovement(false)
    self.character:setMeleeDelay(8)
end
function RAZedAttack:start()
    local prone, stand = GetAvailableTargetCount(self.character, self.weapon)
    if stand == 0 and prone > 0 then
        self:forceStop()
        -- Fall through to doing the character stomp or main attack
        self.character:DoAttack(self.chargeDelta)
        return
    end

    local atype = "rpunch1"
    FindAndAttackTargets(self.character, self.weapon, true)
    
    
    --TODO not sure but these code might help?
	--[[  
	self.character:setState("idle")
	self.character:setDirection(IsoDirections.S)
	self.character:setIsometric(false)
	self.character:setDoRandomExtAnimations(true)
	 ]]
	 
	 
    --self.character:setVariable("LCombatSpeed", self.speed)
    --self.character:setVariable("AttackAnim", true)
    --self:setActionAnim("LAttack")
    --self:setAnimVariable("LAttackType", atype)
end

function RAZedAttack:animEvent(event, parameter)
    if event == 'StartAttack' then
        if self.swingSound then
            self.character:getEmitter():playSound(self.swingSound)
        end
        self.lockDir = false
    elseif event == 'SetVariable' then
       -- local str = BrutalAttack.SplitValueString(parameter)
       -- for k,v in pairs(str) do
       --     self.character:setVariable(k,v)
        --end
    elseif event == 'AttackCollisionCheck' then
        FindAndAttackTargets(self.character, self.weapon, true)
        
        --if isClient() then
        --    sendClientCommand(self.character, "BrutalAttack", "Attack", {PID=self.character:getPlayerNum(), Offhand=true, extraRange=true})
        --end
    elseif event == 'BlockMovement' and SandboxVars.AttackBlockMovements then
        self.character:setBlockMovement((parameter == "TRUE" and true) or false)
    elseif event == 'EndAttack' then
        self:forceComplete()
    end
end

function RAZedAttack:stop()
    self:beDone()
    ISBaseTimedAction.stop(self)
end

function RAZedAttack:perform()
    self:beDone()
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
    triggerEvent("OnPlayerAttackFinished", self.character, self.weapon)
end

function RAZedAttack:new(character, weapon, chargeDelta)
    local o = ISBaseTimedAction.new(self, character)

    o.weapon = weapon
    o.speed = weapon:getBaseSpeed()
    o.maxTime = -1
    o.stopOnAim = false
    o.stopOnWalk = false
    o.stopOnRun = false

    o.useProgressBar = false

    o.swingSound = weapon:getSwingSound()
    o.hitSound = weapon:getZombieHitSound()

    o.vec = character:getDirectionAngle()
    -- Needed if we fall through
    o.chargeDelta = chargeDelta
    o.lockDir = true
    o.lHandAttack = true

    o.unarmed = weapon and weapon:getCategories():contains("Unarmed")

    return o
end