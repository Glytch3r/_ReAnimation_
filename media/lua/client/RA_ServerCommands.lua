local Commands = {}
Commands.RA = {}

Commands.RA.AcceptNewAnimation = function(args)


    local original_player = getPlayerByOnlineID(args[1])
    local action_id = args[2]

    print(action_id)


    -- TODO make this a function so we can run it from wherever we are in the code
    --local titles = { "Normal", "isAct1", "isAct2", "isAct3", "isAct4", "isAct5", "isUndead" }
    --for i = 0, #titles do
    --    local title = titles[i]
    --    original_player:setVariable(title, 'false')
    --end

    original_player:setVariable(action_id, 'true')
    print("Start new anim!")

end

Events.OnServerCommand.Add(function(module, command, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](args)
    end
end)