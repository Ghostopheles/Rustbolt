local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local L = Rustbolt.Strings;

---@enum RustboltNotificationType
local NOTIF_TYPE = {
    INFO = 1,
    WARNING = 2,
    ERROR = 3,
};
Rustbolt.Enum.NotificationType = NOTIF_TYPE;

---@class RustboltNotificationManager
local NotificationManager = {};

---@param notifType RustboltNotificationType
---@param title string
---@param text string
function NotificationManager.TriggerNotification(notifType, title, text)
    Registry:TriggerEvent(Events.NOTIFICATION_ADDED, notifType, title, text);
end

function NotificationManager.ClearNotifications()
    Registry:TriggerEvent(Events.CLEAR_NOTIFICATIONS);
end

local function RegisterButton()
    local button = {
        Side = RustboltToolbarMixin.Side.RIGHT,
        ID = "NOTIFICATION_TRAY",
        Text = "$NOTIF$",
        OnClick = function() RustboltNotificationTray:Toggle(); end
    };

    RustboltGameWindow.Basement:AddButton(button);

    RustboltNotificationTray:SetParent(RustboltGameWindow);
    RustboltNotificationTray:SetPoint("BOTTOMRIGHT", -45, 45);
end

Registry:RegisterCallback(Events.ADDON_LOADED, RegisterButton);

------------

Rustbolt.NotificationManager = NotificationManager;

------------

RustboltNotificationTrayMixin = {};

function RustboltNotificationTrayMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);

    self.DataProvider = CreateDataProvider();

    self.ScrollView = CreateScrollBoxListLinearView();
    self.ScrollView:SetDataProvider(self.DataProvider);

    local DEFAULT_EXTENT = 20;
    self.ScrollView:SetPanExtent(DEFAULT_EXTENT);

    local function Initializer(frame, data)
        frame:Init(data);
    end

    self.Template = "RustboltNotificationPopupTemplate";
    self.ScrollView:SetElementInitializer(self.Template, Initializer);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local anchorsWithScrollBar = {
        CreateAnchor("TOPLEFT", 8, -20);
        CreateAnchor("BOTTOMRIGHT", self.ScrollBar, -8, 4),
    };

    local anchorsWithoutScrollBar = {
        anchorsWithScrollBar[1],
        CreateAnchor("BOTTOMRIGHT", -4, 4);
    };

    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, anchorsWithScrollBar, anchorsWithoutScrollBar);

    Registry:RegisterCallback(Events.NOTIFICATION_ADDED, self.AddNotification, self);
    Registry:RegisterCallback(Events.DISMISS_NOTIFICATION, self.DismissNotification, self);
    Registry:RegisterCallback(Events.CLEAR_NOTIFICATIONS, self.ClearNotifications, self);

    self:SetTitle(L.NOTIFICATION_TRAY_TITLE);

    self.CloseButton:SetDisabledAtlas("128-redbutton-exit-disabled");
    self.CloseButton:SetNormalAtlas("128-redbutton-exit");
    self.CloseButton:SetPushedAtlas("128-redbutton-exit-pressed");
    self.CloseButton:SetHighlightAtlas("128-redbutton-exit-highlight");
end

function RustboltNotificationTrayMixin:OnShow()
end

function RustboltNotificationTrayMixin:OnHide()
end

function RustboltNotificationTrayMixin:OnClearButtonClicked()
    Registry:TriggerEvent(Events.CLEAR_NOTIFICATIONS);
end

function RustboltNotificationTrayMixin:Reset()
    self.ScrollView:Flush();

    self.DataProvider = CreateDataProvider();
    self.ScrollView:SetDataProvider(self.DataProvider);
end

function RustboltNotificationTrayMixin:Toggle()
    self:SetShown(not self:IsShown());
end

function RustboltNotificationTrayMixin:AddNotification(notifType, title, text)
    self.DataProvider:Insert({
        Title = title,
        Text = text,
        Type = notifType,
    });
end

function RustboltNotificationTrayMixin:DismissNotification(notifType, title, text)
    self.DataProvider:RemoveByPredicate(function(elementData)
        return elementData.Type == notifType and elementData.Title == title and elementData.Text == text;
    end);
    Registry:TriggerEvent(Events.NOTIFICATION_REMOVED, notifType, title, text);
end

function RustboltNotificationTrayMixin:ClearNotifications()
    self:Reset();
end