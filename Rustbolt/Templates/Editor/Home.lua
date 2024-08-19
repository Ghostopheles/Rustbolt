local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;

local Engine = Rustbolt.Engine;
local L = Rustbolt.Strings;

------------

RustboltEditorHomeMixin = {};

function RustboltEditorHomeMixin:OnLoad()
    Registry:RegisterCallback(Events.ADDON_LOADED, self.RegisterToolbarButtons, self);
end

function RustboltEditorHomeMixin:RegisterToolbarButtons()
    local names = {
        "File",
        "Edit",
        "Window",
        "Tools",
        "Build",
        "Help"
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