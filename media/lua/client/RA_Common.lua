
RA_Common = RA_Common or {}


RA_Common.GetModData = function()
    local modData = getPlayer():getModData()
    if modData.RA == nil then
        modData.RA = {isZed = false}
    end

    return modData.RA
end

RA_Common.StartAnimation = function(player, animVar)
    player:setVariable(animVar, "true")
    sendClientCommand(player, "RA", "NotifyAnimation", { sender = player:getOnlineID(), anim = animVar })
end