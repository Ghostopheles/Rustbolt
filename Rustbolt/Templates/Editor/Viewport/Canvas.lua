local Constants = Rustbolt.Constants;
local InputManager = Rustbolt.InputManager;
local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local E = Rustbolt.Enum;
local L = Rustbolt.Strings;

local TILE_TEMPLATE_NAME = "RustboltEditorViewportTileTemplate";
local TILE_WIDTH = Constants.EditorCanvas.TileWidth;
local TILE_HEIGHT = Constants.EditorCanvas.TileHeight;

------------

-- Camera object that will represent our view
-- the X and Y coords are the world coords of the top-left point of our camera
local Camera = {
    X = 0,
    Y = 0,
    Zoom = 0
};

------------

RustboltEditorViewportCanvasMixin = {};

function RustboltEditorViewportCanvasMixin:OnLoad()
    self.HighlightFrame = self:CreateHighlightFrame();
    self.TilePool = CreateFramePool("FRAME", self, TILE_TEMPLATE_NAME);

    self.Zoom = 0;
end

function RustboltEditorViewportCanvasMixin:OnShow()
    self:CreatePlaceholderTiles();
end

function RustboltEditorViewportCanvasMixin:OnUpdate()
    if self.IsMouseDown then
        local deltaX, deltaY = GetScaledCursorDelta();
        Camera.X = Camera.X + -deltaX;
        Camera.Y = Camera.Y + deltaY;
        self:CreatePlaceholderTiles();
    end
end

function RustboltEditorViewportCanvasMixin:OnTileEnter(tile)
    self.HighlightFrame:SetAllPoints(tile);
    self.HighlightFrame:Show();
end

function RustboltEditorViewportCanvasMixin:OnTileLeave()
    self.HighlightFrame:ClearAllPoints();
    self.HighlightFrame:Hide();
end

function RustboltEditorViewportCanvasMixin:OnMouseDown()
    self.IsMouseDown = true;
end

function RustboltEditorViewportCanvasMixin:OnMouseUp()
    self.IsMouseDown = false;
end

function RustboltEditorViewportCanvasMixin:CreateHighlightFrame()
    if self.HighlightFrame then
        return;
    end

    local f = CreateFrame("Frame", nil, self);
    f:SetFrameStrata("FULLSCREEN_DIALOG");
    local tex = f:CreateTexture(nil, "OVERLAY");
    tex:SetColorTexture(1, 1, 1, 0.5);
    tex:SetAllPoints();

    return f;
end

function RustboltEditorViewportCanvasMixin:CreatePlaceholderTiles()
    local startTileX = floor(Camera.X / TILE_WIDTH);
    local startTileY = floor(Camera.Y / TILE_HEIGHT);
    local numTilesX = Round(self:GetWidth() / TILE_WIDTH) + 1;
    local numTilesY = Round(self:GetHeight() / TILE_HEIGHT) + 1;
    local offsetX = Camera.X % TILE_WIDTH;
    local offsetY = Camera.Y % TILE_HEIGHT;

    self.TilePool:ReleaseAll();

    local tiles = {};
    for iy=startTileY, startTileY + numTilesY do
        for ix=startTileX, startTileX + numTilesX do
            local tile = self.TilePool:Acquire();
            tile:SetSize(TILE_WIDTH, TILE_HEIGHT);
            tile.Texture:SetColorTexture(0.25, 0.25, 0.25, 1);
            tile:Show();
            tinsert(tiles, tile);

            local screenX = (ix - startTileX) * TILE_WIDTH - offsetX;
            local screenY = (iy - startTileY) * TILE_HEIGHT - offsetY;
            tile:SetPoint("TOPLEFT", self, "TOPLEFT", screenX, -screenY);
        end
    end
end