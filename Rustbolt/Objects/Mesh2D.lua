---@class RustboltMesh2D : RustboltObject
---@field private LastX number
---@field private LastY number
---@field private LastZ number
local Mesh2D = Rustbolt.ObjectManager:CreateObject("Object");

function Mesh2D:Init(asset, width, height)
    self.Texture = Rustbolt.Engine:CreateTexture();
    self.Texture:SetAtlas(asset);
    self.Texture:SetSize(width, height);
    self.Texture:SetVertexColor(0.9, 0, 0.8);
end

function Mesh2D:OnTick(deltaTime)
    if not self.DoTick then
        return;
    end

    self:UpdatePosition();
end

function Mesh2D:UpdatePosition()
    local owner = self:GetOwner();
    if not owner then
        return;
    end

    local ownerPos = owner:GetPosition();
    local x, y, z = ownerPos:GetXYZ();
    if self.LastX == x and self.LastY == y and self.LastZ == z then
        return;
    end

    self.LastX = x;
    self.LastY = y;
    self.LastZ = z;

    Rustbolt.Engine:PositionObjectByWorldCoords(self.Texture, x, y, z);
end

------------

Rustbolt.ObjectManager:RegisterObjectType("Mesh2D", Rustbolt.ObjectType.OBJECT, Mesh2D);