local Input = Rustbolt.InputManager;
local Enum = Rustbolt.Enum;
local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local L = Rustbolt.Strings;

local SCREEN_NAMES = {
    EMPTY = "EMPTY",
    START = "START",
    GAME = "GAME",
};
Enum.ScreenName = SCREEN_NAMES;

RustboltGameWindowMixin = {};

function RustboltGameWindowMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.GAME_WINDOW_TITLE);

    RunNextFrame(function() tinsert(UISpecialFrames, self:GetName()); end);

    self.Screens = {};
    self.CurrentScreen = {
        Frame = nil,
        Name = nil,
    };

    self:RegisterScreen(self.Empty, SCREEN_NAMES.EMPTY);
    self:RegisterScreen(self.GameCanvas, SCREEN_NAMES.GAME);
    self:RegisterScreen(self.StartScreen, SCREEN_NAMES.START);
    self:SetScreen(SCREEN_NAMES.EMPTY);

    self.DefaultScreen = SCREEN_NAMES.EMPTY;
end

function RustboltGameWindowMixin:OnKeyDown(key)
    if Input:ShouldPropagateKey(key) then
        self:SetPropagateKeyboardInput(true);
    else
        self:SetPropagateKeyboardInput(false);
        Input:OnKeyDown(key);
    end
end

function RustboltGameWindowMixin:OnKeyUp(key)
    Input:OnKeyUp(key);
end

function RustboltGameWindowMixin:Toggle()
    self:SetShown(not self:IsShown());
end

function RustboltGameWindowMixin:RegisterScreen(screen, screenName)
    self.Screens[screenName] = screen;
end

function RustboltGameWindowMixin:SetScreen(screenName)
    local newScreen = self.Screens[screenName];
    if not newScreen then
        return;
    end

    if self.CurrentScreen.Name then
        if self.CurrentScreen.Name == screenName then
            return;
        end

        ---@diagnostic disable-next-line: undefined-field
        self.CurrentScreen.Frame:Hide();
    end

    self.CurrentScreen.Name = screenName;
    self.CurrentScreen.Frame = newScreen;

    self.CurrentScreen.Frame:Show();
    Registry:TriggerEvent(Events.SCREEN_CHANGED, screenName);
end

function RustboltGameWindowMixin:GetScreen()
    return self.CurrentScreen;
end