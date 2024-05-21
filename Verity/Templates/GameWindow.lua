local Events = Verity.Events;
local Registry = Verity.EventRegistry;
local L = Verity.Strings;

local SCREEN_NAMES = {
    START = "START",
};
Verity.Enum.GameWindowScreenName = SCREEN_NAMES;

VerityGameWindowMixin = {};

function VerityGameWindowMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.GAME_WINDOW_TITLE);

    RunNextFrame(function() tinsert(UISpecialFrames, self:GetName()); end);

    self.Screens = {};
    self.CurrentScreen = {
        Frame = nil,
        Name = nil,
    };

    self:RegisterScreen(self.StartScreen, SCREEN_NAMES.START);
    self:SetScreen(SCREEN_NAMES.START);
end

function VerityGameWindowMixin:Toggle()
    self:SetShown(not self:IsShown());
end

function VerityGameWindowMixin:RegisterScreen(screen, screenName)
    self.Screens[screenName] = screen;
end

function VerityGameWindowMixin:SetScreen(screenName)
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

function VerityGameWindowMixin:GetScreen()
    return self.CurrentScreen;
end