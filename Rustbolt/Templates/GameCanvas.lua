local Constants = Rustbolt.Constants;

local InputManager = Rustbolt.InputManager;

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local GameEvents = Rustbolt.GameEvents;
local GameRegistry = Rustbolt.GameRegistry;

local Enum = Rustbolt.Enum;
local MapManager = Rustbolt.MapManager;

local AssetManager = Rustbolt.AssetManager;

local Animations = Rustbolt.AnimationManager;
local ThemeManager = Rustbolt.ThemeManager;
local L = Rustbolt.Strings;

local MAX_TILES = Constants.Map.MaxTileCount;
local MAX_TILES_X = Constants.Map.MaxTilesX;
local TILE_SIZE = Constants.Map.TileSize; -- 32x32

local EMPTY_TILE_COLOR = CreateColor(0.25, 0.25, 0.25, 1);
local TILE_TEMPLATE = "RustboltGameTileTemplate";

local KEY_TOGGLE_WALKABLE = "R";
local KEY_TOGGLE_BUILDABLE = "T";
local KEY_TOGGLE_WATER = "F";

local function InDevMode()
    return RustboltDevTools:IsDevModeActive();
end

local function GetSelectedAsset()
    return RustboltAssetPicker:GetSelectedAsset();
end

local function CalculateCoordinatesFromIndex(index)
    return MathUtil.CalculateCoordinatesFromIndex(index, Constants.Map.MaxTilesX);
end

------------

RustboltGameTileMixin = {};

function RustboltGameTileMixin:OnLoad()
    Registry:RegisterCallback(Events.DEV_STATE_CHANGED, self.OnDevStateChanged, self);
end

---@param tile RustboltMapTile
function RustboltGameTileMixin:Init(tile)
    self:ClearAllPoints();
    self:SetSize(TILE_SIZE, TILE_SIZE);

    self.Tile = tile;

    self:SetTileAsset(tile.AssetName);
    self:SetWalkable(tile.Walkable);
    self:SetBuildable(tile.Buildable);
    self:SetWater(tile.Water);
    self:SetLocation(tile.Location);
end

function RustboltGameTileMixin:OnKeyDown(key)
    if key == KEY_TOGGLE_WALKABLE then
        self:SetWalkable(not self:IsWalkable());
    elseif key == KEY_TOGGLE_BUILDABLE then
        self:SetBuildable(not self:IsBuildable());
    elseif key == KEY_TOGGLE_WATER then
        self:SetWater(not self:IsWater());
    end
end

function RustboltGameTileMixin:OnKeyUp(key)
    print(key);
end

function RustboltGameTileMixin:OnMouseDown()
    if not InDevMode() then
        return;
    end

    local tile = GetSelectedAsset();
    if tile then
        self:EditTile(tile);
    end
end

function RustboltGameTileMixin:OnMouseUp()
end

function RustboltGameTileMixin:OnEnter()
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

function RustboltGameTileMixin:OnLeave()
    if not InDevMode() then
        return;
    end

    local parent = self:GetParent();
    parent:ClearHighlight();

    GameTooltip:FadeOut();
end

function RustboltGameTileMixin:EditTile(tile)
    if not RustboltDevMap then
        RustboltDevMap = {
            Tiles = {},
        };
    end

    if not RustboltDevMap.Tiles[self.layoutIndex] then
        RustboltDevMap.Tiles[self.layoutIndex] = {
            AssetName = tile,
            Walkable = false,
            Buildable = true,
        };
    else
        RustboltDevMap.Tiles[self.layoutIndex].AssetName = tile;
    end

    local asset = AssetManager:GetAsset(tile);
    self:SetTileAsset(asset);
end

function RustboltGameTileMixin:SetTileAsset(asset)
    if type(asset) ~= "table" then
        asset = AssetManager:GetAsset(asset);
    end
    asset:Apply(self);
    self.Asset = asset;
end

function RustboltGameTileMixin:OnDevStateChanged(inDevMode)
    if not inDevMode and GameTooltip:GetOwner() == self then
        GameTooltip:Hide();
    end
end

function RustboltGameTileMixin:MakeEmpty()
    self:SetColorTexture(EMPTY_TILE_COLOR:GetRGB());
end

function RustboltGameTileMixin:SetWalkable(walkable)
    self.Walkable = walkable;
    RustboltDevMap.Tiles[self.layoutIndex]["Walkable"] = walkable;
    self:SetDesaturated(walkable);
    self:SetBuildable(false);
end

function RustboltGameTileMixin:IsWalkable()
    return self.Walkable;
end

function RustboltGameTileMixin:SetBuildable(buildable)
    self.Buildable = buildable;
    RustboltDevMap.Tiles[self.layoutIndex]["Buildable"] = buildable;
end

function RustboltGameTileMixin:IsBuildable()
    return self.Buildable;
end

function RustboltGameTileMixin:SetWater(water)
    self.Water = water;
    RustboltDevMap.Tiles[self.layoutIndex]["Water"] = water;
end

function RustboltGameTileMixin:IsWater()
    return self.Water;
end

function RustboltGameTileMixin:SetLocation(location)
    self.Location = location;
    RustboltDevMap.Tiles[self.layoutIndex]["Location"] = location;
end

function RustboltGameTileMixin:GetLocation()
    return self.Location;
end

------------

RustboltGameCanvasMixin = {};

function RustboltGameCanvasMixin:OnLoad()
    self.TilePool = CreateTexturePool(self, "ARTWORK", -1, TILE_TEMPLATE);
    self.DisplayedMapID = 0;

    Registry:RegisterCallback(Events.SCREEN_CHANGED, self.OnScreenChanged, self);
    Registry:RegisterCallback(Events.DEV_STATE_CHANGED, self.OnDevStateChanged, self);

    InputManager:RegisterInputListener(KEY_TOGGLE_WALKABLE, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);
    InputManager:RegisterInputListener(KEY_TOGGLE_BUILDABLE, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);
    InputManager:RegisterInputListener(KEY_TOGGLE_WATER, self.OnKeyDown, self, Enum.ScreenName.GAME, InDevMode);

    self.TileHighlight:Hide();
end

function RustboltGameCanvasMixin:OnShow()
end

function RustboltGameCanvasMixin:OnHide()
end

function RustboltGameCanvasMixin:OnKeyDown(key)
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

function RustboltGameCanvasMixin:OnKeyUp(...)
    if self.SelectedTile then
        self.SelectedTile:OnKeyUp(...);
    end
end

function RustboltGameCanvasMixin:OnScreenChanged(screenName)
    if screenName == Enum.ScreenName.GAME then
        self:LoadMap(1);
    end
end

function RustboltGameCanvasMixin:OnDevStateChanged(inDevMode)
    self.TileHighlight:SetShown(inDevMode);
end

function RustboltGameCanvasMixin:SetHighlighted(tile)
    self.TileHighlight:SetAllPoints(tile);
    self.SelectedTile = tile;
end

function RustboltGameCanvasMixin:ClearHighlight()
    self.TileHighlight:ClearAllPoints();
    self.SelectedTile = nil;
end

function RustboltGameCanvasMixin:Clear()
    self.TilePool:ReleaseAll();
    self.DisplayedMapID = 0;
end

function RustboltGameCanvasMixin:LoadMap(mapID)
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
        tile:Show();
        tinsert(tiles, tile);
    end

    local layout = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.TopLeftToBottomRight, MAX_TILES_X);

    local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0);
    AnchorUtil.GridLayout(tiles, initialAnchor, layout);

    self.DisplayedMapID = mapID;
end

function RustboltGameCanvasMixin:GetMapID()
    return self.DisplayedMapID;
end