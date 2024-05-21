local Animations = Verity.AnimationManager;
local L = Verity.Strings;

VerityStartScreenMixin = {};

function VerityStartScreenMixin:OnLoad()
    self.Title:SetText(L.START_SCREEN_TITLE);
    self.BouncingText:SetText(L.START_SCREEN_BOUNCING_TEXT);

    self.StartButton:SetText(L.START_SCREEN_START_GAME);
    self.SettingsButton:SetText(L.START_SCREEN_SETTINGS);
end

function VerityStartScreenMixin:OnShow()
    Animations:ApplyBounce(self.BouncingText, 10, 0.25);
end

function VerityStartScreenMixin:OnHide()
end