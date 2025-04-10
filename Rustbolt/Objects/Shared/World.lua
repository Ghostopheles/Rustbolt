local ObjectManager = Rustbolt.ObjectManager;

---@class RustboltWorld
local World = {};

function World:Init(name, id)
    self.Objects = {};
    self.GUIDToObject = {};
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

---@param id RustboltGUID
function World:SetID(id)
    self.ID = id;
end

---@return RustboltGUID
function World:GetID()
    return self.ID;
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

    tinsert(self.Objects, object);
    self.GUIDToObject[object:GetGUID()] = object;
    self.NameToObject[name] = object;
    return object;
end

---@param name string
---@return RustboltObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end

------------

local function CreateWorld(...)
    local world = CreateAndInitFromMixin(World, ...);
end

ObjectManager:RegisterObjectType("World", Rustbolt.ObjectType.WORLD, World);