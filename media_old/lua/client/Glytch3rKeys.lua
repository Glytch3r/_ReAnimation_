local function glytch3rKeys(key)


	if key == getCore():getKey("Equip/Turn On/Off Light Source") then
		local zPos = getPlayer():getZ() 
		local xx, yy = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), zPos)
		local sq = getCell():getGridSquare(math.floor(xx), math.floor(yy), zPos)
		if sq and sq:getFloor() then
		sq:getFloor():setHighlighted(true)
			for i = 0, square:getObjects():size() - 1 do
				local obj = square:getObjects():get(i)
				local spr = obj:getSprite()
				print(spr:getName())
				getPlayer():Say(tostring(spr:getName())) 
			end
		
		end
		return
	end

	if key == getCore():getKey("Display FPS")  then
		local pl = getPlayer(); pl:getCell():addLamppost(IsoLightSource.new(pl:getX(), pl:getY(), pl:getZ(), 255, 255, 255, 255))
		BrushToolChooseTileUI.openPanel(900, 20, getPlayer()) 
	end

end

Events.OnKeyPressed.Add(glytch3rKeys)