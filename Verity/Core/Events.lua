Verity.Events = {
    SCREEN_CHANGED = "ScreenChanged",
    UI_THEME_CHANGED = "UIThemeChanged",
};

local function GenerateCallbackEvents()
    local tbl = {};

    for _, v in pairs(Verity.Events) do
        tinsert(tbl, v);
    end

    return tbl;
end

Verity.EventRegistry = CreateFromMixins(CallbackRegistryMixin);
Verity.EventRegistry:OnLoad();
Verity.EventRegistry:GenerateCallbackEvents(GenerateCallbackEvents());