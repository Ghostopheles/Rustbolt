Verity.Events = {
    SCREEN_CHANGED = "ScreenChanged",
    UI_THEME_CHANGED = "UIThemeChanged",
    ASSET_PICKER_ASSET_CHANGED = "AssetPickerAssetChanged",
};

Verity.GameEvents = {};

local function GenerateCallbackEvents(events)
    local tbl = {};

    for _, v in pairs(events) do
        tinsert(tbl, v);
    end

    return tbl;
end

Verity.EventRegistry = CreateFromMixins(CallbackRegistryMixin);
Verity.EventRegistry:OnLoad();
Verity.EventRegistry:GenerateCallbackEvents(GenerateCallbackEvents(Verity.Events));

Verity.GameRegistry = CreateFromMixins(CallbackRegistryMixin);
Verity.GameRegistry:OnLoad();
Verity.GameRegistry:GenerateCallbackEvents(GenerateCallbackEvents(Verity.GameEvents));