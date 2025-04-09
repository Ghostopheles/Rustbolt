local Constants = Rustbolt.Constants;
local InputManager = Rustbolt.InputManager;
local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local FunctionUtil = Rustbolt.FunctionUtil;
local IO = Rustbolt.IO;
local E = Rustbolt.Enum;
local L = Rustbolt.Strings;

local TILE_TEMPLATE_NAME = "RustboltEditorViewportTileTemplate";
local TILE_WIDTH = Constants.EditorCanvas.TileWidth;
local TILE_HEIGHT = Constants.EditorCanvas.TileHeight;
local TILE_COLOR = CreateColor(0.25, 0.25, 0.25, 1);

local CANVAS_DRAG_BUTTON = "LeftButton";

------------

-- Camera object that will represent our view
-- the X and Y coords are the world coords of the top-left point of our camera
local Camera = {X = 0, Y = 0, Zoom = 0};

------------

RustboltEditorViewportCanvasMixin = {};

function RustboltEditorViewportCanvasMixin:OnLoad()
    self.HighlightFrame = self:CreateHighlightFrame();
    self.TilePool = CreateFramePool("FRAME", self, TILE_TEMPLATE_NAME);

    self.Zoom = 0;
end

function RustboltEditorViewportCanvasMixin:OnShow()
    self:InvalidateViewport();
end

function RustboltEditorViewportCanvasMixin:OnUpdate()
    if not self:IsShown() then
        return;
    end

    if self.IsMouseDown then
        local deltaX, deltaY = GetScaledCursorDelta();
        Camera.X = Camera.X + -deltaX;
        Camera.Y = Camera.Y + deltaY;
        self:InvalidateViewport();
    end
    self:Render();
end

function RustboltEditorViewportCanvasMixin:OnSizeChanged(width, height)
    self.TileLimits = {
        Width = Round(width / TILE_WIDTH) + 1,
        Height = Round(height / TILE_HEIGHT) + 1
    };
end

function RustboltEditorViewportCanvasMixin:OnTileEnter(tile)
    self.HighlightFrame:SetAllPoints(tile);
    self.HighlightFrame:Show();
end

function RustboltEditorViewportCanvasMixin:OnTileLeave()
    self.HighlightFrame:ClearAllPoints();
    self.HighlightFrame:Hide();
end

function RustboltEditorViewportCanvasMixin:OnMouseDown(button)
    if button ~= CANVAS_DRAG_BUTTON then
        self:SetPropagateMouseClicks(true);
    else
        self:SetPropagateMouseClicks(false);
        self.IsMouseDown = true;
    end
end

function RustboltEditorViewportCanvasMixin:OnMouseUp()
    self.IsMouseDown = false;
end

function RustboltEditorViewportCanvasMixin:RecalculateTileLimits()
    self:OnSizeChanged(self:GetWidth(), self:GetHeight());
end

function RustboltEditorViewportCanvasMixin:InvalidateViewport()
    self:SetViewportValid(false);
end

function RustboltEditorViewportCanvasMixin:SetViewportValid(isValid)
    self.ViewportValid = isValid;
end

function RustboltEditorViewportCanvasMixin:IsViewportValid()
    return self.ViewportValid;
end

function RustboltEditorViewportCanvasMixin:SetWorldBounds(bounds)
    self.WorldBounds = bounds;
end

function RustboltEditorViewportCanvasMixin:GetWorldBounds()
    return self.WorldBounds or {
        TopLeft = {X = 0, Y = 0},
        BottomRight = {X = 0, Y = 0}
    };
end

function RustboltEditorViewportCanvasMixin:CreateHighlightFrame()
    if self.HighlightFrame then return; end

    local f = CreateFrame("Frame", nil, self);
    f:SetFrameStrata("FULLSCREEN_DIALOG");
    local tex = f:CreateTexture(nil, "OVERLAY");
    tex:SetColorTexture(1, 1, 1, 0.5);
    tex:SetAllPoints();

    return f;
end

--TODO: make this faster
function RustboltEditorViewportCanvasMixin:Render()
    -- if the viewport is valid, it means we don't need to re-render anything
    if self:IsViewportValid() then
        return;
    end

    if not self.Tiles then
        self.Tiles = {};
    end

    if not self.TileLimits then
        self:RecalculateTileLimits();
    end

    local numTilesX = self.TileLimits.Width;
    local numTilesY = self.TileLimits.Height;

    local minTileX = floor(Camera.X / TILE_WIDTH);
    local minTileY = floor(Camera.Y / TILE_HEIGHT);

    local maxTileX = minTileX + numTilesX;
    local maxTileY = minTileY + numTilesY;

    -- map bounds based on camera position
    local bounds = {
        TopLeft = {X = minTileX, Y = minTileY},
        BottomRight = {X = maxTileX, Y = maxTileY}
    };

    -- set the new bounds
    self:SetWorldBounds(bounds);

    -- calculates the amount of 'extra space' we need to render around the edges of the viewport
    -- this might have issues
    local offsetX = Camera.X % TILE_WIDTH;
    local offsetY = Camera.Y % TILE_HEIGHT;

    for ix = minTileX, maxTileX do
        for iy = minTileY, maxTileY do
            local tileData = {
                X = ix,
                Y = iy,
                Width = TILE_WIDTH,
                Height = TILE_HEIGHT,
                Color = TILE_COLOR
            };

            if not self.Tiles[ix] then
                self.Tiles[ix] = {};
            end

            local tile = self.Tiles[ix][iy];
            if not tile then
                tile = self.TilePool:Acquire();
                self.Tiles[ix][iy] = tile;
                tile:Init(tileData);
            end

            local screenX = (ix - minTileX) * TILE_WIDTH - offsetX;
            local screenY = (iy - minTileY) * TILE_HEIGHT - offsetY;
            tile:SetPoint("TOPLEFT", self, "TOPLEFT", screenX, -screenY);

            tile:Show();
        end
    end

    -- cleanup
    self:CleanupUnusedTiles();

    self:SetViewportValid(true);
end

function RustboltEditorViewportCanvasMixin:CleanupUnusedTiles()
    local newBounds = self:GetWorldBounds();

    local minX = newBounds.TopLeft.X;
    local minY = newBounds.TopLeft.Y;

    local maxX = newBounds.BottomRight.X;
    local maxY = newBounds.BottomRight.Y;

    for ix, tiles in pairs(self.Tiles) do
        if ix < minX or ix > maxX then
            for _, tile in pairs(tiles) do
                self.TilePool:Release(tile);
            end
            self.Tiles[ix] = nil;
        else
            for iy, tile in pairs(tiles) do
                if iy < minY or iy > maxY then
                    self.TilePool:Release(tile);
                    tiles[iy] = nil;
                end
            end
        end
    end
end
