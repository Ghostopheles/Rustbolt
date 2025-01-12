local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;

--[[
the editor is the heart of our most beloved developers
]]

---@class RustboltEditor
---@field private ActiveGame RustboltGame?
local Editor = {};

---@param game RustboltGame
function Editor:LoadGame(game)
    self.ActiveGame = game;
    Registry:TriggerEvent(Events.EDITOR_GAME_LOADED, game);
end

------------

Rustbolt.Editor = Editor;