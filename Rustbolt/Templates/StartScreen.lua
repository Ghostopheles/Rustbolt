local Engine = Rustbolt.Engine;
local Animations = Rustbolt.AnimationManager;
local ThemeManager = Rustbolt.ThemeManager;
local L = Rustbolt.Strings;

RustboltStartScreenMixin = {};

function RustboltStartScreenMixin:OnLoad()
    self.Title:SetText(L.START_SCREEN_TITLE);
    self.BouncingText:SetText(L.START_SCREEN_BOUNCING_TEXT);

    local stack = self.ButtonStack;
    stack.StartButton:SetText(L.START_SCREEN_NEW_GAME);
    stack.LoadButton:SetText(L.START_SCREEN_LOAD_GAME);
    stack.SettingsButton:SetText(L.START_SCREEN_SETTINGS);
    stack.HelpButton:SetText(L.START_SCREEN_HELP);
    stack.CreditsButton:SetText(L.START_SCREEN_CREDITS);

    stack.Version:SetText(format(L.GAME_VERSION_FORMAT, Rustbolt.Globals.Version));
    stack.Author:SetText(L.GAME_AUTHOR);

    stack.LoadButton:Disable(); -- TODO: update enable state w/ num of saves or something

    ThemeManager:RegisterThemedTexture(self.Background, "START_SCREEN_BG");
    ThemeManager:RegisterThemedTexture(self.ButtonStack.Background, "START_SCREEN_BUTTON_STACK_BG");

    stack.StartButton:SetScript("OnClick", function() self:OnStartButtonClick(); end);
end

function RustboltStartScreenMixin:OnShow()
    local bounceHeight = 10;
    local duration = 0.25;
    Animations:ApplyBounce(self.BouncingText, bounceHeight, duration);
end

function RustboltStartScreenMixin:OnHide()
    self.BouncingText:StopBounce();
end

function RustboltStartScreenMixin:OnStartButtonClick()
    local window = self:GetParent();
    window:SetScreen(Rustbolt.Enum.ScreenName.GAME);
    window:SetTitle(format(L.CAMPAIGN_WINDOW_TITLE, "TEST MODE"));

    local gameState = Engine:GetGameState();
    gameState:Init(1);
    gameState:LoadGame();
    gameState:Start();
end