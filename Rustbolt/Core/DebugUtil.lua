--TODO: this is horrible, cleanup sometime

local usageFrame = CreateFrame("Frame", "RustboltAddonUsageFrame", UIParent);
usageFrame:SetPoint("TOP", 0, -15);
usageFrame:SetSize(200, 60);
usageFrame:Hide();

local titleText = usageFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
titleText:SetJustifyH("CENTER");
titleText:SetJustifyV("MIDDLE");
titleText:SetPoint("TOP");

local memUsageText = usageFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
memUsageText:SetJustifyH("CENTER");
memUsageText:SetJustifyV("MIDDLE");
memUsageText:SetPoint("TOP", titleText, "BOTTOM", 0, -5);

local cpuUsageText = usageFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite");
cpuUsageText:SetJustifyH("CENTER");
cpuUsageText:SetJustifyV("MIDDLE");
cpuUsageText:SetPoint("TOP", memUsageText, "BOTTOM", 0, -5);

local title = TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode("Rustbolt Profiling");
titleText:SetText(title);

local UPDATE_INTERVAL = 0.5;

local function UpdateTexts()
    local memFormat = "Memory: %.2f mb";
    local cpuFormat = "CPU: %.2f ms (avg per frame)";

    UpdateAddOnMemoryUsage();
    UpdateAddOnCPUUsage();

    local memUsage = GetAddOnMemoryUsage("Rustbolt") / 1000; -- converting from kb to mb
    local cpuUsage = GetAddOnCPUUsage("Rustbolt");

    local framerate = GetFramerate();
    local avgCPU = cpuUsage / (framerate * UPDATE_INTERVAL);

    memUsageText:SetFormattedText(memFormat, memUsage);
    cpuUsageText:SetFormattedText(cpuFormat, avgCPU);

    ResetCPUUsage();
end

local ticker;
usageFrame:SetScript("OnShow", function()
    ticker = C_Timer.NewTicker(UPDATE_INTERVAL, UpdateTexts);
end);

usageFrame:SetScript("OnHide", function()
    if ticker then
        ticker:Cancel();
    end
end);

------------

---@class RustboltDebugUtil
local DebugUtil = {};

function DebugUtil.ToggleAddonUsageDisplay()
    usageFrame:SetShown(not usageFrame:IsShown());
end

------------

Rustbolt.DebugUtil = DebugUtil;