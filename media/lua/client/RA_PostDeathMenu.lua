
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

-- Retrieve data from the old player after OnDeath and reapplies to a new one here
function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")

	-- TODO use CoopCharacterCreation as a base, accept1 in particular


    -- getWorld():setLuaPlayerDesc(MainScreen.instance.desc)
	-- getWorld():getLuaTraits():clear()

	-- -- TODO Get correct traits from older player... or do we actually need them?


	-- getWorld():


	-- for i,v in pairs(self.charCreationProfession.listboxTraitSelected.items) do
	-- 	getWorld():addLuaTrait(v.item:getType())
	-- end
	MainScreen.instance.avatar = nil


	local forename = "Test"--getOldPlayerName()
	local surname =  "Test" --getOldPlayerSurname()


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
	local joypadData = JoypadState.joypads[self.playerIndex+1]
	JoypadState.players[self.playerIndex+1] = joypadData
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