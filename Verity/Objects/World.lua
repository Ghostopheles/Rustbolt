local ObjectManager = Verity.ObjectManager;

---@class VerityWorld
local World = {};

---@type table<string, VerityObject>
World.Objects = {};

---Creates and initializes an object in the world
---@param name string
---@param objectTypeName string
---@param ... any Arguments passed to object constructor
---@return VerityObject? object
function World:CreateObject(name, objectTypeName, ...)
    local object = ObjectManager:CreateObject(objectTypeName, ...);
    object:SetWorld(self);

    self.Objects[name] = object;
    return object;
end

---@param name string
---@return VerityObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end