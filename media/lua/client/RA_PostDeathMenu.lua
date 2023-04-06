-- Reanimation --

-- After death, if the player is infected they will have the choice to continue as a zombie. If they choose yes, then
-- they'll get respawned at the same location, same inventory and everything, and they'll be able to continue playing
-- from there

require "ISUI/ISPostDeathUI"
require "RA_InitPlayer"

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
    local deadPlayer = getPlayer()
    local deadPlayerBodyDamage = deadPlayer:getBodyDamage()
    local reanimationData = RA_Common.GetModData()

    if deadPlayerBodyDamage:isInfected() and not reanimationData.is_zed  then
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


-- Retrieve data from the old player after OnDeath and reapplies to a new one here
function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")
    -- TODO Reapply inventory
    -- TODO Reapply traits
    -- TODO Delete player zombie NPC

    local oldPlayer = getPlayer()
    local oldPlayerCell = oldPlayer:getCell()

    -- Respawn in the same position
    getWorld():setLuaSpawnCellX(oldPlayerCell:getWorldX())
    getWorld():setLuaSpawnCellY(oldPlayerCell:getWorldY())
    getWorld():setLuaPosX(oldPlayer:getX())
    getWorld():setLuaPosY(oldPlayer:getY())
    getWorld():setLuaPosZ(oldPlayer:getZ())

    -- We need to generate a new CreateSurvivor whenever the game starts, and then reapply it
    local newPlayer = SurvivorFactory.CreateSurvivor()
    local isFemale = oldPlayer:isFemale()

    newPlayer:setFemale(isFemale)

    local newPlayerVisual = newPlayer:getHumanVisual()
    newPlayerVisual:clear()
    newPlayerVisual:copyFrom(oldPlayer:getHumanVisual())

    -- Set zombie skin texture for the correct skin
    local oldSkin = oldPlayer:getHumanVisual():getSkinTexture()
    local newSkinId = tonumber(string.match(oldSkin, "0(%d)"))

    local newSkin = isFemale and "F" or "M"

    if newSkinId > 4 then
        newSkinId = 4
    end
    newSkin = newSkin .. "ZedBody0" .. newSkinId .. "_level1"
    print("RA: newSkin = " .. newSkin)
    newPlayerVisual:setSkinTextureName(newSkin)

    -- TODO Set a fake name to the user so that we can track him down when he reanimates
    newPlayer:setForename("Test")     -- TODO This is wrong, it returns only Bob Smith
    newPlayer:setSurname("Test 2")


    RA_Core.isRespawningAsZed = true

    getWorld():setLuaPlayerDesc(newPlayer)        --Survivor_Desc is just fancy human visual
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


    local wornItems = player:getWornItems()
    print("RA: Saving following worn items")

    RA_Respawn.playerItems = {}

    for i=0, wornItems:size()-1 do
        local item = wornItems:getItemByIndex(i)
        print("RA: Saving " .. tostring(i))
        table.insert(RA_Respawn.playerItems, item)
    end
end

Events.OnPlayerDeath.Add(OnDeathSaveWornItems)