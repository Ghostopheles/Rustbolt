local ANIM_TYPE_BASE = "Animation";
local ANIM_TYPE_TRANSLATE = "Translation";
local ANIM_TYPE_ALPHA = "Alpha";

local ANIM_TYPE = Rustbolt.Enum.AnimationType;
local ANIM_SLIDE_IN_SIDE = Rustbolt.Enum.SlideInSide;

local ANIM_DEFAULTS = {
    [ANIM_TYPE.Bounce] = {
        BounceHeight = 50,
        Duration = 0.5,
        Smoothing = "OUT",
    },
    [ANIM_TYPE.SlideIn] = {
        FromSide = ANIM_SLIDE_IN_SIDE.BOTTOM,
        Distance = 100,
        Duration = 0.35,
        Smoothing = "OUT_IN",
    },
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
    local animGroup = object.BounceAnimGroup or object:CreateAnimationGroup();
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

---@param object any
---@param fromSide? RustboltSlideInSide
---@param duration? number
---@param distance? number
---@param smoothing? string
---@param doNotStart? boolean
function AnimationManager:ApplySlideIn(object, fromSide, duration, distance, smoothing, doNotStart)
    local defaults = ANIM_DEFAULTS[ANIM_TYPE.SlideIn];

    local animGroup = object.SlideInAnimGroup or object:CreateAnimationGroup();
    animGroup.Translate = animGroup.Translate or animGroup:CreateAnimation(ANIM_TYPE_TRANSLATE);
    animGroup.Alpha = animGroup.Alpha or animGroup:CreateAnimation(ANIM_TYPE_ALPHA);

    local translate = animGroup.Translate;
    translate:SetDuration(duration or defaults.Duration);
    translate:SetSmoothing(smoothing or defaults.Smoothing);
    translate:SetTarget(object);

    fromSide = fromSide or defaults.FromSide;
    distance = distance or defaults.Distance;
    local offsetX, offsetY;
    if fromSide == Rustbolt.SlideInSide.BOTTOM then
        offsetX = 0;
        offsetY = -distance;
    elseif fromSide == Rustbolt.SlideInSide.TOP then
        offsetX = 0;
        offsetY = distance;
    elseif fromSide == Rustbolt.SlideInSide.LEFT then
        offsetX = -distance;
        offsetY = 0;
    elseif fromSide == Rustbolt.SlideInSide.RIGHT then
        offsetX = distance;
        offsetY = 0;
    end

    translate:SetOffset(offsetX, offsetY);

    local alpha = animGroup.Alpha;
    alpha:SetDuration(duration or defaults.Duration);
    alpha:SetSmoothing(smoothing or defaults.Smoothing);
    alpha:SetTarget(object);
    alpha:SetToAlpha(0);
    alpha:SetFromAlpha(1);

    local function SlideIn()
        object:Show();
        animGroup:Play(true);
    end

    local function StopSlideIn()
        animGroup:Stop();
    end

    local function SlideOut()
        animGroup:SetScript("OnFinished", function()
            object:Hide();
            animGroup:SetScript("OnFinished", nil);
        end);
        animGroup:Play(false);
    end

    object.SlideIn = SlideIn;
    object.StopSlideIn = StopSlideIn;
    object.SlideOut = SlideOut;

    if doNotStart then
        return;
    end

    SlideIn();
end

------------

Rustbolt.AnimationManager = AnimationManager;
