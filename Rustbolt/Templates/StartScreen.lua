local Animations = Rustbolt.AnimationManager;
local ThemeManager = Rustbolt.ThemeManager;
local E = Rustbolt.Enum;
local L = Rustbolt.Strings;

RustboltStartScreenMixin = {};

function RustboltStartScreenMixin:OnLoad()
    self.Title:SetText(L.START_SCREEN_TITLE);
    self.BouncingText:SetText(L.START_SCREEN_BOUNCING_TEXT);

    local stack = self.ButtonStack;
    stack.PlayButton:SetText(L.START_SCREEN_PLAY);
    stack.PlayButton:Disable();
    stack.EditorButton:SetText(L.START_SCREEN_EDITOR);
    stack.SettingsButton:SetText(L.START_SCREEN_SETTINGS);

    stack.Version:SetText(format(L.VERSION_FORMAT, Rustbolt.Globals.Version));
    stack.Author:SetText(L.AUTHOR);

    ThemeManager:RegisterThemedTexture(self.Background, "START_SCREEN_BG");
    ThemeManager:RegisterThemedTexture(self.ButtonStack.Background, "START_SCREEN_BUTTON_STACK_BG");

    stack.PlayButton:SetScript("OnClick", function() self:OnPlayButtonClick(); end);
    stack.EditorButton:SetScript("OnClick", function() self:OnEditorButtonClick(); end);
end

function RustboltStartScreenMixin:OnShow()
    local bounceHeight = 10;
    local duration = 0.25;
    Animations:ApplyBounce(self.BouncingText, bounceHeight, duration);
end

function RustboltStartScreenMixin:OnHide()
    self.BouncingText:StopBounce();
end

function RustboltStartScreenMixin:OnPlayButtonClick()
end

function RustboltStartScreenMixin:OnEditorButtonClick()
    local window = Rustbolt.Engine:GetWindow();
    window:SetScreen(E.GameWindowScreen.EDITOR_HOME);
end