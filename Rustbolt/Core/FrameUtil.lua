local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local DEFAULT_LINE_THICKNESS = 1;
local LINE_COLOR_R, LINE_COLOR_G, LINE_COLOR_B = TRANSMOGRIFY_FONT_COLOR:GetRGB();

local BORDERS_SHOWN = false;
local BORDER_LINES = {};

local function SetFrameBordersShown(show)
    BORDERS_SHOWN = show;
    for _, line in ipairs(BORDER_LINES) do
        line:SetShown(BORDERS_SHOWN);
    end
end

------------

--- registering relevant CVars
local function RegisterCVars()
    --- frame borders
    do
        local name = "bShowFrameBorders";
        local category = Rustbolt.CVarCategory.DEBUG;
        local defaultValue = false;
        local type = type(defaultValue);
        local ephemeral = false;
        local cvar = Rustbolt.CVarManager:RegisterCVar(name, type, category, defaultValue, ephemeral);

        if cvar then
            local runNow = true;
            cvar:AddValueChangedCallback(SetFrameBordersShown, runNow);
        end
    end
end

Registry:RegisterCallback(Events.CVARS_LOADED, RegisterCVars);

------------

---@class RustboltFrameUtil
local FrameUtil = {};

local function CreateLine(f)
    local line = f:CreateLine(nil, "OVERLAY");
    line:SetThickness(DEFAULT_LINE_THICKNESS);
    line:SetColorTexture(LINE_COLOR_R, LINE_COLOR_G, LINE_COLOR_B);
    return line;
end

function FrameUtil.AddFrameBorder(frame)
    local left = CreateLine(frame);
    local right = CreateLine(frame);
    local top = CreateLine(frame);
    local bottom = CreateLine(frame);

    left:SetStartPoint("BOTTOMLEFT");
    left:SetEndPoint("TOPLEFT");

    right:SetStartPoint("BOTTOMRIGHT");
    right:SetEndPoint("TOPRIGHT");

    top:SetStartPoint("TOPLEFT");
    top:SetEndPoint("TOPRIGHT");

    bottom:SetStartPoint("BOTTOMLEFT");
    bottom:SetEndPoint("BOTTOMRIGHT");

    tinsert(BORDER_LINES, left);
    tinsert(BORDER_LINES, right);
    tinsert(BORDER_LINES, top);
    tinsert(BORDER_LINES, bottom);
end

function FrameUtil.ToggleFrameBorders()
    SetFrameBordersShown(not BORDERS_SHOWN);
end

function FrameUtil.SetFrameBordersShown(show)
    SetFrameBordersShown(show);
end

------------

Rustbolt.FrameUtil = FrameUtil;