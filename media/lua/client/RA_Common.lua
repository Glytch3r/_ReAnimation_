

-- Get correct Reanimation Mod Data or creates it on the fly
function RA_GetRAData()
    local mod_data = getPlayer():getModData()

    if mod_data.RA == nil then
        mod_data.RA = {
            is_zed = false,
        }
    end

    return mod_data.RA
end

function RA_StartNewAnimation(player, anim_var)

    player:setVariable(anim_var, "true")


    -- Notifies to server
    sendClientCommand(player, "RA", "NotifyAnimation", { sender = player:getOnlineID(), anim = anim_var })

end