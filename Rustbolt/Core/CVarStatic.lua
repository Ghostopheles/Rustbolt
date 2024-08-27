-- our default engine CVars, all are assumed to be non-ephemeral
local EngineCVars = {
    {
        Name = "bIgnoreDuplicateEvents",
        DefaultValue = false,
        Category = Rustbolt.CVarCategory.ENGINE
    },
    {
        Name = "bPushEngineEventsToEventTrace",
        DefaultValue = true,
        Category = Rustbolt.CVarCategory.DEBUG
    },
    {
        Name = "bShowFrameBorders",
        DefaultValue = false,
        Category = Rustbolt.CVarCategory.DEBUG
    },
};

local function ValidateCVars()
    local Manager = Rustbolt.CVarManager;
end