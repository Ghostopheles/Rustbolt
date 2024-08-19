local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;

local Engine = Rustbolt.Engine;
local L = Rustbolt.Strings;

------------

RustboltEditorHomeMixin = {};

function RustboltEditorHomeMixin:OnLoad()
    Registry:RegisterCallback(Events.ADDON_LOADED, self.RegisterToolbarButtons, self);

    self.HorizontalResizeBar:SetTarget(self.ReflectionPanel, nil, Rustbolt.Enum.ResizeDirection.HORIZONTAL);
    self.VerticalResizeBar:SetTarget(self.Viewport, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end

function RustboltEditorHomeMixin:RegisterToolbarButtons()
    local names = {
        L.TOOLBAR_TITLE_FILE,
        L.TOOLBAR_TITLE_EDIT,
        L.TOOLBAR_TITLE_WINDOW,
        L.TOOLBAR_TITLE_TOOLS,
        L.TOOLBAR_TITLE_BUILD,
        L.TOOLBAR_TITLE_HELP,
    };
    for _, name in ipairs(names) do
        local buttonConfig = {
            Text = name,
            ID = "Toolbar_" .. name,
            ButtonType = Rustbolt.Enum.ToolbarButtonType.DROPDOWN
        };
        Engine:AddAtticButton(buttonConfig);
    end
end