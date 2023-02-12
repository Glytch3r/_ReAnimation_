
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


function ISPostDeathUI:onRespawnAsZed()
    print("Respawning as zombie")

end