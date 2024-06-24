---@class RustboltMesh2D : RustboltObjectBase
local Mesh2D = Rustbolt.ObjectManager:CreateObject("Object");

function Mesh2D:Init(asset)
    self.Texture = UIParent:CreateTexture(nil, "OVERLAY");
end

function Mesh2D:OnAttach(parent)
    self.Parent = parent;
end


Rustbolt.ObjectManager:RegisterObjectType("Character", Rustbolt.ObjectType.OBJECT, Mesh2D);