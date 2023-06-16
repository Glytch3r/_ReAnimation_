-------------------------------
-------- REANIMATION ----------
-------------------------------

RA_Core = RA_Core or {}

-- Dedicated to updating the status of the Zed Player during the gameplay and sync everything



local bodyParts = {
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

    for i=1, #bodyParts do
        --print(body_part_types[i])
        local body_part = body_damage:getBodyPart(bodyParts[i])
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

    -- To be sure that zombies won't attack the player
    player:setInvisible(true)       -- To be sure that it doesn't "come off"


end

local function UpdateAnimationState(player)
    RA_StartNewAnimation(player, "isScrambler")     -- TODO Make this dynamic
end

local function ManageHealthZedPlayer(character)
    --print("Should stay forever stuck")
    -- TODO Manage hunger
end




-----------------------------------------

RA_Core.StartZedPlayerUpdate = function()

    -- Basic Zed Handling
    Events.OnTick.Add(ManageZedPlayer)


    -- Animations
    Events.OnPlayerUpdate.Add(UpdateAnimationState)


    -- Health management
    Hook.CalculateStats.Add(ManageHealthZedPlayer)


end

function RA_StartPlayerZedUpdate()


end
