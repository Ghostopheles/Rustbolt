local ANIM_TYPE_BASE = "Animation";

---@enum RustboltAnimType
Rustbolt.AnimationType = {
    Bounce = 1,
};
local ANIM_TYPE = Rustbolt.AnimationType;

local ANIM_DEFAULTS = {
    [ANIM_TYPE.Bounce] = {
        BounceHeight = 50,
        Duration = 0.5,
        Smoothing = "OUT",
    };
};

---@class RustboltAnimationManager
local AnimationManager = {};

AnimationManager.Targets = {};

---@param object any
---@param bounceHeight? number
---@param duration? number
---@param smoothing? string
---@param doNotStart? boolean
function AnimationManager:ApplyBounce(object, bounceHeight, duration, smoothing, doNotStart)
    local defaults = ANIM_DEFAULTS[ANIM_TYPE.Bounce];

    local point, relativeTo, relativePoint, offsetX, offsetY = object:GetPointByName("CENTER");
    local animGroup = object.AnimGroup or object:CreateAnimationGroup();
    animGroup:SetLooping("BOUNCE");
    animGroup.Anim = animGroup.Anim or animGroup:CreateAnimation(ANIM_TYPE_BASE);

    local anim = animGroup.Anim;
    anim:SetDuration(duration or defaults.Duration);
    anim:SetSmoothing(smoothing or defaults.Smoothing);

    local function Tick(_)
        local progress = math.sin(anim:GetSmoothProgress());
        local targetOffset = (bounceHeight or defaults.BounceHeight) * progress;
        object:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY + targetOffset);
    end

    anim:SetScript("OnUpdate", Tick);

    local function StartBounce()
        animGroup:Play();
    end

    local function StopBounce(_, noReset)
        animGroup:Stop();
        if noReset then
            return;
        end
        object:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
    end

    object.StartBounce = StartBounce;
    object.StopBounce = StopBounce;

    if doNotStart then
        return;
    end

    StartBounce();
end

------------

Rustbolt.AnimationManager = AnimationManager;
