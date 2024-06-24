---@class VerityMesh2D : VerityObjectBase
local Mesh2D = Verity.ObjectManager:CreateObject("Object");

function Mesh2D:Init(asset)
    self.Texture = UIParent:CreateTexture(nil, "OVERLAY");
end

function Mesh2D:OnAttach(parent)
    self.Parent = parent;
end


Verity.ObjectManager:RegisterObjectType("Character", Verity.ObjectType.OBJECT, Mesh2D);