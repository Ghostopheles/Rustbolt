local MathUtil = Rustbolt.MathUtil;
local MapConstants = Rustbolt.Constants.Map;

---@class RustboltCoordinate
---@field X number
---@field Y number

---@class RustboltMapTileBase
---@field AssetName string
---@field Walkable boolean
---@field Buildable boolean
---@field Water boolean
---@field Location RustboltCoordinate

---@class RustboltMapBase
---@field Fill string
---@field Tiles table<RustboltMapTile>
---@field Start table<RustboltMapTile>
---@field End table<RustboltMapTile>

------------

---@class RustboltMapTile : RustboltMapTileBase
local MapTileBase = {};

function MapTileBase:Init(assetName, isWalkable, isBuildable, isWater, x, y, parent)
    self.AssetName = assetName;
    self.Walkable = isWalkable;
    self.Buildable = isBuildable;
    self.Water = isWater;
    self.Location = {
        X = x,
        Y = y,
    };
    self.Parent = parent;
end

function MapTileBase:Next()
    local x, y = self.Location.X, self.Location.Y;
    local nextX, nextY = x + 1, y;
    if nextX >= MapConstants.MaxTilesX then
        nextX = 0;
        nextY = nextY + 1;
    end

    local next = self.Parent.Tiles[nextX][nextY];
    return next;
end

------------

local function CalculateCoordinatesFromIndex(index)
    return MathUtil.CalculateCoordinatesFromIndex(index, MapConstants.MaxTilesX);
end

---@class RustboltMap : RustboltMapBase
local MapBase = {};

function MapBase:Init(fill, tiles, startPos, endPos)
    self.Fill = fill;
    self.Start = startPos;
    self.End = endPos;

    self.Tiles = {};

    for index, tile in pairs(tiles) do
        local x, y = CalculateCoordinatesFromIndex(index);
        if not self.Tiles[x] then
            self.Tiles[x] = {};
        end

        self.Tiles[x][y] = CreateAndInitFromMixin(
            MapTileBase,
            tile.AssetName,
            tile.Walkable,
            tile.Buildable,
            tile.Water or false,
            x,
            y,
            self
        );
    end
end

function MapBase:EnumerateTiles(startX, startY)
    startX = startX or 0;
    startY = startY or 0;

    local i = 0;
    local currentTile;
    return function()
        if not currentTile then
            currentTile = self.Tiles[startX][startY];
        else
            currentTile = currentTile:Next();
        end
        i = i + 1;
        return currentTile, i;
    end, nil;
end

function MapBase:GetTileByIndex(index)
    local x, y = CalculateCoordinatesFromIndex(index);
    return self.Tiles[x][y];
end

------------

---@class RustboltMapManager
local MapManager = {};

---@type table<number, RustboltMap>
MapManager.Maps = {};

---@param mapID number
---@return RustboltMap? map
function MapManager:GetMap(mapID)
    local map = self.Maps[mapID];
    if map then
        return CreateAndInitFromMixin(MapBase, map.Fill, map.Tiles, map.Start, map.End);
    end
end

---@param assetName string
---@param isWalkable boolean
---@param isBuildable boolean
---@param isWater boolean
---@param x number
---@param y number
---@return RustboltMapTile mapTile
function MapManager:CreateMapTile(assetName, isWalkable, isBuildable, isWater, x, y)
    return CreateAndInitFromMixin(MapTileBase, assetName, isWalkable, isBuildable, isWater, x, y);
end

---@param x number
---@param y number
---@return RustboltMapTile mapTile
function MapManager:CreatePlaceholderMapTile(x, y)
    return self:CreateMapTile("MissingNo", false, true, false, x, y);
end

------------

Rustbolt.MapManager = MapManager;

EventUtil.ContinueOnAddOnLoaded("Rustbolt", function()
    if not RustboltDevMap then
        RustboltDevMap = {
            Tiles = {},
        };
    end

    for i=1, MapConstants.MaxTileCount do
        tinsert(RustboltDevMap.Tiles, {
            AssetName = "MissingNo",
            Walkable = false,
            Buildable = true,
        });
    end

    MapManager.Maps[1] = RustboltDevMap;
end);