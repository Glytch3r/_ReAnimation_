function RA_StartPlayerZedUpdate()

    local player = getPlayer()
    local body_part_types = {
        BodyPartType.Foot_L,
        BodyPartType.Foot_R,
        BodyPartType.ForeArm_L,
        BodyPartType.ForeArm_R,
        BodyPartType.Groin,
        BodyPartType.Hand_L,
        BodyPartType.Hand_R,
        BodyPartType.Head,
        BodyPartType.LowerLeg_L,
        BodyPartType.LowerLeg_R,
        BodyPartType.Neck,
        BodyPartType.Torso_Lower,
        BodyPartType.Torso_Upper,
        BodyPartType.UpperArm_L,
        BodyPartType.UpperArm_R,
        BodyPartType.UpperLeg_L,
        BodyPartType.UpperLeg_R,


    }

    local function HealZedPlayer()
        local body_damage = player:getBodyDamage()

        for i=1, #body_part_types do
            --print(body_part_types[i])
            local body_part = body_damage:getBodyPart(body_part_types[i])
            if body_part ~= nil then
                body_part:setBleeding(false)
                body_part:setBleedingTime(0)
                body_part:setDeepWounded(false)
                body_part:setDeepWoundTime(0)
                body_part:setScratched(false, false)
                body_part:setScratchTime(0)
                body_part:setCut(false)
                body_part:setCutTime(0)
            end
        end
    end


    local function ManageZedPlayer()

        -- Manages healing
        --HealZedPlayer()
        -- TODO Move this, OnTick is overkill
        RA_StartNewAnimation(player, "isScrambler")

        -- Something else
        player:setInvisible(true)       -- To be sure that it doesn't "come off"


    end
    Events.OnTick.Add(ManageZedPlayer)

    local function DisableInteractAction()

        for i,v in ipairs(MainOptions.keyText) do
            if not v.value and (v.txt:getName() == "Interact") then
                v.keyCode = 0
                getCore():addKeyBinding(v.txt:getName(), nil)
                break
            end
        end
    end
    Events.OnTick.Add(DisableInteractAction)

    local function OnInteractAction(key)
        if key == 18 then
            print("RA: Pressed E, should check for windows")
        end
    end
    Events.OnKeyPressed.Add(OnInteractAction)




    -- Hooks test
    local function ManageHealthZedPlayer(character)
        --print("Should stay forever stuck")
    end


    Hook.CalculateStats.Add(ManageHealthZedPlayer)
end
