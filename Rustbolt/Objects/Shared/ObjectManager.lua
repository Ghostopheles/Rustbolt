
---@enum RustboltObjectType
Rustbolt.ObjectType = {
    GAME = 1,
    WORLD = 2,
    OBJECT = 3,
};

---@class RustboltObjectManager
local ObjectManager = {};

---@type table<RustboltObjectType, function>
ObjectManager.ObjectSerializers = {};

---@type table<RustboltGUID, RustboltObject>
ObjectManager.ObjectRegistry = {};

---@type table<RustboltObjectType, table | function>
ObjectManager.Constructors = {};

---@type table<string, RustboltObjectType>
ObjectManager.ObjectTypes = {};

---@type table<string, table>
ObjectManager.ObjectTypeMetatables = {};

---@param name string Object name
---@param objectType RustboltObjectType Object type
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

    local objType = self.ObjectTypes[objectName];
    if self.ObjectTypeMetatables[objType] then
        setmetatable(obj, self.ObjectTypeMetatables[objType]);
    end

    -- generate a guid for the object
    local guid = self:GenerateGUID();
    assert(not self.ObjectRegistry[guid], "Duplicate object GUID found.");
    obj:SetGUID(guid);
    self.ObjectRegistry[guid] = obj;

    return obj;
end

---@param objectType RustboltObjectType
---@param metatable table
function ObjectManager:SetObjectTypeMetatable(objectType, metatable)
    if not self.ObjectTypeMetatables[objectType] then
        self.ObjectTypeMetatables[objectType] = metatable;
    end
end

---@param objectType RustboltObjectType
---@param serializer function
function ObjectManager:SetObjectTypeSerializer(objectType, serializer)
    if not self.ObjectSerializers[objectType] then
        self.ObjectSerializers[objectType] = serializer;
    end
end

---@return function? serializer
function ObjectManager:GetSerializerForObject(objectType)
    return self.ObjectSerializers[objectType];
end

---@param objectName string Object name
---@return RustboltObject? baseObject
function ObjectManager:GetObjectBase(objectName)
    local base = self.Constructors[objectName];
    if type(base) == "table" then
        return base;
    end
end

---@return RustboltGUID
function ObjectManager:GenerateGUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
    local guid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end);

    return guid;
end

------------

Rustbolt.ObjectManager = ObjectManager;