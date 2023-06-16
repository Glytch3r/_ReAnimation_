-------------------------------
-------- REANIMATION ----------
-------------------------------
-- Initialization manager for a new zed player

RA_Respawn = {}

RA_Respawn.isRespawningAsZed = false
RA_Respawn.playerItems = {}



-- Manages normal login
local function OnCreatePlayerLogin(playerIndex, player)

    local reanimationData = RA_Common.GetModData()
    if reanimationData.isZed then

        player:setZombiesDontAttack(true)
        player:setInvisible(true)       -- Invisibility is enough to be visibile to players but not to zombies.
        player:setCanShout(false)

        --[[
            Overrides some actions, such as opening the door via click.
            Interacting via the E key is managed through other methods
        ]]
        RA_Core.DisableMapActions()
        RA_Core.DisableClickInteractions()
        RA_Core.DisableHotbar()

        Events.OnKeyPressed.Add(RA_Core.DisableDoorAndWindowInteraction)


        -- Starts a OnTick function to manage the zed
        RA_Core.StartZedPlayerUpdate()
        --AddZedFists()               -- TODO remove this
    end

end

Events.OnCreatePlayer.Add(OnCreatePlayerLogin)

-- Manages creation of a new Zed Player (as in, just respawned as a zombie)
local function OnCreateNewZedPlayer(playerIndex, player)

    if RA_Respawn.isRespawningAsZed then
        local playerInv = player:getInventory()

        -- Reapplies the old worn items to the new player
        for _, item in pairs(RA_Respawn.playerItems) do
            if string.find(item:getFullType(), "Belt") ~= true then
                local newItem = playerInv:AddItem(item)
                player:setWornItem(newItem:getBodyLocation(), newItem)
            end
        end

        -- Find the old player zombie and deletes it
        local zombies = getCell():getObjectList()
        for i=zombies:size(),1,-1 do
            local zombie = zombies:get(i-1)
            if instanceof(zombie, "IsoZombie") then
                --print("RA: Listing zombie " .. tostring(i))
                local name = zombie:getFullName()
                print(name)
                if name == "None None" then
                    --    print("RA: Found reanimated player")
                    zombie:resetForReuse()
                    zombie:removeFromWorld()
                    zombie:removeFromSquare()
                end
            end
        end

        -- Reset this stuff
        RA_Respawn.isRespawningAsZed = false
        RA_Respawn.playerItems = nil

        -- Set is_zed to true
        local reanimationData = RA_Common.GetModData()
        reanimationData.isZed = true

        -- Startup the player with the remaining stuff
        OnCreatePlayerLogin(_, player)
    end

end

Events.OnCreatePlayer.Add(OnCreateNewZedPlayer)

