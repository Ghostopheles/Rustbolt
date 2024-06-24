Rustbolt.Events = {
    SCREEN_CHANGED = "ScreenChanged",
    UI_THEME_CHANGED = "UIThemeChanged",
    ASSET_PICKER_ASSET_CHANGED = "AssetPickerAssetChanged",
    TILE_ATTRIBUTE_CHANGED = "GameTileAttributeChanged",
    DEV_STATE_CHANGED = "DevStateChanged",
};

Rustbolt.GameEvents = {
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

Rustbolt.EventRegistry = CreateFromMixins(CallbackRegistryMixin);
Rustbolt.EventRegistry:OnLoad();
Rustbolt.EventRegistry:GenerateCallbackEvents(GenerateCallbackEvents(Rustbolt.Events));

Rustbolt.GameRegistry = CreateFromMixins(CallbackRegistryMixin);
Rustbolt.GameRegistry:OnLoad();
Rustbolt.GameRegistry:GenerateCallbackEvents(GenerateCallbackEvents(Rustbolt.GameEvents));

Rustbolt.EventDebug = true;

local RegistryNames = {
    [Rustbolt.EventRegistry] = "Engine",
    [Rustbolt.GameRegistry] = "Game"
};

local EventTracingRegistries = setmetatable({}, { __mode = "kv" });

local function OnCallbackEventFired(registry, event, ...)
	if not EventTrace or not EventTrace.LogLine then
		return;
	end

	local qualifiedEventName = "Rustbolt_" .. event;

	if not EventTrace:CanLogEvent(qualifiedEventName) or not EventTrace:IsLoggingCREvents() then
		return;
	end

    local registryName = RegistryNames[registry];
	local registryText = TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode(string.format("(Rustbolt: %s)", registryName));

	local elementData = {
		event = qualifiedEventName,
		args = SafePack(...),
		displayEvent = string.join(" ", event, TRANSMOGRIFY_FONT_COLOR:WrapTextInColorCode("(Rustbolt)")),
		displayMessage = string.join(" ", event, registryText),
	};

	EventTrace:LogLine(elementData);
end

if Rustbolt.EventDebug then
	if EventTracingRegistries[Rustbolt.EventRegistry] == nil then
		hooksecurefunc(Rustbolt.EventRegistry, "TriggerEvent", OnCallbackEventFired);
	end
	EventTracingRegistries[Rustbolt.EventRegistry] = true;

    if EventTracingRegistries[Rustbolt.GameRegistry] == nil then
		hooksecurefunc(Rustbolt.GameRegistry, "TriggerEvent", OnCallbackEventFired);
	end
	EventTracingRegistries[Rustbolt.GameRegistry] = true;
end