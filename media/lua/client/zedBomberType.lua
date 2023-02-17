

function zedBomberIsValid(zedPlayer)
-- TODO add check for inventory if the zedPlayer had a bomb before it died
	if instanceof(zedPlayer, "IsoPlayer") then
		return true
	end
end

function zedBomberExplode(zedPlayer)
-- TODO add random chance be
	local args = { x = zedPlayer:getX()-1, y = zedPlayer:getY()-1, z = zedPlayer:getZ() }
    sendClientCommand('zedPlayer', 'object', 'addExplosionOnSquare'+1, args)
    
	local args = { x = zedPlayer:getX()+1, y = zedPlayer:getY()-1, z = zedPlayer:getZ() }
    sendClientCommand('zedPlayer', 'object', 'addExplosionOnSquare', args)
    
	local args = { x = zedPlayer:getX()+1, y = zedPlayer:getY()+1, z = zedPlayer:getZ() }
    sendClientCommand('zedPlayer', 'object', 'addExplosionOnSquare', args)
    
	local args = { x = zedPlayer:getX()-1, y = zedPlayer:getY()+1, z = zedPlayer:getZ() }
    sendClientCommand('zedPlayer', 'object', 'addExplosionOnSquare', args)
    
    zedPlayer:Kill(zedPlayer)    
end



function zedBomberType(humanPlayer)
	local warningDistance = 6
	local contactDistance = 1
	local zedPlayer = ''
	local onlineUsers = getOnlinePlayers()
	for i = 0, onlineUsers:size() - 1 do
		local humanPlayer = onlineUsers:get(i)
		if humanPlayer ~= zedPlayer  then 
			if humanPlayer:DistTo(zedPlayer) <= warningDistance and not humanPlayer:getSquare():isBlockedTo(zedPlayer:getSquare()) then
				humanPlayer:getStats():setPanic(100)
				getSoundManager():PlayWorldSound('ZombieSurprisedPlayer', humanPlayer:getSquare(), 0, 25, 5, false);  
				zedPlayer:addWorldSoundUnlessInvisible(6, 'ZombieSurprisedPlayer', false);
				humanPlayer:getModData()['JumpScared'] = true
			end		
		--	humanPlayer:getSquare()
			if zedBomberIsValid(zedPlayer) then
				zedPlayer:setBumpType("stagger");
				zedPlayer:setVariable("BumpDone", false);
				zedPlayer:setVariable("BumpFall", true);
				zedPlayer:setVariable("BumpFallType", "pushedBehind");				
				zedBomberExplode(zedPlayer) 
			end
		end
	end 
end
	
Events.OnPlayerUpdate.Add(glytch3rPrank)


--[[     
function nearSprs()
local player = getPlayer()
local cell = player:getCell()
local x, y, z = player:getX(), player:getY(), player:getZ()
local xx, yy, zz
for xx = -2, 2 do
for yy = -2, 2 do
local square = cell:getGridSquare(x + xx, y + yy, z)
local objects = square:getObjects()
	for c = 0, objects:size() - 1 do
		local obj = objects:get(c)
		if obj and obj:getSquare() then

		 local foundIt = true
			if not getSandboxOptions():getOptionByName("ElecShutModifier"):setValue(-1)  or  obj:getSquare():haveElectricity()
			then   print(obj:getSprite():getName()); end
		end
	end
end
end
end ]]