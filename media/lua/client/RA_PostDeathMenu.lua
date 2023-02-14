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



TempTable_RespawnedPlayerVisuals = nil
TempTable_Visuals = {
    surname = nil,
    forename = nil,
    skin = nil,
    is_female = nil,
    hair_model = nil,
    hair_color = nil,

}

TempTable_old_player = nil


-- Retrieve data from the old player after OnDeath and reapplies to a new one here
function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")

    -- TODO Reapply correct appearances
    -- TODO Reapply inventory
    -- TODO Reapply traits
    -- TODO Delete player zombie NPC

    local old_player = getPlayer()
    local old_player_cell = old_player:getCell()
    TempTable_RespawnedPlayerVisuals = old_player:getHumanVisual()
    --TempTable_RespawnedPlayerVisuals_2.forename = old_player:getForname()
    --TempTable_RespawnedPlayerVisuals_2.surname = old_player:getSurname()

    TempTable_Visuals.is_female = old_player:isFemale()
    TempTable_Visuals.model = old_player:getModel()
    TempTable_Visuals.skin = old_player:getHumanVisual():getSkinTexture()

    -- Respawn in the same position
    getWorld():setLuaSpawnCellX(old_player_cell:getWorldX())
    getWorld():setLuaSpawnCellY(old_player_cell:getWorldY())
    getWorld():setLuaPosX(old_player:getX())
    getWorld():setLuaPosY(old_player:getY())
    getWorld():setLuaPosZ(old_player:getZ())


    -- We need to generate a new CreateSurvivor whenever the game starts, and then reapply it
    -- SurvivorFactory.CreateSurvivor()


    getWorld():setLuaPlayerDesc()        --Survivor_Desc is just fancy human visual
    getWorld():getLuaTraits():clear()
    MainScreen.instance.avatar = nil

    --MainScreen.instance.avatar = nil
    --MainScreen.instance.desc = old_player





    TempTable_old_player = old_player

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

    if TempTable_old_player == nil then return end

    player:setInvisible(true)
    --
    --player:setFemale(TempTable_Visuals.is_female)       -- TODO This should be enough but it doesn't work
    --
    --local new_player_visual = player:getHumanVisual()
    --new_player_visual:clear()
    --new_player_visual:copyFrom(TempTable_RespawnedPlayerVisuals)
    --new_player_visual:setSkinTextureName(TempTable_Visuals.skin)
    --TempTable_old_player.removeFromWorld()

    -- TODO we need to teleport the old player zombie away or something like that
    TempTable_old_player = nil


end


Events.OnCreatePlayer.Add(OnCreateZedPlayer)