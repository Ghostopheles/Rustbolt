local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

------------

RustboltEditorViewportMixin = {};

function RustboltEditorViewportMixin:OnLoad()
    Registry:RegisterCallback(Events.EDITOR_TILE_CLICK, self.OnTileClick, self);
    Registry:RegisterCallback(Events.EDITOR_GAME_PRELOAD, self.OnGamePreload, self);
end

---@param game RustboltGame
function RustboltEditorViewportMixin:OnGamePreload(game)
    local startupWorldID = game:GetStartupWorldID();
    if startupWorldID then
        local world = game:GetWorldByID(startupWorldID);
        if world then
            self:LoadWorld(world);
        end
    end
end

function RustboltEditorViewportMixin:OnTileClick(button)
    if button == "RightButton" then
        print('owo')
    end
end

---@param world RustboltWorld
function RustboltEditorViewportMixin:LoadWorld(world)
    local canvas = self.Canvas;
    canvas:SetWorld(world);
end