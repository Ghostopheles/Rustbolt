
---@enum VerityObjectType
Verity.ObjectType = {
    WORLD = 1,
    OBJECT = 2,
};

---@class VerityObjectManager
local ObjectManager = {};

---@type table<VerityObjectType, table | function>
ObjectManager.Constructors = {};

---@type table<string, VerityObjectType>
ObjectManager.ObjectTypes = {};

---@param name string Object name
---@param objectType VerityObjectType Object type
---@param objectOrConstructor table | function Parent table to inherit or constructor function
function ObjectManager:RegisterObjectType(name, objectType, objectOrConstructor)
    local t = type(objectOrConstructor);
    assert(t == "table" or t == "function", "Invalid object base or constructor");
    assert(not self.Constructors[name] and not self.ObjectTypes[name], "Attempt to register duplicate object type");

    self.Constructors[name] = objectOrConstructor;
    self.ObjectTypes[name] = objectType;
end

---@param objectName string Object type name
---@param ... any Arguments passed to object constructor
---@return VerityObject object
function ObjectManager:CreateObject(objectName, ...)
    local parent = self.Constructors[objectName];
    assert(parent, "Cannot create invalid object type");

    local obj;
    if type(parent) == "function" then
        obj = parent(...);
    elseif type(parent.Init) == "function" then
        obj = CreateAndInitFromMixin(parent, ...);
    else
        obj = CreateFromMixins(parent);
    end
    return obj;
end

---@param objectName string Object name
---@return VerityObject? baseObject
function ObjectManager:GetObjectBase(objectName)
    local base = self.Constructors[objectName];
    if type(base) == "table" then
        return base;
    end
end

------------

Verity.ObjectManager = ObjectManager;