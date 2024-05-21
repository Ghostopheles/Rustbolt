Verity.CoreEvents = {};
Verity.GameEvents = {};

local function GenerateCallbackEvents()
    local tbl = {};

    for _, v in pairs(Verity.CoreEvents) do
        tinsert(tbl, v);
    end

    for _, v in pairs(Verity.GameEvents) do
        tinsert(tbl, v);
    end

    return tbl;
end

Verity.EventRegistry = CreateFromMixins(CallbackRegistryMixin);
Verity.EventRegistry:OnLoad();
Verity.EventRegistry:GenerateCallbackEvents(GenerateCallbackEvents());