---@class VerityObjectBase : VerityObject
local Object = {
    Context = nil,
    Parent = nil,
    Children = {},
    World = nil,
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