local Constants = Rustbolt.Constants;

local InputManager = Rustbolt.InputManager;

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local GameEvents = Rustbolt.GameEvents;
local GameRegistry = Rustbolt.GameRegistry;

local SaveManager = Rustbolt.SaveManager;

local L = Rustbolt.Strings;

local AutoPopMT = {
    __index = function(t, k)
        rawset(t, k, {});
        return rawget(t, k);
    end
};

local function GetAutoPopTable()
    local tbl = {};
    setmetatable(tbl, AutoPopMT);
    return tbl;
end

------
-- register engine CVars

do
    local name = "bIgnoreDuplicateEvents";
    local default = false;
    local type = type(default);
    local category = Rustbolt.CVarCategory.ENGINE;
    local ephemeral = false;

    Rustbolt.CVarManager:RegisterCVar(name, type, category, default, ephemeral);
end

------

---@alias RustboltGameID string
---@alias RustboltEventName string

---@class RustboltEngine
---@field ActiveGame? RustboltGame
---@field Events table<RustboltEventName, boolean>
---@field EventListeners table<RustboltEventName, RustboltObject>
---@field EventListenerLookup table<RustboltEventName, table<RustboltObject, boolean>>
local Engine = {
    Events = GetAutoPopTable(),
    EventListeners = GetAutoPopTable(),
    EventListenerLookup = GetAutoPopTable()
};

--[[
the engine is going to be the CIA of our project, overseeing the interaction of all the different systems
    additionally, it'll connect our (non-game) UI to the game in a (hopefully) sane manner
]]

---Sets the currently active game
---@param gameID RustboltGameID
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

function Engine:GetGameWindow()
    return RustboltGameWindow;
end

function Engine:GetGameCanvas()
    return self:GetGameWindow().GameCanvas;
end

function Engine:LoadMap(mapID)
    self:GetGameCanvas():LoadMap(mapID);
end

function Engine:CreateTexture(...)
    return self:GetGameCanvas():AddTexture(...);
end

function Engine:PositionObjectByWorldCoords(object, x, y, z)
    local canvas = self:GetGameCanvas();
    local scale = 10;
    local xOffset, yOffset = x * scale, y * scale;

    object:SetPoint("CENTER", canvas, "CENTER", xOffset, yOffset);
end

------------

--[[
the engine is going to handle all the event propagations for our components and objects
]]

---Dispatches an event to all objects registered for it
---@param event RustboltEventName
---@param ... any
function Engine:DispatchEvent(event, ...)
    assert(self:IsValidEvent(event), "Attempt to dispatch an undeclared event");

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
---@param event RustboltEventName
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
---@param event RustboltEventName
function Engine:RegisterForEvent(object, event)
    local listeners = self.EventListeners[event];
    local lookup = self.EventListenerLookup[event];

    if not lookup[object] then
        tinsert(listeners, object);
    end
end

---Declares an event, allowing it to be registered by objects
---@param eventName RustboltEventName
---@return boolean success
function Engine:DeclareEvent(eventName)
    if self.Events[eventName] then
        CallErrorHandler("Attempt to declare duplicate event");
        return false;
    end

    self.Events[eventName] = true;
    return true;
end

---@param eventName RustboltEventName
---@return boolean isValid
function Engine:IsValidEvent(eventName)
    return self.Events[eventName] or false;
end

------------

Rustbolt.Engine = Engine;