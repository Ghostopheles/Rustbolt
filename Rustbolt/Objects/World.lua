local MapManager = Rustbolt.MapManager;
local ObjectManager = Rustbolt.ObjectManager;

---@class RustboltWorld
local World = {};

---@type table<string, RustboltObject>
World.Objects = {};

function World:SetMapID(mapID)
    self.MapID = mapID;
    self.Map = MapManager:GetMap(self.MapID);
end

function World:ApplyWorldSettings(worldSettings)
    self.Settings = worldSettings;
end

---Creates and initializes an object in the world
---@param name string
---@param objectTypeName string
---@param ... any Arguments passed to object constructor
---@return RustboltObject? object
function World:CreateObject(name, objectTypeName, ...)
    local object = ObjectManager:CreateObject(objectTypeName, ...);
    object:SetWorld(self);
    Rustbolt.Engine:DispatchEventForObject(object, "Create");

    self.Objects[name] = object;
    return object;
end

---@param name string
---@return RustboltObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end

------------

---@class RustboltWorldStatic
Rustbolt.World = {};

---@return RustboltWorld world
function Rustbolt.World:NewWorld()
    return CreateFromMixins(World);
end