local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

------------

RustboltEditorViewportTileMixin = {};

---@class RustboltEditorViewportTileData
---@field X number
---@field Y number
---@field Width number
---@field Height number
---@field Color ColorMixin
---@field TileTexture string
---@field TileAtlas string

---@param data RustboltEditorViewportTileData
function RustboltEditorViewportTileMixin:Init(data)
    self:SetSize(data.Width, data.Height);
    self:SetCoordinates(data.X, data.Y);

    if data.Color then
        self:SetColor(data.Color);
    end

    if data.TileTexture then
        self:SetTexture(data.TileTexture);
    end

    if data.TileAtlas then
        self:SetAtlas(data.TileAtlas);
    end
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

function RustboltEditorViewportTileMixin:OnMouseDown(button)
    Registry:TriggerEvent(Events.EDITOR_TILE_CLICKED, self, button);
end

function RustboltEditorViewportTileMixin:OnMouseUp(button)
    Registry:TriggerEvent(Events.EDITOR_TILE_CLICKED, self, button);
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

function RustboltEditorViewportTileMixin:SetTexture(texture)
    self.Texture:SetTexture(texture);
end

function RustboltEditorViewportTileMixin:SetAtlas(atlas)
    self.Texture:SetAtlas(atlas, false);
end