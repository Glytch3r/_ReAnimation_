
function lvlup()
--level up your stuff , useful for admins who just respawned
    local player = getPlayer()
    for i = 0, 11 -1 do 
        for i=0, Perks.getMaxIndex() - 1 do
        perkType = PerkFactory.getPerk(Perks.fromIndex(i));
            local perkLevel = player:getPerkLevel(perkType);
            if perkLevel < 10 then
                player:LevelPerk(perkType, false);
                player:getXp():setXPToLevel(perkType, player:getPerkLevel(perkType));
                SyncXp(player)
            end 
        end
    end

    for i=0,TraitFactory.getTraits():size()-1 do
    local trait = TraitFactory.getTraits():get(i);
        if trait:getCost() >= 0 then
            if not getPlayer():HasTrait(trait:getType()) then getPlayer():getTraits():add(trait:getType()) end            
        else
            if getPlayer():HasTrait(trait:getType()) then  getPlayer():getTraits():remove(trait:getType()) end           
        end
    end
end

function br()
	BrushToolChooseTileUI.openPanel(900, 20, getPlayer()) 
end


function crow()

	if not  getPlayer()  then return end 
	
	
	local pl = getPlayer() 
	local inv = pl:getInventory() 
	--if not inv:contains("Bones") then 
		pl:clearWornItems();
		inv:clear();
		pl:resetModel();
		local item = "Skin.Scare"
			local equip = inv:AddItem(item);
		equip:getVisual():setTextureChoice(ZombRand(1,25));
		pl:setWornItem(equip:getBodyLocation(), equip);
	--end
end

function glytch3r()

	if not  getPlayer()  then return end 
	if not isAdmin() then setAdmin(true) end
	
	local pl = getPlayer() 
	pl:getModData()['isUndead'] = true
	local inv = pl:getInventory() 
	--if not inv:contains("Bones") then 
		pl:clearWornItems();
		inv:clear();
		pl:resetModel();
		local item = "Skin.Bones"
		local equip = inv:AddItem(item);
		equip:getVisual():setTextureChoice(ZombRand(1,25));
		pl:setWornItem(equip:getBodyLocation(), equip);
	--end

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
	--getPlayer():setShowMPInfos(false)
	lvlup()
	SendCommandToServer(string.format("/removezombies -remove true"))
end

function wep()
	local pr = getPlayer():getPrimaryHandItem() 
	if not pr then return end
	if pr and  pr:isRanged() then 
		local mag = nil
		local gun = getPlayer():getPrimaryHandItem() 
		if  gun:getMagazineType() then 
			mag = InventoryItemFactory.CreateItem(gun:getMagazineType())
			mag:setCurrentAmmoCount(gun:getMaxAmmo())
			getPlayer():getInventory():AddItem(mag)
			if not gun:isContainsClip() then  
				ISTimedActionQueue.add(ISInsertMagazine:new(getPlayer(), gun, mag))
			end
		else
			gun:setCurrentAmmoCount(gun:getMaxAmmo());
		end
		getPlayer():getPrimaryHandItem():setRoundChambered(true) 
	end
end


function lamp()
	local pl = getPlayer(); pl:getCell():addLamppost(IsoLightSource.new(pl:getX(), pl:getY(), pl:getZ(), 255, 255, 255, 255)) 
end

function zedless()
SendCommandToServer(string.format("/removezombies -remove true"))
end

function throne()
        local teleportto = {12329, 6755, 0}
        SendCommandToServer(tostring("/teleportto \"" .. teleportto[1] .. ',' .. teleportto[2] .. ',' .. teleportto[3] .. "\" " .. " \""))
end

function flipv()
       getPlayer():getVehicle():flipUpright()
end
--[[ 
function Mortar.debris(square)
    local dug = IsoObject.new(square, "mortar_" .. ZombRand(64), "", false)
    square:AddTileObject(dug)
    if isClient() then
        dug:transmitCompleteItemToServer();
    end
    ISInventoryPage.renderDirty = true;
end

function Mortar.roll(chance)
    local roll = ZombRand(1, 101);
    if roll <= chance then
        return true
    end
end
 ]]
function kamikaze()
	local args = { x = getPlayer():getX(), y = getPlayer():getY(), z = getPlayer():getSquare():getZ() }
	sendClientCommand(getPlayer(), 'object', 'addExplosionOnSquare', args)
end

------------------------               ---------------------------
function despawnTreesArea(rad)
    local pl = getPlayer()
    local x, y, z = pl:getX(), pl:getY(), pl:getZ()
    for xx = -rad, rad do
        for yy = -rad, rad do
        local square =  pl:getCell():getGridSquare(x + xx, y + yy, z)
            for i=0, square:getObjects():size()-1 do
            local obj = square:getObjects():get(i)
            if instanceof(obj, "IsoTree") then
                sledgeDestroy(obj)
                obj:getSquare():transmitRemoveItemFromSquare(obj)
            end
            end
        end
    end
end
-- paste this code on debug console and it will despawn the trees around you configure the radius
--sample:
--despawnTreesArea(5) 
------------------------   despawngrass*            ---------------------------
function despawnGrass(rad)
    local pl = getPlayer()
    for xx = -rad, rad do
        for yy = -rad, rad do
			local square =  pl:getCell():getGridSquare(x + xx, y + yy, z)
            for i=0, square:getObjects():size()-1 do
				local obj = square:getObjects():get(i)
				local args = { x = square:getX(), y = square:getY(), z = square:getZ() }
				sendClientCommand(getPlayer(), 'object', 'removeGrass', args)
            end
        end
    end
end
-- paste this code on debug console and it will despawn the grass around you configure the radius
--sample:
--despawnGrass(5) 
------------------------               ---------------------------
-- function nograss()
	-- local sq = getPlayer():getSquare() 
	-- local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
	-- sendClientCommand(getPlayer(), 'object', 'removeGrass', args)
-- end

------------------------               ---------------------------
function statsreset()
	local player = getPlayer()
	local Stats = player:getStats()
	Stats:setAnger(0.0)
	Stats:setBoredom(0.0)
	Stats:setEndurance(1.0)
	Stats:setEndurancelast(1.0)
	Stats:setEndurancedanger(0.25)
	Stats:setEndurancewarn(0.5)
	Stats:setFatigue(0.0)
	Stats:setFitness(0.0)
	Stats:setHunger(0.0)
	Stats:setIdleboredom(0.0)
	Stats:setMorale(1.0)
	Stats:setStress(0.0)
	Stats:setStressFromCigarettes(0.0)
	Stats:setFear(0.0)
	Stats:setPanic(0.0)
	Stats:setSanity(1.0)
	Stats:setSickness(0.0)
	Stats:setPain(0.0)
	Stats:setDrunkenness(0.0)
	Stats:setNumVisibleZombies(0)
	Stats:setTripping(false)
	Stats:setTrippingRotAngle(0.0)
	Stats:setThirst(0.0)
end

------------------------  highestZ             ---------------------------
highZ = function(cx, cy)
	local pl = getPlayer()
	if not pl then return  end
	if cx == nil then cx = getPlayer():getX() end
	if cy == nil then cy = getPlayer():getY() end
	local cz = 8
	local res = ''
	for i = 0, 8-1  do
		cz=cz-1
		local check = getCell():getGridSquare(cx, cy, cz )
		if check then
			if res == '' then
				res = cz
			else
				res = res ..', '.. cz
			end
		end
	end
	print(res)	; 
	getPlayer():Say(tostring(res)) 
end
--highZ()
--highZ(getPlayer():getX(), getPlayer():getY())

------------------------               ---------------------------
function water(bool) 
	if bool then
		getSandboxOptions():getOptionByName("WaterShutModifier"):setValue(2147483647) 
	else
		getSandboxOptions():getOptionByName("WaterShutModifier"):setValue(-1) 
	end 
end

function power(bool) 
	if bool then
		getSandboxOptions():getOptionByName("ElecShutModifier"):setValue(2147483647) 
	else
		getSandboxOptions():getOptionByName("ElecShutModifier"):setValue(-1) 
	end 
end

 ------------------------               ---------------------------

function getCar()
	local car = nil
	if getPlayer():getVehicle() then car = getPlayer():getVehicle() 
		elseif getPlayer():getNearVehicle() then car = getPlayer():getNearVehicle()
		elseif  getPlayer():getUseableVehicle() then car = getPlayer():getUseableVehicle() 
	end	
	return car
end


function flipv()
	if not getCar() then return end
	getCar():flipUpright();
end

function nudgev()
	getCar():setAngles(ZombRand(0,6), ZombRand(0,6), ZombRand(0,6))
	getCar():setPhysicsActive(false)
end

function spawnv()
	local scripts = getScriptManager():getAllVehicleScripts()		
	local allV = scripts:size()+1	
	local randV = ZombRand(1, allV)
	local randM = scripts:get(randV):getModule():getName()
	local randN = scripts:get(randV):getName()
	local spawnV = randM..'.'..randN
	local command = "/addvehicle ".. spawnV .. ' '.. getPlayer():getUsername() 
	SendCommandToServer(command)
end
function delv()
	local vehicle = getCar()
	if vehicle then
	sendClientCommand(getPlayer(), "vehicle", "remove", { vehicle = vehicle:getId() })
	end
end
function cspawn()
	local vehicle = getCar()
	if vehicle then
	sendClientCommand(getPlayer(), "vehicle", "remove", { vehicle = vehicle:getId() })
	end
	spawnv()
end

function whereami()
	local whereVar = "X: "..math.floor(getPlayer():getX()) .."  Y: ".. math.floor(getPlayer():getY()) .."  Z: ".. math.floor(getPlayer():getZ()); Clipboard.setClipboard(whereVar); print("Clipboard Saved: " ..whereVar);
end
------------------------               ---------------------------
function togglegod()
	getPlayer():setGodMod(not getPlayer():isGodMod())
	sendPlayerExtraInfo(getPlayer())
	print(getPlayer():isGodMod())
end
function togglehide()
	getPlayer():setGhostMode(not getPlayer():isGhostMode());
	print(getPlayer():isGhostMode())
	sendPlayerExtraInfo(getPlayer())
end



------------------------               ---------------------------
function glytch3rFunc(player, context, worldobjects, test)

	
    local Option = context:addOption("Glytch Menu:")
    local subMenuGlytch = ISContextMenu:getNew(context)
    context:addSubMenu(Option, subMenuGlytch)

	subMenuGlytch:addOption("Glytch3r", worldobjects, glytch3r, player)
	subMenuGlytch:addOption("Lamp", worldobjects, lamp, player)
	subMenuGlytch:addOption("Wep", worldobjects, wep, player)

	subMenuGlytch:addOption("Brush Tool", worldobjects,  function() 	BrushToolChooseTileUI.openPanel(900, 20, getPlayer()) end , player)
	subMenuGlytch:addOption("Throne", worldobjects, throne, player)
	
	if getPlayer():isGodMod() then 
		subMenuGlytch:addOption("GodMode Off", worldobjects,  togglegod, player )
	else 
		subMenuGlytch:addOption("GodMode On", worldobjects,  togglegod, player )
	end
	
	if getPlayer():isGhostMode() then 
		subMenuGlytch:addOption("Invisible Off", worldobjects,  togglehide, player )
	else 
		subMenuGlytch:addOption("Invisible On", worldobjects,  togglehide, player )
	end
	
	if getPlayer():getModData()['countZed'] then 
		subMenuGlytch:addOption("ZedCount Off", worldobjects,  function() getPlayer():getModData()['countZed']=false end, player )
	else 
		subMenuGlytch:addOption("ZedCount On", worldobjects,  function() getPlayer():getModData()['countZed']=true end, player )
	end
	
end
Events.OnFillWorldObjectContextMenu.Add(glytch3rFunc)


Events.OnPostUIDraw.Remove(zedChaseCount)
		local function zedChaseCount()
		if not getPlayer() then return end
		if getPlayer():getModData()['countZed'] == nil then getPlayer():getModData()['countZed'] = false end
		if getPlayer():getModData()['countZed'] then
			local zeds = getPlayer():getStats():getNumChasingZombies()
			local xOrigin = getCore():getScreenWidth() / 2
			local yOrigin = getCore():getScreenHeight() / 2 - 20
			getTextManager():DrawStringCentre(UIFont.Medium, xOrigin, yOrigin,  zeds, 1, 1, 1, 1)
		end
	end
Events.OnPostUIDraw.Add(zedChaseCount)