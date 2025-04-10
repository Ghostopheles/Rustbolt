local Engine = Rustbolt.Engine;
local ObjectManager = Rustbolt.ObjectManager;

------------

---@class RustboltWorldTile

---@class RustboltWorldSettings

---@class RustboltWorld
---@field protected ID string Unique world identifier
---@field protected Name string Human-readable world name
---@field protected Objects RustboltObject[]
---@field protected NameToObject table<string, RustboltObject>
---@field protected Settings RustboltWorldSettings
---@field protected Tiles RustboltWorldTile[]
local World = {};

function World:Init(name, id)
    self.Objects = {};
    self.NameToObject = {};

    self:SetName(name);
    self:SetID(id);
end

function World:ApplyWorldSettings(worldSettings)
    self.Settings = worldSettings;
end

---@param name string
function World:SetName(name)
    self.Name = name;
end

---@return string
function World:GetName()
    return self.Name;
end

---@param id string
function World:SetID(id)
    self.ID = id;
end

---@return string
function World:GetID()
    return self.ID;
end

---@param tiles RustboltWorldTile[]
function World:SetWorldTiles(tiles)
    self.Tiles = tiles;
end

---@return RustboltWorldTile[]? tiles
function World:GetWorldTiles()
    return self.Tiles;
end

---Creates and initializes an object in the world
---@param name string
---@param objectTypeName string
---@param ... any Arguments passed to object constructor
---@return RustboltObject? object
function World:CreateObject(name, objectTypeName, ...)
    local object = ObjectManager:CreateObject(objectTypeName, ...);
    object:SetWorld(self);
    Engine:DispatchEventForObject(object, "Create");

    tinsert(self.Objects, object);
    self.NameToObject[name] = object;
    return object;
end

---@param name string
---@return RustboltObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end

---@param guid RustboltGUID
---@return RustboltObject? object
function World:GetObjectByGUID(guid)
    return ObjectManager:GetObjectByGUID(guid);
end

------------

---@param name string
---@param id string
local function CreateWorld(name, id)
    local world = CreateAndInitFromMixin(World, name, id);
    return world;
end

ObjectManager:RegisterObjectType("World", Rustbolt.ObjectType.WORLD, CreateWorld);