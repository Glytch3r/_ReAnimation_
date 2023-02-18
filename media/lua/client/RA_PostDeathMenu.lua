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

    local button
    local dead_player = getPlayer()
    local dead_player_body_damage = dead_player:getBodyDamage()
    local ra_data = RA_GetRAData()

    if dead_player_body_damage:isInfected() and not ra_data.is_zed  then
        button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_RespawnAsZed"), self, self.onRespawnAsZed)
        self:configButton(button)
        self:addChild(button)
        self.buttonRespawn = button
        buttonY = buttonY + buttonHgt + buttonGapY
    end


    button = ISButton:new(buttonX, buttonY, buttonWid, buttonHgt, getText("IGUI_PostDeath_Respawn"), self, self.onRespawn)
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


RA_is_respawning_as_zed = false
RA_player_items = {}

-- Retrieve data from the old player after OnDeath and reapplies to a new one here
function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")
    -- TODO Reapply inventory
    -- TODO Reapply traits
    -- TODO Delete player zombie NPC

    local old_player = getPlayer()
    local old_player_cell = old_player:getCell()

    -- Respawn in the same position
    getWorld():setLuaSpawnCellX(old_player_cell:getWorldX())
    getWorld():setLuaSpawnCellY(old_player_cell:getWorldY())
    getWorld():setLuaPosX(old_player:getX())
    getWorld():setLuaPosY(old_player:getY())
    getWorld():setLuaPosZ(old_player:getZ())

    -- We need to generate a new CreateSurvivor whenever the game starts, and then reapply it
    local new_player = SurvivorFactory.CreateSurvivor()
    local is_female = old_player:isFemale()

    new_player:setFemale(is_female)

    local new_player_visual = new_player:getHumanVisual()
    new_player_visual:clear()
    new_player_visual:copyFrom(old_player:getHumanVisual())

    -- Set zombie skin texture for the correct skin
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

    RA_is_respawning_as_zed = true

    getWorld():setLuaPlayerDesc(new_player)        --Survivor_Desc is just fancy human visual
    getWorld():getLuaTraits():clear()
    MainScreen.instance.avatar = nil
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


-- Fill RA_player_items
local function OnDeathSaveWornItems(player)
    -- TODO Add a check, this shouldn't be run when the player is not infected


    local worn_items = player:getWornItems()
    print("RA: Saving following worn items")
    RA_player_items = {}

    for i=0, worn_items:size()-1 do
        local item = worn_items:getItemByIndex(i)
        print("RA: Saving " ..tostring(i))
        table.insert(RA_player_items, item)
    end
end
Events.OnPlayerDeath.Add(OnDeathSaveWornItems)