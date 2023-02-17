-- Manages all the updating parts of the code


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
        HealZedPlayer()


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



    ----------------------
    -- Animations
    local function UpdateAnimationState(upd_player)
        RA_StartNewAnimation(upd_player, "isScrambler")
    end

    Events.OnPlayerUpdate.Add(UpdateAnimationState)

    -----------------------
    -- Health management
    local function ManageHealthZedPlayer(character)
        --print("Should stay forever stuck")
        -- TODO Manage hunger
    end
    Hook.CalculateStats.Add(ManageHealthZedPlayer)



    -----------------------
    -- Zed Attacks management
    --local ZedAttack = function(character, chargeDelta, primary)
    --    print("Zed Attack")
    --    primary = Reanimation.zed_fists
    --
    --    ISTimedActionQueue.add(RAZedAttack:new(character, primary, 1.0))
    --end
    --
    --Hook.Attack.Remove(ISReloadWeaponAction.attackHook)
    --Hook.Attack.Add(ZedAttack)
    --
    --local OnZedAttack = function(x, y)
    --    print("RA: Managing Zed Attack")
    --    local player = getSpecificPlayer(0)
    --    ZedAttack(player, nil, nil)     -- TODO Based on Brutal Handwork, is this correct?
    --end
    --Events.OnMouseDown.Add(OnZedAttack)

end
