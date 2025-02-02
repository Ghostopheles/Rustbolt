local Constants = Rustbolt.Constants;
local InputManager = Rustbolt.InputManager;
local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local E = Rustbolt.Enum;
local L = Rustbolt.Strings;

local TILE_TEMPLATE_NAME = "RustboltEditorViewportTileTemplate";
local TILE_WIDTH = 32;
local TILE_HEIGHT = 32;

RustboltEditorViewportCanvasMixin = {};

function RustboltEditorViewportCanvasMixin:OnLoad()
    self.HighlightFrame = self:CreateHighlightFrame();
    self.TilePool = CreateFramePool("FRAME", self, TILE_TEMPLATE_NAME);

    self.Zoom = 0;
end

function RustboltEditorViewportCanvasMixin:OnShow()
    self:CreatePlaceholderTiles();
end

function RustboltEditorViewportCanvasMixin:OnTileEnter(tile)
    self.HighlightFrame:SetAllPoints(tile);
    self.HighlightFrame:Show();
end

function RustboltEditorViewportCanvasMixin:OnTileLeave(tile)
    self.HighlightFrame:ClearAllPoints();
    self.HighlightFrame:Hide();
end

function RustboltEditorViewportCanvasMixin:OnKeyDown(key)
end

function RustboltEditorViewportCanvasMixin:OnKeyUp(key)
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
    local maxTilesX = Round(self:GetWidth() / TILE_WIDTH);
    local maxTilesY = Round(self:GetHeight() / TILE_HEIGHT);

    local tiles = {};
    for i=1, maxTilesX * maxTilesY do
        local tile = self.TilePool:Acquire();
        tile:SetSize(TILE_WIDTH, TILE_HEIGHT);
        tile.Texture:SetColorTexture(0.25, 0.25, 0.25, 1);
        tile:Show();
        tinsert(tiles, tile);
    end

    self:LayoutTiles(tiles);

    --local direction = GridLayoutMixin.Direction.TopLeftToBottomRight;
    --local stride = maxTilesX;
    --local layout = AnchorUtil.CreateGridLayout(direction, stride);

    --local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0);
    --AnchorUtil.GridLayout(tiles, initialAnchor, layout);
end

function RustboltEditorViewportCanvasMixin:LayoutTiles(tiles)
    local width = TILE_WIDTH;
    local height = TILE_HEIGHT;
    local stride = Round(self:GetWidth() / width);
    local directionX = 1;
    local directionY = -1;

    for i, frame in ipairs(tiles) do
        local row = floor((i - 1) / stride) + 1;
        local col = (i - 1) % stride + 1;
        local offsetX = (col - 1) * width * directionX;
        local offsetY = (row - 1) * height * directionY;
        PixelUtil.SetPoint(frame, "TOPLEFT", self, "TOPLEFT", offsetX, offsetY, 1, 1);
    end
end