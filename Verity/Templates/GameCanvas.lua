local Constants = Verity.Constants;

local InputManager = Verity.InputManager;

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

local MAX_TILES = Constants.Map.MaxTileCount;
local MAX_TILES_X = Constants.Map.MaxTilesX;
local TILE_SIZE = Constants.Map.TileSize; -- 32x32

local EMPTY_TILE_COLOR = CreateColor(0.25, 0.25, 0.25, 1);
local TILE_TEMPLATE = "VerityGameTileTemplate";

local KEY_TOGGLE_WALKABLE = "R";
local KEY_TOGGLE_BUILDABLE = "T";
local KEY_TOGGLE_WATER = "F";

local CONSUME_KEYS = {
    [KEY_TOGGLE_WALKABLE] = true,
    [KEY_TOGGLE_BUILDABLE] = true,
    [KEY_TOGGLE_WATER] = true,
};

local function ShouldPropagateKey(key)
    return not CONSUME_KEYS[key];
end

local function InDevMode()
    return VerityDevTools and Verity.Globals.Version == "dev";
end

local function GetSelectedAsset()
    return VerityAssetPicker:GetSelectedAsset();
end

local function CalculateCoordinatesFromIndex(index)
    return MathUtil.CalculateCoordinatesFromIndex(index, Constants.Map.MaxTilesX);
end

------------

VerityGameTileMixin = {};

---@param tile VerityMapTile
function VerityGameTileMixin:Init(tile)
    self:ClearAllPoints();
    self:SetSize(TILE_SIZE, TILE_SIZE);

    self.Tile = tile;

    self:SetTileAsset(tile.AssetName);
    self:SetWalkable(tile.Walkable);
    self:SetBuildable(tile.Buildable);
    self:SetWater(tile.Water);
    self:SetLocation(tile.Location);
end

function VerityGameTileMixin:OnKeyDown(key)
    if key == KEY_TOGGLE_WALKABLE then
        self:SetWalkable(not self:IsWalkable());
    elseif key == KEY_TOGGLE_BUILDABLE then
        self:SetBuildable(not self:IsBuildable());
    elseif key == KEY_TOGGLE_WATER then
        self:SetWater(not self:IsWater());
    end
end

function VerityGameTileMixin:OnKeyUp(key)
    print(key);
end

function VerityGameTileMixin:OnMouseDown()
    if not InDevMode() then
        return;
    end

    local tile = GetSelectedAsset();
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
        local tile = GetSelectedAsset();
        if tile then
            self:EditTile(tile);
        end
    end

    local fmt = "X: %d Y: %d\nAsset: %s\nWalkable: %s\nBuildable: %s\nWater: %s";
    local location = self:GetLocation();
    local tooltipText = format(fmt, location.X, location.Y, self.Asset.Name, tostring(self:IsWalkable()), tostring(self:IsBuildable()), tostring(self:IsWater()));

    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
    GameTooltip:SetText(tooltipText, 1, 1, 1, 1);
    GameTooltip:Show();
end

function VerityGameTileMixin:OnLeave()
    if not InDevMode() then
        return;
    end

    local parent = self:GetParent();
    parent:ClearHighlight();

    GameTooltip:FadeOut();
end

function VerityGameTileMixin:EditTile(tile)
    if not VerityDevMap then
        VerityDevMap = {
            Tiles = {},
        };
    end

    if not VerityDevMap.Tiles[self.layoutIndex] then
        VerityDevMap.Tiles[self.layoutIndex] = {
            AssetName = tile,
            Walkable = false,
            Buildable = true,
        };
    else
        VerityDevMap.Tiles[self.layoutIndex].AssetName = tile;
    end

    local asset = AssetManager:GetAsset(tile);
    self:SetTileAsset(asset);
end

function VerityGameTileMixin:SetTileAsset(asset)
    if type(asset) ~= "table" then
        asset = AssetManager:GetAsset(asset);
    end
    asset:Apply(self);
    self.Asset = asset;
end

function VerityGameTileMixin:MakeEmpty()
    self:SetColorTexture(EMPTY_TILE_COLOR:GetRGB());
end

function VerityGameTileMixin:SetWalkable(walkable)
    self.Walkable = walkable;
    VerityDevMap.Tiles[self.layoutIndex]["Walkable"] = walkable;
    self:SetDesaturated(walkable);
    self:SetBuildable(false);
end

function VerityGameTileMixin:IsWalkable()
    return self.Walkable;
end

function VerityGameTileMixin:SetBuildable(buildable)
    self.Buildable = buildable;
    VerityDevMap.Tiles[self.layoutIndex]["Buildable"] = buildable;
end

function VerityGameTileMixin:IsBuildable()
    return self.Buildable;
end

function VerityGameTileMixin:SetWater(water)
    self.Water = water;
    VerityDevMap.Tiles[self.layoutIndex]["Water"] = water;
end

function VerityGameTileMixin:IsWater()
    return self.Water;
end

function VerityGameTileMixin:SetLocation(location)
    self.Location = location;
    VerityDevMap.Tiles[self.layoutIndex]["Location"] = location;
end

function VerityGameTileMixin:GetLocation()
    return self.Location;
end

------------

VerityGameCanvasMixin = {};

function VerityGameCanvasMixin:OnLoad()
    self.TilePool = CreateTexturePool(self, "ARTWORK", -1, TILE_TEMPLATE);
    self.TilePool:SetResetDisallowedIfNew(true);

    self.DisplayedMapID = 0;

    Registry:RegisterCallback(Events.SCREEN_CHANGED, self.OnScreenChanged, self);

    InputManager:RegisterInputListener(KEY_TOGGLE_WALKABLE, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);
    InputManager:RegisterInputListener(KEY_TOGGLE_BUILDABLE, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);
    InputManager:RegisterInputListener(KEY_TOGGLE_WATER, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);
end

function VerityGameCanvasMixin:OnShow()
end

function VerityGameCanvasMixin:OnHide()
end

function VerityGameCanvasMixin:OnKeyDown(key)
    if self.SelectedTile then
        local tile = self.SelectedTile;
        if key == KEY_TOGGLE_WALKABLE then
            tile:SetWalkable(not tile:IsWalkable());
        elseif key == KEY_TOGGLE_BUILDABLE then
            tile:SetBuildable(not tile:IsBuildable());
        elseif key == KEY_TOGGLE_WATER then
            tile:SetWater(not tile:IsWater());
        end
    end
end

function VerityGameCanvasMixin:OnKeyUp(...)
    if self.SelectedTile then
        self.SelectedTile:OnKeyUp(...);
    end
end

function VerityGameCanvasMixin:OnScreenChanged(screenName)
    if screenName == Enum.ScreenName.GAME then
        self:LoadMap(1);
    end
end

function VerityGameCanvasMixin:SetHighlighted(tile)
    self.TileHighlight:SetAllPoints(tile);
    self.SelectedTile = tile;
end

function VerityGameCanvasMixin:ClearHighlight()
    self.TileHighlight:ClearAllPoints();
    self.SelectedTile = nil;
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

    if not map then
        return;
    end

    local tiles = {};
    for i=1, MAX_TILES do
        local tile = self.TilePool:Acquire();
        tile.layoutIndex = i;

        local tileData = map:GetTileByIndex(i);

        if not tileData then
            local x, y = CalculateCoordinatesFromIndex(i);
            MapManager:CreatePlaceholderMapTile(x, y);
        end

        tile:Init(tileData);
        tinsert(tiles, tile);
    end

    local layout = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.TopLeftToBottomRight, MAX_TILES_X);

    local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0);
    AnchorUtil.GridLayout(tiles, initialAnchor, layout);

    self.DisplayedMapID = mapID;
end