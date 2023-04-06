
if isClient() then return; end

local Commands = {};
Commands.Reanimation = {};

Commands.GlytchAnimations.isUndead = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('GlytchAnimations', 'isUndead', {id = playerId, isUndead =  args.isUndead})    
end


Events.OnClientCommand.Add(function(module, command, player, args)
	if Commands[module] and Commands[module][command] then
	    Commands[module][command](player, args)
	end
end)