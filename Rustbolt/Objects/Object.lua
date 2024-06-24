---@class RustboltObject
---@field protected Owner RustboltObject
---@field protected Children table<RustboltObject>
---@field protected World? RustboltWorld
---@field DoTick boolean
---@field Position Vector3DMixin
local Object = {
    Children = {}
};

function Object:OnBeginPlay()
end

function Object:OnEndPlay()
end

function Object:OnTick(deltaTime)
end

function Object:OnCreate()
end

function Object:OnDestroy()
end

function Object:OnAdopt()
end

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
    local component = Rustbolt.ObjectManager:CreateObject(componentName, ...);
    component:SetOwner(self);
    component:OnAdopt();

    tinsert(self.Children, component);
    return component;
end

function Object:Super(funcOrAttribute)
    return Object[funcOrAttribute];
end

Rustbolt.ObjectManager:RegisterObjectType("Object", Rustbolt.ObjectType.OBJECT, Object);