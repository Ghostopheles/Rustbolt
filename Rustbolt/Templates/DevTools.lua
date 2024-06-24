local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local InputManager = Rustbolt.InputManager;

RustboltDevToolsMixin = {};

function RustboltDevToolsMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Dev Tools");

    self.ScreenName:SetText("GAME");
    self.SwitchScreen:SetScript("OnClick", function() RustboltGameWindow:SetScreen(self.ScreenName:GetText()); end);
    self.SwitchScreen:SetText("Set Screen");

    self.Assets:SetText("Assets");
    self.Assets:SetScript("OnClick", function() RustboltAssetPicker:Toggle(); end);

    self.DevMode = false;

    local onUp, hold, doubleTap = false, false, true;
    local context = InputManager:CreateInputContext(onUp, hold, doubleTap);
    InputManager:RegisterInputListener("Z", self.ToggleDevMode, self, context);
end

function RustboltDevToolsMixin:IsDevModeActive()
    return self.DevMode;
end

function RustboltDevToolsMixin:ToggleDevMode()
    local devModeActive = not self.DevMode;
    self.DevMode = devModeActive;

    Registry:TriggerEvent(Events.DEV_STATE_CHANGED, self.DevMode);

    self:SetShown(self.DevMode);
end