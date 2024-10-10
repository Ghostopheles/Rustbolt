local LAYOUTS = {};

local function HasSavedLayout(layoutName)
    return LAYOUTS[layoutName] ~= nil;
end

local function GetSavedLayout(layoutName)
    return LAYOUTS[layoutName];
end

local function ApplyLayout(frame, layout)
    local layoutInfo = GetSavedLayout(layout.Name) or layout;
end

------

---@class RustboltLayoutUtil
local LayoutUtil = {};

function LayoutUtil.RegisterFrameForLayout(frame, layout)
end