
local function OnZombieUpdate(zombie)

    local player = getPlayer()
    local mod_data = player:getModData().RA

    if mod_data ~= nil then
        if mod_data.is_zed then
            local zombie_target = zombie:getTarget()
            if zombie:getTarget() == player then
                zombie:setTarget(nil)
            else
                local zombies = getCell():getObjectList()
                for i=zombies:size(),1,-1 do
                    local f_player = zombies:get(i-1)
                    if instanceof(zombie, "IsoPlayer") then
                        if f_player ~= player then
                            print("Found backup player")
                            zombie:setTarget(f_player)
                            break
                        end
                    end
                end
            end


            end
    end



end





Events.OnZombieUpdate.Add(OnZombieUpdate)