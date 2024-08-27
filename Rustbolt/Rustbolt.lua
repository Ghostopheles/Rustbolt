Rustbolt = {};
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
    end
end);