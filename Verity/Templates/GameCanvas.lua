local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local GameEvents = Verity.GameEvents;
local GameRegistry = Verity.GameRegistry;

local Enum = Verity.Enum;
local MapManager = Verity.MapManager;
local AssetManager = Verity.AssetManager;
local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

local MAX_TILES = 1400;
local MAX_TILES_Y = 50;
local TILE_SIZE = 32; -- 32x32

local EMPTY_TILE_COLOR = CreateColor(0.25, 0.25, 0.25, 1);
local TILE_TEMPLATE = "VerityGameTileTemplate";

local function InDevMode()
    return VerityDevTools and Verity.Globals.Version == "dev";
end

VerityGameTileMixin = {};

function VerityGameTileMixin:OnMouseDown()
    if not InDevMode() then
        return;
    end

    local tile = VerityDevTools.SelectedTile;
    if tile then
        self:EditTile(tile);
    end
end

function VerityGameTileMixin:OnMouseUp()
end

function VerityGameTileMixin:OnEnter()
    if not InDevMode() then
        return;
    end

    local parent = self:GetParent();
    parent:SetHighlighted(self);

    if IsMouseButtonDown("LeftButton") then
        local tile = VerityDevTools.SelectedTile;
        if tile then
            self:EditTile(tile);
        end
    end
end

function VerityGameTileMixin:OnLeave()
    if not InDevMode() then
        return;
    end

    local parent = self:GetParent();
    parent:ClearHighlight();
end

function VerityGameTileMixin:EditTile(tile)
    if not VerityDevMap then
        VerityDevMap = {
            Tiles = {},
        };
    end

    VerityDevMap.Tiles[self.layoutIndex] = tile;
    local asset = AssetManager:GetAssetPath(tile);
    self:SetTileTexture(asset);
end

function VerityGameTileMixin:Init(texture)
    self:ClearAllPoints();
    self:SetSize(TILE_SIZE, TILE_SIZE);
    self:SetTileTexture(texture);
end

function VerityGameTileMixin:SetTileTexture(texture, ...)
    if texture then
        self:SetTexture(texture, ...);
    else
        self:MakeEmpty();
    end
end

function VerityGameTileMixin:MakeEmpty()
    self:SetColorTexture(EMPTY_TILE_COLOR:GetRGB());
end

------------

VerityGameCanvasMixin = {};

function VerityGameCanvasMixin:OnLoad()
    self.TilePool = CreateTexturePool(self, "ARTWORK", -1, TILE_TEMPLATE);
    self.TilePool:SetResetDisallowedIfNew(true);

    self.DisplayedMapID = 0;

    Registry:RegisterCallback(Events.SCREEN_CHANGED, self.OnScreenChanged, self);
end

function VerityGameCanvasMixin:OnShow()
end

function VerityGameCanvasMixin:OnHide()
end

function VerityGameCanvasMixin:OnScreenChanged(screenName)
    if screenName == Enum.ScreenName.GAME then
        self:LoadMap(1);
    end
end

function VerityGameCanvasMixin:SetHighlighted(tile)
    self.TileHighlight:SetAllPoints(tile);
end

function VerityGameCanvasMixin:ClearHighlight()
    self.TileHighlight:ClearAllPoints();
end

function VerityGameCanvasMixin:Clear()
    self.TilePool:ReleaseAll();
    self.DisplayedMapID = 0;
end

function VerityGameCanvasMixin:LoadMap(mapID)
    if self.TilePool:GetNumActive() > 0 then
        self:Clear();
    end

    local map = MapManager:GetMap(mapID);

    local tiles = {};
    for i=1, MAX_TILES do
        local tile = self.TilePool:Acquire();
        tile.layoutIndex = i;

        local texture;
        if map.Tiles and map.Tiles[i] then
            local assetName = map.Tiles[i];
            texture = AssetManager:GetAssetPath(assetName);
        else
            texture = map.Fill;
        end
        tile:Init(texture);

        tinsert(tiles, tile);
    end

    local layout = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.TopLeftToBottomRight, MAX_TILES_Y);

    local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0);
    AnchorUtil.GridLayout(tiles, initialAnchor, layout);

    self.DisplayedMapID = mapID;
end