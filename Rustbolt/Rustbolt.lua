local mt = {
    __index = function(self, key)
        if key == "Strings" then
            local AceLocale = LibStub("AceLocale-3.0");
            local L = AceLocale:GetLocale("Rustbolt", false);
            rawset(self, key, L);
        end

        return rawget(self, key);
    end
};

Rustbolt = {};
setmetatable(Rustbolt, mt);

Rustbolt.Maps = {};

Rustbolt.Globals = {
    Version = "dev",
};

function Rustbolt_OnAddonCompartmentClick()
    Rustbolt.Engine:ToggleWindow();
end

--TODO: Remove
EventUtil.ContinueOnAddOnLoaded("Rustbolt", function()
    if DevTool then
        DevTool:AddData(Rustbolt, "Rustbolt");
        DevTool:AddData(RustboltWindow, "RustboltWindow");
    end
end);