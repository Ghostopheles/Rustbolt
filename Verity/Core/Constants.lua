---@class VerityConstants
local Constants = {};

---@class VerityMapConstants
local Map = {};
Map.MaxTileCount = 1400;
Map.MaxTilesX = 50;
Map.MaxTilesY = Map.MaxTileCount / Map.MaxTilesX;
Map.TileSize = 32; -- 32x32

Constants.Map = Map;

Constants.SpritesheetSize = 512;

------------

Verity.Constants = Constants;