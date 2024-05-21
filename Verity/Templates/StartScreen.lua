local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

VerityStartScreenMixin = {};

function VerityStartScreenMixin:OnLoad()
    self.Title:SetText(L.START_SCREEN_TITLE);
    self.BouncingText:SetText(L.START_SCREEN_BOUNCING_TEXT);

    local stack = self.ButtonStack;
    stack.StartButton:SetText(L.START_SCREEN_NEW_GAME);
    stack.LoadButton:SetText(L.START_SCREEN_LOAD_GAME);
    stack.SettingsButton:SetText(L.START_SCREEN_SETTINGS);
    stack.HelpButton:SetText(L.START_SCREEN_HELP);
    stack.CreditsButton:SetText(L.START_SCREEN_CREDITS);

    stack.Version:SetText(format(L.GAME_VERSION_FORMAT, Verity.Globals.Version));
    stack.Author:SetText(L.GAME_AUTHOR);

    stack.LoadButton:Disable(); -- TODO: update enable state w/ num of saves or something

    ThemeManager:RegisterThemedTexture(self.Background, "START_SCREEN_BG");
    ThemeManager:RegisterThemedTexture(self.ButtonStack.Background, "START_SCREEN_BUTTON_STACK_BG");
end

function VerityStartScreenMixin:OnShow()
    Animations:ApplyBounce(self.BouncingText, 10, 0.25);
end

function VerityStartScreenMixin:OnHide()
    self.BouncingText:StopBounce();
end