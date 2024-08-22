---@class RustboltFrameUtil
local FrameUtil = {};

function FrameUtil.AddFrameDebugBorder(frame)
    local left = frame:CreateLine(nil, "OVERLAY");
    local right = frame:CreateLine(nil, "OVERLAY");
    local top = frame:CreateLine(nil, "OVERLAY");
    local bottom = frame:CreateLine(nil, "OVERLAY");

    left:SetStartPoint("BOTTOMLEFT");
    left:SetEndPoint("TOPLEFT");

    right:SetStartPoint("BOTTOMRIGHT");
    right:SetEndPoint("TOPRIGHT");

    top:SetStartPoint("TOPLEFT");
    top:SetEndPoint("TOPRIGHT");

    bottom:SetStartPoint("BOTTOMLEFT");
    bottom:SetStartPoint("BOTTOMRIGHT");

    local r, g, b = TRANSMOGRIFY_FONT_COLOR:GetRGB();
    left:SetColorTexture(r, g, b);
    right:SetColorTexture(r, g, b);
    top:SetColorTexture(r, g, b);
    bottom:SetColorTexture(r, g, b);
end

------------

Rustbolt.FrameUtil = FrameUtil;