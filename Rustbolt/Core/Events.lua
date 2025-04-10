local addonName = ...;

Rustbolt.Events = {
	ADDON_LOADED = "AddonLoaded",
	ADDON_UNLOADING = "AddonUnloading",
    SCREEN_CHANGED = "ScreenChanged",
    UI_THEME_CHANGED = "UIThemeChanged",
    ASSET_PICKER_ASSET_CHANGED = "AssetPickerAssetChanged",
    TILE_ATTRIBUTE_CHANGED = "GameTileAttributeChanged",
    DEV_STATE_CHANGED = "DevStateChanged",
	CVAR_MANAGER_LOADED = "CVarManagerLoaded",
	CVAR_CREATED = "CVarCreated",
	CVAR_DELETED = "CVarDeleted",
	CVAR_VALUE_CHANGED = "CVarValueChanged",
	CVARS_LOADED = "CVarsLoaded",
	NOTIFICATION_ADDED = "NotificationAdded",
	NOTIFICATION_REMOVED = "NotificationRemoved",
	DISMISS_NOTIFICATION = "DismissNotification",
	CLEAR_NOTIFICATIONS = "ClearNotifications",
	TOGGLE_FRAME_BORDERS = "ToggleFrameBorders",
	DIALOG_SHOWN = "DialogShown",
	DIALOG_HIDDEN = "DialogHidden",
	EDITOR_GAME_CREATED = "EditorGameCreated",
	EDITOR_GAME_PRELOAD = "EditorGamePreload",
	EDITOR_GAME_LOADED = "EditorGameLoaded",
	EDITOR_GAME_DELETED = "EditorGameDeleted",
	EDITOR_TILE_CLICK = "EditorTileClick"
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

EventUtil.ContinueOnAddOnLoaded(addonName, function()
	Rustbolt.EventRegistry:TriggerEvent(Rustbolt.Events.ADDON_LOADED);
end);

EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_LOGOUT", function()
	Rustbolt.EventRegistry:TriggerEvent(Rustbolt.Events.ADDON_UNLOADING);
end);

Rustbolt.GameRegistry = CreateFromMixins(CallbackRegistryMixin);
Rustbolt.GameRegistry:OnLoad();
Rustbolt.GameRegistry:GenerateCallbackEvents(GenerateCallbackEvents(Rustbolt.GameEvents));

local RegistryNames = {
    [Rustbolt.EventRegistry] = "Engine",
    [Rustbolt.GameRegistry] = "Game"
};

local function OnCallbackEventFired(registry, event, ...)
	if not EventTrace or not EventTrace.LogLine then
		return;
	end

	if not Rustbolt.CVarManager or not Rustbolt.CVarManager:GetCVar("bPushEngineEventsToEventTrace") then
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

hooksecurefunc(Rustbolt.EventRegistry, "TriggerEvent", OnCallbackEventFired);
hooksecurefunc(Rustbolt.GameRegistry, "TriggerEvent", OnCallbackEventFired);