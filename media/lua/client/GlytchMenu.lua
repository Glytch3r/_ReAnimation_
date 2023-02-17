GlytchMenu = ISCollapsableWindow:derive("GlytchMenu");
--require "SOS_Events_Functions"
GlytchMenu.cheat = true
GlytchMenu.instance = nil
Glytch3rtest = false
function GlytchMenu.openPanel(playerObj)
    if GlytchMenu.instance == nil then
        local window = GlytchMenu:new(1920 - 400, 1080 - 600 - 40, 155, 580, playerObj)
        window:initialise()
        window:addToUIManager()

    end
    GlytchMenu.instance = window
end

local function cleanArea()
    local rad = 5
    local pl = getPlayer()
    local x, y, z = pl:getX(), pl:getY(), pl:getZ()
    for xx = -rad, rad do
        for yy = -rad, rad do
            local square = pl:getCell():getGridSquare(x + xx, y + yy, z)
            for i = 0, square:getObjects():size() - 1 do
                local obj = square:getObjects():get(i)
                local spr = obj:getSprite()

                if spr then
                    debugScenarios.Trailer3Scenario_Building.removeItemsButFloor(square:getX(), square:getY(), square:getZ())
                end
            end
        end
    end
end
local function PerkLevelup(player, perkType)
    local perkLevel = player:getPerkLevel(perkType);
    if perkLevel < 10 then
        player:LevelPerk(perkType, false);
        player:getXp():setXPToLevel(perkType, player:getPerkLevel(perkType));
        SyncXp(player)
    end
end
--**************************            	   **************************
--							     header*
--**************************            	   **************************


local opTitle1 = "1 Admin"
local opTitle2 = "2 noclip Toggle"
local opTitle3 = "3 Ghost Toggle"
local opTitle4 = "4 Tag"
local opTitle5 = "5 BrushTool"
local opTitle6 = "6 Suicide"
local opTitle7 = "7 JumpScare"
local opTitle8 = "8 WhereAmI"
local opTitle9 = "9 Glytch light"
local opTitle10 = "10 FlipVehicle"
local opTitle11 = "11 despawnTrees"
local opTitle12 = "12 ClearGround"
local opTitle13 = "13 Spawn Car"
local opTitle14 = "14 remove zed"
local opTitle15 = "15 add zed"
local opTitle16 = "16 fullheal"

local walktype = 1
--**************************            	   **************************
--								 body*
--**************************            	   **************************
function GlytchMenu:onClick(button)

    if button.internal == opTitle1 then
        --start----------------------               ---------------------------start
        print(opTitle1);
        getPlayer():Say(opTitle1)
        --[[ local result = "/setaccesslevel ".. getPlayer():getUsername() .." admin"; --Clipboard.setClipboard(result); print(result)
        SendCommandToServer(string.format("/setaccesslevel Glytch3r admin\"")) ]]
        setAdmin(true)
        getPlayer():setGodMod(true)
        ISFastTeleportMove.cheat = true
        getPlayer():setUnlimitedEndurance(true)
        getPlayer():setUnlimitedCarry(true)
        getPlayer():setBuildCheat(true)
        getPlayer():setFarmingCheat(true)
        getPlayer():setHealthCheat(true)
        getPlayer():setMechanicsCheat(true)
        getPlayer():setMovablesCheat(true)
        getDebugOptions():setBoolean("Cheat.Recipe.KnowAll", true)
        getPlayer():setZombiesDontAttack(true)
        getPlayer():setCanSeeAll(true)
        getPlayer():setNetworkTeleportEnabled(true)
        --getPlayer():setShowMPInfos(true)

        for i = 0, TraitFactory.getTraits():size() - 1 do
            local trait = TraitFactory.getTraits():get(i);
            if trait:getCost() >= 0 then
                if not getPlayer():HasTrait(trait:getType()) then
                    getPlayer():getTraits():add(trait:getType())
                end
            else
                if getPlayer():HasTrait(trait:getType()) then
                    getPlayer():getTraits():remove()
                end
            end
        end

        for i = 0, Perks.getMaxIndex() - 1 do

            perk = PerkFactory.getPerk(Perks.fromIndex(i));
            PerkLevelup(getPlayer(), perk);
        end

        --end----------------------               ---------------------------end

    elseif button.internal == opTitle2 then
        print(opTitle2);
        getPlayer():Say(opTitle2)
        --start----------------------            ---------------------------start
        getPlayer():setNoClip(not getPlayer():isNoClip());


        --end----------------------            ---------------------------end

    elseif button.internal == opTitle3 then
        print(opTitle3);
        getPlayer():Say(opTitle3)
        --start----------------------           ---------------------------start
        getPlayer():setInvisible(not getPlayer():isInvisible())
        getPlayer():setGhostMode(not getPlayer():isGhostMode())


        --end----------------------            ---------------------------end
    elseif button.internal == opTitle4 then
        print(opTitle4);
        getPlayer():Say(opTitle4)
        --start----------------------         ---------------------------start
        getPlayer():getDescriptor():setForename("")
        getPlayer():getDescriptor():setSurname(" ")
        getPlayer():setUsername("")
        getPlayer():setDisplayName("")
        getPlayer():setShowAdminTag(false);
        --[[ sendPlayerStatsChange(ISPlayerStatsUI.instance.char);
        local onlinePlayers = getOnlinePlayers()
        for i=0, onlinePlayers:size()-1 do
            local aPlayer = getOnlinePlayers():get(i)
            sendPlayerExtraInfo(aPlayer)
        end ]]

        --end----------------------            ---------------------------end
    elseif button.internal == opTitle5 then
        print(opTitle5);
        getPlayer():Say(opTitle5)
        --start----------------------         ---------------------------start
        BrushToolManager.openPanel(getPlayer())




        --end----------------------            ---------------------------end
    elseif button.internal == opTitle6 then
        print(opTitle6);
        getPlayer():Say(opTitle6)
        --start----------------------         ---------------------------start
        getPlayer():setGodMod(false);
        getPlayer():Kill(getPlayer())

        --end----------------------            ---------------------------end
    elseif button.internal == opTitle7 then
        print(opTitle7);
        getPlayer():Say(opTitle7)
        --start----------------------         ---------------------------start

        getSoundManager():PlayWorldSound('ZombieSurprisedPlayer', getPlayer():getSquare(), 0, 55, 10, false);


        --end----------------------            ---------------------------end
    elseif button.internal == opTitle8 then
        print(opTitle8);
        getPlayer():Say(opTitle8)
        --start----------------------         ---------------------------start

        local whereVar = "x " .. math.floor(getPlayer():getX()) .. " y " .. math.floor(getPlayer():getY()) .. "  z " .. math.floor(getPlayer():getZ());
        local whereVar2 = 'teleportto ' .. math.floor(getPlayer():getX()) .. ", " .. math.floor(getPlayer():getY()) .. " ," .. math.floor(getPlayer():getZ());
        Clipboard.setClipboard(whereVar2);
        print("Clipboard Saved: " .. whereVar);

        --end----------------------            ---------------------------end
    elseif button.internal == opTitle9 then
        print(opTitle9);
        getPlayer():Say(opTitle9)
        --start----------------------         ---------------------------start
        local pl = getPlayer();
        pl:getCell():addLamppost(IsoLightSource.new(pl:getX(), pl:getY(), pl:getZ(), 255, 255, 255, 255))
        --end----------------------            ---------------------------end
    elseif button.internal == opTitle10 then
        print(opTitle10);
        getPlayer():Say(opTitle10)
        --start----------------------         ---------------------------start

        getCar():flipUpright()

        --end----------------------            ---------------------------end
    elseif button.internal == opTitle11 then
        print(opTitle11);
        getPlayer():Say(opTitle11)
        --start----------------------         ---------------------------start

        despawnTreesArea()

        --end----------------------            ---------------------------end
    elseif button.internal == opTitle12 then
        print(opTitle12);
        getPlayer():Say(opTitle12)
        --start----------------------            ---------------------------start

        cleanArea()
        --end----------------------            ---------------------------end
    elseif button.internal == opTitle13 then
        print(opTitle13);
        getPlayer():Say(opTitle13)
        --start----------------------            ---------------------------start
        spawnv()
        --end----------------------            ---------------------------end
    elseif button.internal == opTitle14 then
        print(opTitle14);
        getPlayer():Say(opTitle14)
        --start----------------------            ---------------------------start
        SendCommandToServer(string.format("/removezombies -remove true")) --getPlayer():playEmote("SitZed2")
        --**************************            	   **************************
        --end----------------------            ---------------------------end
    elseif button.internal == opTitle15 then
        print(opTitle15);
        getPlayer():Say(opTitle15)
        --start----------------------            ---------------------------start
        print('nothing')
        --**************************            	   **************************
        --end----------------------            ---------------------------end
    elseif button.internal == opTitle16 then
        --print(opTitle16); getPlayer():Say(opTitle16)
        --start----------------------            ---------------------------start

        glytchinjury();
        getPlayer():getModData()['undeadheal'] = true
        getPlayer():getBodyDamage():setOverallBodyHealth(100)
        timer:Simple(4, function()
            getPlayer():getModData()['undeadheal'] = false
        end)

        --**************************

    end
end

function GlytchMenu:createChildren()
    ISCollapsableWindow.createChildren(self);

    local th = self:titleBarHeight()
    local buttonWid = 80
    local buttonHgt = 24

    self.opt1 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, th + 10, buttonWid, buttonHgt, opTitle1, self, GlytchMenu.onClick);
    self.opt1.internal = opTitle1;
    self.opt1:initialise();
    self.opt1:instantiate();
    self:addChild(self.opt1);

    self.opt2 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt1:getBottom() + 10, buttonWid, buttonHgt, opTitle2, self, GlytchMenu.onClick);
    self.opt2.internal = opTitle2;
    self.opt2:initialise();
    self.opt2:instantiate();
    self:addChild(self.opt2);

    self.opt3 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt2:getBottom() + 10, buttonWid, buttonHgt, opTitle3, self, GlytchMenu.onClick);
    self.opt3.internal = opTitle3;
    self.opt3:initialise();
    self.opt3:instantiate();
    self:addChild(self.opt3);

    self.opt4 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 + 12, self.opt3:getBottom() + 10, buttonWid - 24, buttonHgt - 5, opTitle4, self, GlytchMenu.onClick);
    self.opt4.internal = opTitle4;
    self.opt4:initialise();
    self.opt4:instantiate();
    self:addChild(self.opt4);

    self.opt5 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt4:getBottom() + 10, buttonWid, buttonHgt, opTitle5, self, GlytchMenu.onClick);
    self.opt5.internal = opTitle5;
    self.opt5:initialise();
    self.opt5:instantiate();
    self:addChild(self.opt5);

    self.opt6 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt5:getBottom() + 10, buttonWid, buttonHgt, opTitle6, self, GlytchMenu.onClick);
    self.opt6.internal = opTitle6;
    self.opt6:initialise();
    self.opt6:instantiate();
    self:addChild(self.opt6);

    self.opt7 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt6:getBottom() + 10, buttonWid, buttonHgt, opTitle7, self, GlytchMenu.onClick);
    self.opt7.internal = opTitle7;
    self.opt7:initialise();
    self.opt7:instantiate();
    self:addChild(self.opt7);

    self.opt8 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt7:getBottom() + 10, buttonWid, buttonHgt, opTitle8, self, GlytchMenu.onClick);
    self.opt8.internal = opTitle8;
    self.opt8:initialise();
    self.opt8:instantiate();
    self:addChild(self.opt8);

    self.opt9 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt8:getBottom() + 10, buttonWid, buttonHgt, opTitle9, self, GlytchMenu.onClick);
    self.opt9.internal = opTitle9;
    self.opt9:initialise();
    self.opt9:instantiate();
    self:addChild(self.opt9);

    self.opt10 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt9:getBottom() + 10, buttonWid, buttonHgt, opTitle10, self, GlytchMenu.onClick);
    self.opt10.internal = opTitle10;
    self.opt10:initialise();
    self.opt10:instantiate();
    self:addChild(self.opt10);

    self.opt11 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt10:getBottom() + 10, buttonWid, buttonHgt, opTitle11, self, GlytchMenu.onClick);
    self.opt11.internal = opTitle11;
    self.opt11:initialise();
    self.opt11:instantiate();
    self:addChild(self.opt11);

    self.opt12 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt11:getBottom() + 10, buttonWid, buttonHgt, opTitle12, self, GlytchMenu.onClick);
    self.opt12.internal = opTitle12;
    self.opt12:initialise();
    self.opt12:instantiate();
    self:addChild(self.opt12);

    self.opt13 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt12:getBottom() + 10, buttonWid, buttonHgt, opTitle13, self, GlytchMenu.onClick);
    self.opt13.internal = opTitle13;
    self.opt13:initialise();
    self.opt13:instantiate();
    self:addChild(self.opt13);

    self.opt14 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt13:getBottom() + 10, buttonWid, buttonHgt, opTitle14, self, GlytchMenu.onClick);
    self.opt14.internal = opTitle14;
    self.opt14:initialise();
    self.opt14:instantiate();
    self:addChild(self.opt14);

    self.opt15 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt14:getBottom() + 10, buttonWid, buttonHgt, opTitle15, self, GlytchMenu.onClick);
    self.opt15.internal = opTitle15;
    self.opt15:initialise();
    self.opt15:instantiate();
    self:addChild(self.opt15);

    self.opt16 = ISButton:new(self:getWidth() / 2 - buttonWid / 2 - 15, self.opt15:getBottom() + 10, buttonWid, buttonHgt, opTitle16, self, GlytchMenu.onClick);
    self.opt16.internal = opTitle16;
    self.opt16:initialise();
    self.opt16:instantiate();
    self:addChild(self.opt16);
end
--**************************            	   **************************
function GlytchMenu:close()
    GlytchMenu.instance = nil
    self:setVisible(false);
    self:removeFromUIManager()
end

function GlytchMenu:new(x, y, width, height, character)
    local o = ISCollapsableWindow.new(self, x, y, width, height);
    o:setResizable(true)
    o.title = "Glytch3r"
    o.character = character

    return o
end

--[[ 

spdcont = {};
spdcont.previousSpeed = 1;

spdcont.onKeyPressed = function(key)

	if not MainScreen.instance or not MainScreen.instance.inGame or MainScreen.instance:getIsVisible() then
		return
	end

	if key == getCore():getKey("Pause") then
		if not MainScreen.instance.inGame or MainScreen.instance:getIsVisible() then
			-- Default "Pause" is same as "Main Menu"
		elseif key == Keyboard.KEY_ESCAPE and getCell() and getCell():getDrag(0) then
			-- ToggleEscapeMenu does getCell():setDrag(nil)
		elseif getGameSpeed() > 0 then
			spdcont.previousSpeed = getGameTime():getTrueMultiplier();
			setGameSpeed(0);
		else
			setGameSpeed(1);
			getGameTime():setMultiplier(spdcont.previousSpeed or 1);
			spdcont.previousSpeed = nil;
		end
	elseif key == getCore():getKey("Normal Speed") then
		setGameSpeed(1);
		getGameTime():setMultiplier(1);
	elseif key == getCore():getKey("Fast Forward x1") then
		setGameSpeed(2);
		getGameTime():setMultiplier(5);
	elseif key == getCore():getKey("Fast Forward x2") then
		setGameSpeed(3);
		getGameTime():setMultiplier(20);
	elseif key == getCore():getKey("Fast Forward x3") then
		setGameSpeed(4);
		getGameTime():setMultiplier(40);
	end
end


Events.OnKeyPressed.Add(spdcont.onKeyPressed);
 ]]



function GlytchMenu.press(key)

    if (key == 199) then
        --home
        if not (getCore():getDebug() or isAdmin()) then
            return ;
        end
        GlytchMenu.openPanel()
        return key
    end

    if key == getCore():getKey("Pause") then

        return key
    end
end

Events.OnKeyPressed.Add(GlytchMenu.press);


-- function detecttiles()
-- if Glytch3rtest == true then
-- local sq = getPlayer():getSquare() 
-- for i=0, sq:getObjects():size()-1 do
-- local obj = sq:getObjects():get(i)
-- local spr = obj:getSprite():getName()
-- if spr and obj then
-- print(spr) end
-- end
-- end
-- end

-- Events.OnPlayerMove.Add(detecttiles)