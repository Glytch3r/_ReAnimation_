-- Reanimation --

-- After death, if the player is infected they will have the choice to continue as a zombie. If they choose yes, then
-- they'll get respawned at the same location, same inventory and everything, and they'll be able to continue playing
-- from there



require "ISUI/ISPostDeathUI"

local og_ISPostDeathUICreateChildren = ISPostDeathUI.createChildren

function ISPostDeathUI:createChildren()
    -- TODO Ugly, just for test, find a better way to add a button before PostDeath_Respawn
    local buttonWid = 250
    local buttonHgt = 40
    local buttonGapY = 12
    local buttonX = 0
    local buttonY = 0       -- TODO Fix this, too low, but if it gets to - something then it just breaks collisionssd
    local totalHgt = (buttonHgt * 3) + (buttonGapY * 2)

    self:setWidth(buttonWid)
    self:setHeight(totalHgt)
    -- must set these after setWidth/setHeight or getKeepOnScreen will mess them up
    self:setX(self.screenX + (self.screenWidth - buttonWid) / 2)
    self:setY(self.screenY + (self.screenHeight - 40 - totalHgt))

    local button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_RespawnAsZed"), self, self.onRespawnAsZed)
    self:configButton(button)
    self:addChild(button)
    self.buttonRespawn = button
    buttonY = buttonY + buttonHgt + buttonGapY

    local button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_Respawn"), self, self.onRespawn)
    self:configButton(button)
    self:addChild(button)
    self.buttonRespawn = button
    buttonY = buttonY + buttonHgt + buttonGapY

    button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_Exit"), self, self.onExit)
    self:configButton(button)
    self:addChild(button)
    self.buttonExit = button
    buttonY = buttonY + buttonHgt + buttonGapY

    button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_Quit"), self, self.onQuitToDesktop)
    self:configButton(button)
    self:addChild(button)
    self.buttonQuit = button


end




RA_respawned_player = nil


-- Retrieve data from the old player after OnDeath and reapplies to a new one here
function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")

    -- TODO Reapply correct appearances
    -- TODO Reapply inventory
    -- TODO Reapply traits
    -- TODO Delete player zombie NPC

    local old_player = getPlayer()
    local old_player_cell = old_player:getCell()
    --TempTable_RespawnedPlayerVisuals_2.forename = old_player:getForname()
    --TempTable_RespawnedPlayerVisuals_2.surname = old_player:getSurname()


    -- Respawn in the same position
    getWorld():setLuaSpawnCellX(old_player_cell:getWorldX())
    getWorld():setLuaSpawnCellY(old_player_cell:getWorldY())
    getWorld():setLuaPosX(old_player:getX())
    getWorld():setLuaPosY(old_player:getY())
    getWorld():setLuaPosZ(old_player:getZ())


    -- We need to generate a new CreateSurvivor whenever the game starts, and then reapply it
    -- SurvivorFactory.CreateSurvivor()
    local new_player = SurvivorFactory.CreateSurvivor()
    local is_female = old_player:isFemale()

    new_player:setFemale(is_female)

    local new_player_visual = new_player:getHumanVisual()
    new_player_visual:clear()
    new_player_visual:copyFrom(old_player:getHumanVisual())

    -- TODO Set zombie skin texture for the correct skin
    local old_skin = old_player:getHumanVisual():getSkinTexture()
    local new_skin_id = tonumber(string.match(old_skin, "0(%d)"))

    local new_skin
    if is_female then
        new_skin = "F_"
    else

        new_skin = "M_"
    end

    if new_skin_id > 4 then
        new_skin_id = 4
    end
    new_skin = new_skin .. "ZedBody0" .. new_skin_id .. "_level1"
    print("RA: new_skin " .. new_skin)
    new_player_visual:setSkinTextureName(new_skin)

    -- TODO Set a fake name to the user so that we can track him down when he reanimates

    new_player:setForename("Test")     -- TODO This is wrong, it returns only Bob Smith
    new_player:setSurname("Test 2")

    RA_respawned_player = old_player

    -- Cycle on old worn items for the old player
    --for index,item in ipairs(worn_items) do
    --    print("RA: " .. item)
    --    new_player:setWornItem(item:getBodyLocation(), item)
    --
    --end

    getWorld():setLuaPlayerDesc(new_player)        --Survivor_Desc is just fancy human visual
    getWorld():getLuaTraits():clear()
    MainScreen.instance.avatar = nil

    --MainScreen.instance.avatar = nil
    --MainScreen.instance.desc = old_player
    -- MainScreen.instance.desc:setForename(forename)
    -- MainScreen.instance.desc:setSurname(surname)

    if ISPostDeathUI.instance[self.playerIndex] then
        ISPostDeathUI.instance[self.playerIndex]:removeFromUIManager()
        ISPostDeathUI.instance[self.playerIndex] = nil
    end





    if not self.joypadData then
        setPlayerMouse(nil)
        return
    end

    local controller = self.joypadData.controller
    local joypadData = JoypadState.joypads[self.playerIndex + 1]
    JoypadState.players[self.playerIndex + 1] = joypadData
    joypadData.player = self.playerIndex
    joypadData:setController(controller)
    joypadData:setActive(true)
    local username = nil
    if isClient() and self.playerIndex > 0 then
        username = CoopUserName.instance:getUserName()
    end
    setPlayerJoypad(self.playerIndex, self.joypadIndex, nil, username)

    self.joypadData.focus = nil
    self.joypadData.lastfocus = nil
    self.joypadData.prevfocus = nil
    self.joypadData.prevprevfocus = nil

end



local function OnCreateZedPlayer(player_index, player)
    -- Reapplies the visuals

    local mod_data = player:getModData().RA
    if mod_data then
        if mod_data.is_zed then
            player:setInvisible(true)

        end
    end

    if RA_respawned_player == nil then return end

    local old_player_id = RA_respawned_player:getOnlineID()
    local old_player_items = RA_player_items

    player:setInvisible(true)
    player:getModData().RA = {
        is_zed = true
    }


    local player_inv = player:getInventory()

    for _, v in pairs(old_player_items) do
        print("RA: Reading item .. ")

        -- TODO Ignore belt
        player_inv:AddItem(v:getFullType())
        player:setWornItem(v:getBodyLocation(), v)


    end


    -- TODO Search in nearby squares, check getReanimatedPlayer()
    local zombies = getCell():getObjectList()
    for i=zombies:size(),1,-1 do
        local zombie = zombies:get(i-1)
        if instanceof(zombie, "IsoZombie") then
            print("RA: Listing zombie " .. tostring(i))
            local name = zombie:getFullName()

            if name == "None None" then
                print("RA: Found reanimated player")
                zombie:resetForReuse()
                zombie:removeFromWorld()    -- TODO it doesn't really delete it, it remains somehow
                zombie:removeFromSquare()
            end

            -- TODO Add a stronger check, if there is another reanimated player in there he's gonna get deleted
            --if reanimated_player ~= nil then
            --    print("RA: Found reanimated player")
            --    zombie:removeFromWorld()
            --    zombie:removeFromSquare()
            --end



        end
    end



    -- TODO we need to teleport the old player zombie away or something like that



    RA_respawned_player = nil


end
RA_player_items = {}
local function OnDeathSaveWornItems(player)

    local worn_items = player:getWornItems()
    print("RA: Saving following worn items")
    RA_player_items = {}

    for i=0, worn_items:size()-1 do
        local item = worn_items:getItemByIndex(i)
        print("RA: Saving " ..tostring(i))
        table.insert(RA_player_items, item)
        --print("RA: item => " .. item)
    end
end

Events.OnCreatePlayer.Add(OnCreateZedPlayer)
Events.OnPlayerDeath.Add(OnDeathSaveWornItems)