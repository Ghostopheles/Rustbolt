local Constants = Rustbolt.Constants;

local InputManager = Rustbolt.InputManager;

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local GameEvents = Rustbolt.GameEvents;
local GameRegistry = Rustbolt.GameRegistry;

local SaveManager = Rustbolt.SaveManager;

local L = Rustbolt.Strings;

---@class RustboltEngine
---@field ActiveGame? RustboltGame
local Engine = {
    EventListeners = {},
    EventListenerLookup = {}
};

--[[
the engine is going to be the CIA of our project, overseeing the interaction of all the different systems
    additionally, it'll connect our (non-game) UI to the game in a (hopefully) sane manner
]]

---Sets the currently active game
---@param gameID string
---@return RustboltGame?
function Engine:SetActiveGame(gameID)
    local game; -- TODO: create GameManager
    self:SetActiveGame(game);
    return game;
end

---@return RustboltGame?
function Engine:GetActiveGame()
    return self.ActiveGame;
end

function Engine:GetGameState()
    return Rustbolt.GameState;
end

function Engine:LoadMap(mapID)
    RustboltGameWindow.GameCanvas:LoadMap(mapID);
end

function Engine:CreateTexture(...)
    local canvas = RustboltGameWindow.GameCanvas;
    return canvas:AddTexture(...);
end

function Engine:PositionObjectByWorldCoords(object, x, y, z)
    local canvas = RustboltGameWindow.GameCanvas;
    local scale = 10;
    local xOffset, yOffset = x * scale, y * scale;

    object:SetPoint("CENTER", canvas, "CENTER", xOffset, yOffset);
end

------------

--[[
the engine is going to handle all the event propagations for our components and objects
]]

---Dispatches an event to all objects registered for it
---@param event string
---@param ... any
function Engine:DispatchEvent(event, ...)
    local listeners = self:GetListenersForEvent(event);
    if not listeners or #listeners == 0 then
        return;
    end

    for i=1, #listeners do
        self:DispatchEventForObject(listeners[i], event, ...);
    end
end

---Dispatches an event local to the provided object, with the given arguments
---@param object RustboltObject
---@param event string
---@param ... any
function Engine:DispatchEventForObject(object, event, ...)
    local handlerName = "On" .. event;
    local handler = object[handlerName];
    if not handler or type(handler) ~= "function" then
        return;
    end

    handler(object, ...);
end

---@param event string
---@return table<RustboltObject>?
function Engine:GetListenersForEvent(event)
    return self.EventListeners[event];
end

---@param object RustboltObject
---@param event string
function Engine:RegisterForEvent(object, event)
    if not self.EventListeners[event] then
        self.EventListeners[event] = {};
    end

    local listeners = self.EventListeners[event];
    local lookup = self.EventListenerLookup[event];
    if not lookup[object] then
        tinsert(listeners, object);
    end
end

------------

Rustbolt.Engine = Engine;