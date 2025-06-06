local Engine = Rustbolt.Engine;
local ObjectManager = Rustbolt.ObjectManager;

---@class RustboltObject
local Object = {
    Children = {},
    DoTick = true,
    Position = CreateVector3D(0, 0, 0),
    Replicated = false,
};

---@param doTick boolean
function Object:SetDoTick(doTick)
    self.DoTick = doTick;
end

---@return boolean doTick
function Object:ShouldTick()
    return self.DoTick;
end

---@param world RustboltWorld
function Object:SetWorld(world)
    self.World = world;
end

---@return RustboltWorld world
function Object:GetWorld()
    return self.World;
end

---@param owner RustboltObject
function Object:SetOwner(owner)
    self.Owner = owner;
end

function Object:GetOwner()
    return self.Owner;
end

---@param name string
function Object:SetName(name)
    self.Name = name;
end

---@return string
function Object:GetName()
    return self.Name;
end

---@param guid RustboltGUID
function Object:SetGUID(guid)
    assert(not self.GUID, "Object already has an assigned GUID.");
    self.GUID = guid;
end

---@return RustboltGUID
function Object:GetGUID()
    return self.GUID;
end

---@return Vector3DMixin position
function Object:GetPosition()
    return self.Position;
end

---Set object position
---@param x number
---@param y number
---@param z number
function Object:SetPosition(x, y, z)
    if not self.Position then
        self.Position = CreateVector3D(x, y, z);
    else
        self.Position:SetXYZ(x, y, z);
    end
end

---Creates a subobject on this object
---@param componentName string
---@param ... any
---@return RustboltObject
function Object:CreateSubObject(componentName, ...)
    local component = ObjectManager:CreateObject(componentName, ...);
    component:SetOwner(self);

    Engine:DispatchEventForObject(component, "Adopt");
    tinsert(self.Children, component);
    return component;
end

---Returns a copy of the base 'Object' that all objects inherit from. Probably shouldn't be used.
function Object:Super(methodName, ...)
    return CopyTable(Object)[methodName](self, ...);
end

------------

local ObjectMeta = {};

function ObjectMeta:__newindex(key, value)
    if string.sub(key, 1, 2) == "On" then
        local eventName = string.sub(key, 3);
        Engine:RegisterForEvent(self, eventName);
    end

    rawset(self, key, value);
end

------------

ObjectManager:SetObjectTypeMetatable(Rustbolt.ObjectType.OBJECT, ObjectMeta);
ObjectManager:RegisterObjectType("Object", Rustbolt.ObjectType.OBJECT, Object);