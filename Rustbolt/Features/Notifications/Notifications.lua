local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

RustboltNotificationPopupMixin = {};

function RustboltNotificationPopupMixin:OnLoad()
    -- setup slide in anim
    local fromSide = Rustbolt.Enum.SlideInSide.BOTTOM;
    local duration = 0.25;
    local distance = 175;
    local smoothing = "OUT_IN";
    local doNotStart = true;
    -- this adds the StartSlideIn and StopSlideIn methods
    Rustbolt.AnimationManager:ApplySlideIn(self, fromSide, duration, distance, smoothing, doNotStart);

    self.FocusedAtlas = "plunderstorm-scenariotracker-active-frame";
    self.UnfocusedAtlas = "plunderstorm-scenariotracker-waiting";

    self:SetFocused(false);

    self.Standalone = false;
end

function RustboltNotificationPopupMixin:OnShow()
end

function RustboltNotificationPopupMixin:OnHide()
end

function RustboltNotificationPopupMixin:OnEnter()
    self:SetFocused(true);
end

function RustboltNotificationPopupMixin:OnLeave()
    if self:IsMouseOver() then
        return;
    end

    self:SetFocused(false);
end

function RustboltNotificationPopupMixin:OnCloseButtonClicked()
    Registry:TriggerEvent(Events.DISMISS_NOTIFICATION, self.Type, self.Title, self.Text);

    if self.Standalone then
        self:SlideOut();
    end
end

function RustboltNotificationPopupMixin:SetFocused(isFocused)
    local atlas = isFocused and self.FocusedAtlas or self.UnfocusedAtlas;
    self.Background:SetAtlas(atlas);
end

function RustboltNotificationPopupMixin:Init(data)
    local title = data.Title;
    local text = data.Text;
    local notifType = data.Type;

    self.TitleText:SetText(title);
    self.InfoText:SetText(text);

    self.Title = title;
    self.Text = text;
    self.Type = notifType;

    self:SetFocused(false);
end

function RustboltNotificationPopupMixin:ShowPopup(data)
    self:Init(data);
    self.Standalone = true;
    self:SlideIn();
end