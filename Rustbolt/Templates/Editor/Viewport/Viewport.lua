local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

------------

RustboltEditorViewportMixin = {};

function RustboltEditorViewportMixin:OnLoad()
    Registry:RegisterCallback(Events.EDITOR_TILE_CLICK, self.OnTileClick, self);
end

---@param game RustboltGame
function RustboltEditorViewportMixin:LoadGameView(game)
end

function RustboltEditorViewportMixin:OnTileClick(button)
    if button == "RightButton" then
        print('owo')
    end
end