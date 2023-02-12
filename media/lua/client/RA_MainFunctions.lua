-- REANIMATION --



-- TODO 1) Tag player as controllable zombie
-- TODO 2) Switch player right before death to zombie
-- TODO 3) Screamer logic
-- TODO 4) ... 




local function RegenPlayerAsZed()
    -- TODO kill the old player and create a new one?

    -- Check on damage, intercept ondragdown (somehow) and stop it



end




local function InitZedRegen(player)
    -- TODO Copy player data and save it somewhere

    -- TODO Check if infected and if we can show the "Respawn as Zombie" button 

end


Events.OnPlayerDeath.Add(InitZedRegen)