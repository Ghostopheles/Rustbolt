local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

-- our default engine CVars, all are assumed to be non-ephemeral
local EngineCVars = {
    {
        Name = "bIgnoreDuplicateEvents",
        DefaultValue = false,
        Category = Rustbolt.Enum.CVarCategory.ENGINE
    },
    {
        Name = "bPushEngineEventsToEventTrace",
        DefaultValue = true,
        Category = Rustbolt.Enum.CVarCategory.DEBUG
    },
    {
        Name = "bShowFrameBorders",
        DefaultValue = false,
        Category = Rustbolt.Enum.CVarCategory.DEBUG
    },
    { -- blueprint cvars
        Name = "bBlueprintGraphRequireShiftForCenter",
        DefaultValue = true,
        Category = Rustbolt.Enum.CVarCategory.EDITOR
    },
    {
        Name = "fBlueprintGraphMaxScale",
        DefaultValue = 3.0,
        Category = Rustbolt.Enum.CVarCategory.EDITOR
    },
    {
        Name = "fBlueprintGraphMinScale",
        DefaultValue = 0.1,
        Category = Rustbolt.Enum.CVarCategory.EDITOR
    },
    {
        Name = "fBlueprintGraphScaleStep",
        DefaultValue = 0.1,
        Category = Rustbolt.Enum.CVarCategory.EDITOR
    }
};

local function ValidateCVars()
    local Manager = Rustbolt.CVarManager;

    for _, cvar in ipairs(EngineCVars) do
        if not Manager:CVarExists(cvar.Name) then
            Manager:RegisterCVar(cvar.Name, type(cvar.DefaultValue), cvar.Category, cvar.DefaultValue);
        end
    end
end

Registry:RegisterCallback(Events.CVAR_MANAGER_LOADED, ValidateCVars);