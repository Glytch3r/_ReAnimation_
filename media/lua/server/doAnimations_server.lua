--written by Pao


if isClient() then return; end

local Commands = {}
Commands.GlytchAnimations = {}





Commands.GlytchAnimations.NotifyAnimation = function(_, args)
    sendServerCommand("GlytchAnimations", "AcceptNewAnimation", {args.sender, args.action})
end

function Anim_OnInitGlobalModData()
    ModData.getOrCreate("Anim_PLAYER_DATA")
end

Events.OnInitGlobalModData.Add(Anim_OnInitGlobalModData)


Events.OnClientCommand.Add(function(module, command, player, args)
	if Commands[module] and Commands[module][command] then
	    Commands[module][command](player, args)
	end
end)