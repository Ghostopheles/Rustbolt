---@class VerityObjectBase : VerityObject
local Object = {
    Context = nil,
    Parent = nil,
    Children = {},
    World = nil,
    DoTick = false,
};

Object.OnBeginPlay = nop;
Object.OnEndPlay = nop;
Object.OnTick = nop;
Object.OnCreate = nop;
Object.OnDestroy = nop;

function Object:SetWorld(world)
    self.World = world;
end

function Object:GetWorld()
    return self.World;
end

function Object:Super(funcOrAttribute)
    return Object[funcOrAttribute];
end

Verity.ObjectManager:RegisterObjectType("Object", Verity.ObjectType.OBJECT, Object);