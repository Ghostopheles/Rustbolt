
---@enum RustboltObjectType
Rustbolt.ObjectType = {
    WORLD = 1,
    OBJECT = 2,
};

---@class RustboltObjectManager
local ObjectManager = {};

---@type table<RustboltObjectType, table | function>
ObjectManager.Constructors = {};

---@type table<string, RustboltObjectType>
ObjectManager.ObjectTypes = {};

---@type table<string, table>
ObjectManager.ObjectMetatables = {};

---@param name string Object name
---@param objectType RustboltObjectType Object type
---@param objectOrConstructor table | function Parent table to inherit or constructor function
---@param metatable? table Metatable that will be applied to newly created objects
function ObjectManager:RegisterObjectType(name, objectType, objectOrConstructor, metatable)
    local t = type(objectOrConstructor);
    assert(t == "table" or t == "function", "Invalid object base or constructor");
    assert(not self.Constructors[name] and not self.ObjectTypes[name], "Attempt to register duplicate object type");

    self.Constructors[name] = objectOrConstructor;
    self.ObjectTypes[name] = objectType;
    if metatable and type(metatable) == "table" then
        self.ObjectMetatables[name] = metatable;
    end
end

---@param objectName string Object type name
---@param ... any Arguments passed to object constructor
---@return RustboltObject object
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

    if self.ObjectMetatables[objectName] then
        setmetatable(obj, self.ObjectMetatables[objectName]);
    end

    return obj;
end

---@param objectName string Object name
---@return RustboltObject? baseObject
function ObjectManager:GetObjectBase(objectName)
    local base = self.Constructors[objectName];
    if type(base) == "table" then
        return base;
    end
end

------------

Rustbolt.ObjectManager = ObjectManager;