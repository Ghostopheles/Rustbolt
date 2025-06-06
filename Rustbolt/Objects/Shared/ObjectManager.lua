
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

---@type table<RustboltObjectType, function>
ObjectManager.ObjectDeserializers = {};

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

---@generic T
---@param objectName string Object type name
---@param ... any Arguments passed to object constructor
---@return T object
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

    -- generate and set a guid for the object, if supported
    if type(obj.SetGUID) == "function" then
        local guid = self:GenerateGUID();
        assert(not self.ObjectRegistry[guid], "Duplicate object GUID found.");
        obj:SetGUID(guid);
        self.ObjectRegistry[guid] = obj;
    end

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

---@param objectType RustboltObjectType
---@param deserializer function
function ObjectManager:SetObjectTypeDeserializer(objectType, deserializer)
    if not self.ObjectDeserializers[objectType] then
        self.ObjectDeserializers[objectType] = deserializer;
    end
end

---@return function? deserializer
function ObjectManager:GetDeserializerForObject(objectType)
    return self.ObjectDeserializers[objectType];
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

---@param guid RustboltGUID
---@return RustboltObject?
function ObjectManager:GetObjectByGUID(guid)
    return self.ObjectRegistry[guid];
end

------------

Rustbolt.ObjectManager = ObjectManager;