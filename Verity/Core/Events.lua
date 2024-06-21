Verity.Events = {
    SCREEN_CHANGED = "ScreenChanged",
    UI_THEME_CHANGED = "UIThemeChanged",
    ASSET_PICKER_ASSET_CHANGED = "AssetPickerAssetChanged",
    TILE_ATTRIBUTE_CHANGED = "GameTileAttributeChanged",
    DEV_STATE_CHANGED = "DevStateChanged",
};

Verity.GameEvents = {
    GAME_STATUS_CHANGED = "GameStatusChanged",
    CAMPAIGN_CREATED = "CampaignCreated",
    SAVE_CREATED = "SaveCreated",
    ACTIVE_CAMPAIGN_CHANGED = "ActiveCampaignChanged"
};

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

Verity.EventDebug = false;

local RegistryNames = {
    [Verity.EventRegistry] = "Engine",
    [Verity.GameRegistry] = "Game"
};

local EventTracingRegistries = setmetatable({}, { __mode = "kv" });

local function OnCallbackEventFired(registry, event, ...)
	if not EventTrace or not EventTrace.LogLine then
		return;
	end

	local qualifiedEventName = "Verity_" .. event;

	if not EventTrace:CanLogEvent(qualifiedEventName) or not EventTrace:IsLoggingCREvents() then
		return;
	end

    local registryName = RegistryNames[registry];
	local registryText = TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode(string.format("(Verity: %s)", registryName));

	local elementData = {
		event = qualifiedEventName,
		args = SafePack(...),
		displayEvent = string.join(" ", event, TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode("(Verity)")),
		displayMessage = string.join(" ", event, registryText),
	};

	EventTrace:LogLine(elementData);
end

if Verity.EventDebug then
	if EventTracingRegistries[Verity.EventRegistry] == nil then
		hooksecurefunc(Verity.EventRegistry, "TriggerEvent", OnCallbackEventFired);
	end
	EventTracingRegistries[Verity.EventRegistry] = true;

    if EventTracingRegistries[Verity.GameRegistry] == nil then
		hooksecurefunc(Verity.GameRegistry, "TriggerEvent", OnCallbackEventFired);
	end
	EventTracingRegistries[Verity.GameRegistry] = true;
end