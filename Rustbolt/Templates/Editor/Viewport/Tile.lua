RustboltEditorViewportTileMixin = {};

---@class RustboltEditorViewportTileData
---@field X number
---@field Y number
---@field Width number
---@field Height number
---@field Color ColorMixin

---@param data RustboltEditorViewportTileData
function RustboltEditorViewportTileMixin:Init(data)
    self:SetSize(data.Width, data.Height);
    self:SetCoordinates(data.X, data.Y);
    self:SetColor(data.Color);
end

function RustboltEditorViewportTileMixin:OnLoad()
    self:SetMouseClickEnabled(false); -- because OnEnter enables mouse clicks for some reason
end

function RustboltEditorViewportTileMixin:OnEnter()
    local canvas = self:GetParent();
    canvas:OnTileEnter(self);
end

function RustboltEditorViewportTileMixin:OnLeave()
    local canvas = self:GetParent();
    canvas:OnTileLeave(self);
end

function RustboltEditorViewportTileMixin:SetCoordinates(x, y)
    self.X = x;
    self.Y = y;
end

function RustboltEditorViewportTileMixin:GetCoordinates()
    return self.X, self.Y;
end

function RustboltEditorViewportTileMixin:SetColor(color)
    self.Texture:SetColorTexture(color:GetRGBA());
end