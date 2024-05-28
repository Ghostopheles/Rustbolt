local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local InputManager = Verity.InputManager;

VerityDevToolsMixin = {};

function VerityDevToolsMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Dev Tools");

    self.ScreenName:SetText("GAME");
    self.SwitchScreen:SetScript("OnClick", function() VerityGameWindow:SetScreen(self.ScreenName:GetText()); end);
    self.SwitchScreen:SetText("Set Screen");

    self.Assets:SetText("Assets");
    self.Assets:SetScript("OnClick", function() VerityAssetPicker:Toggle(); end);

    self.DevMode = false;

    local context = InputManager:CreateInputContext(false, false, true);
    InputManager:RegisterInputListener("Z", self.ToggleDevMode, self, context);
end

function VerityDevToolsMixin:IsDevModeActive()
    return self.DevMode;
end

function VerityDevToolsMixin:ToggleDevMode()
    local devModeActive = not self.DevMode;
    self.DevMode = devModeActive;

    Registry:TriggerEvent(Events.DEV_STATE_CHANGED, self.DevMode);
end