---@class VerityObjectBase : VerityObject
---@field Context nil
---@field Owner VerityObject
---@field Children table<VerityObjectBase>
---@field World? VerityWorld
---@field DoTick boolean
---@field Position Vector3DMixin
local Object = {
    Children = {}
};

Object.OnBeginPlay = nop;
Object.OnEndPlay = nop;
Object.OnTick = nop;
Object.OnCreate = nop;
Object.OnDestroy = nop;
Object.OnAdopt = nop;

---@param doTick boolean
function Object:SetDoTick(doTick)
    self.DoTick = doTick;
end

---@return boolean doTick
function Object:ShouldTick()
    return self.DoTick and self.OnTick ~= nop and type(self.OnTick) == "function";
end

---@param world VerityWorld
function Object:SetWorld(world)
    self.World = world;
end

---@return VerityWorld world
function Object:GetWorld()
    return self.World;
end

---@param owner VerityObjectBase
function Object:SetOwner(owner)
    self.Owner = owner;
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
---@return VerityObjectBase
function Object:CreateSubobject(componentName, ...)
    local component = Verity.ObjectManager:CreateObject(componentName, ...);
    component:SetOwner(self);
    component:OnAdopt();

    tinsert(self.Children, component);
    return component;
end

function Object:Super(funcOrAttribute)
    return Object[funcOrAttribute];
end

Verity.ObjectManager:RegisterObjectType("Object", Verity.ObjectType.OBJECT, Object);