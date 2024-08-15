RustboltNotificationPopupMixin = {};

function RustboltNotificationPopupMixin:OnLoad()
    -- setup slide in anim
    local fromSide = Rustbolt.SlideInSide.BOTTOM;
    local duration = 0.25;
    local distance = 175;
    local smoothing = "OUT_IN";
    local doNotStart = true;
    -- this adds the StartSlideIn and StopSlideIn methods
    Rustbolt.AnimationManager:ApplySlideIn(self, fromSide, duration, distance, smoothing, doNotStart);

    self.FocusedAtlas = "plunderstorm-scenariotracker-active-frame";
    self.UnfocusedAtlas = "plunderstorm-scenariotracker-waiting";

    self:SetFocused(false);
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
    self:SlideOut();
end

function RustboltNotificationPopupMixin:SetFocused(isFocused)
    local atlas = isFocused and self.FocusedAtlas or self.UnfocusedAtlas;
    self.Background:SetAtlas(atlas);
end

function RustboltNotificationPopupMixin:ShowPopup(title, message)
    self.TitleText:SetText(title);
    self.InfoText:SetText(message);

    self:SlideIn();
end