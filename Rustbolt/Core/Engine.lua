-- auto populates entries on index if the index doesn't exist
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
    it'll also probably be a common entry point for third-party addons
]]

function Engine:GetWindow()
    return RustboltWindow;
end

function Engine:GetScreenByName(name)
    local window = self:GetWindow();
    return window:GetScreenByName(name);
end

function Engine:GetCurrentScreenName()
    return self:GetWindow():GetScreen().Name;
end

function Engine:ToggleWindow()
    return self:GetWindow():Toggle();
end

function Engine:GetGameCanvas()
    return self:GetWindow().GameCanvas;
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

--[[
    it's gamin' time
]]--

---@param game RustboltGame Game to load
---@param inEditor boolean? Load in editor
function Engine:LoadGame(game, inEditor)
    if inEditor then
        local editor = Rustbolt.Editor;
        editor:LoadGame(game);
    else
        local manager = Rustbolt.GameManager;
        manager:LoadGame(game);
    end
end

------------

Rustbolt.Engine = Engine;