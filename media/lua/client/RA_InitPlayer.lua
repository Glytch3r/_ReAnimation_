-------------------------------
-------- REANIMATION ----------
-------------------------------
-- Initialization manager for a new zed player


-- Manages normal login
local function OnCreatePlayerLogin(player_index, player)

    local ra_data = RA_GetRAData()
    if ra_data.is_zed then

        player:setZombiesDontAttack(true)
        player:setInvisible(true)
        player:setCanShout(false)

        -- Override to some actions such as opening the door via click. Interacting via E key is managed through other methods
        RA_DisableMapActions()
        RA_DisableVariousClickInteractions()
        RA_DisableHotbarUsage()

        Events.OnKeyPressed.Add(RA_DisableDoorAndWindowInteraction)


        -- Starts a OnTick function to manage the zed
        RA_StartPlayerZedUpdate()
        --AddZedFists()               -- TODO remove this
    end

end
Events.OnCreatePlayer.Add(OnCreatePlayerLogin)

-- Manages creation of a new Zed Player (as in, just respawned as a zombie)
local function OnCreateNewZedPlayer(player_index, player)

    if RA_is_respawning_as_zed then
        local old_player_items = RA_player_items
        local player_inv = player:getInventory()

        -- Reapplies the old worn items to the new player
        for _, v in pairs(old_player_items) do
            if string.find(v:getFullType(), "Belt") ~= true then
                local new_item = player_inv:AddItem(v)
                player:setWornItem(new_item:getBodyLocation(), new_item)
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
        RA_is_respawning_as_zed = false
        RA_player_items = nil

        -- Set is_zed to true
        local ra_data = RA_GetRAData()
        ra_data.is_zed = true

        -- Startup the player with the remaining stuff
        OnCreatePlayerLogin(_, player)
    end

end
Events.OnCreatePlayer.Add(OnCreateNewZedPlayer)

