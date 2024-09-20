local Input = Rustbolt.InputManager;
local Enum = Rustbolt.Enum;
local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local L = Rustbolt.Strings;

local SCREEN_NAMES = Enum.GameWindowScreen;

RustboltWindowMixin = {};

function RustboltWindowMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.WINDOW_TITLE);

    RunNextFrame(function() tinsert(UISpecialFrames, self:GetName()); end);

    self.Screens = {};
    self.CurrentScreen = {
        Frame = nil,
        Name = nil,
    };

    self:RegisterScreen(self.Empty, SCREEN_NAMES.EMPTY);
    self:RegisterScreen(self.EditorHome, SCREEN_NAMES.EDITOR_HOME);
    self:RegisterScreen(self.GameCanvas, SCREEN_NAMES.GAME);
    self:RegisterScreen(self.StartScreen, SCREEN_NAMES.START);
    self:SetScreen(SCREEN_NAMES.EDITOR_HOME);

    self.DefaultScreen = SCREEN_NAMES.EDITOR_HOME;
end

function RustboltWindowMixin:OnKeyDown(key)
    if Input:ShouldPropagateKey(key) then
        self:SetPropagateKeyboardInput(true);
    else
        self:SetPropagateKeyboardInput(false);
        Input:OnKeyDown(key);
    end
end

function RustboltWindowMixin:OnKeyUp(key)
    Input:OnKeyUp(key);
end

function RustboltWindowMixin:Toggle()
    self:SetShown(not self:IsShown());
end

function RustboltWindowMixin:RegisterScreen(screen, screenName)
    self.Screens[screenName] = screen;
end

function RustboltWindowMixin:SetScreen(screenName)
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

function RustboltWindowMixin:GetScreen()
    return self.CurrentScreen;
end

function RustboltWindowMixin:GetScreenByName(name)
    return self.Screens[name];
end