---@class RustboltConstants
local Constants = {};

---@class RustboltMapConstants
local Map = {};
Map.MaxTileCount = 1400;
Map.MaxTilesX = 50;
Map.MaxTilesY = Map.MaxTileCount / Map.MaxTilesX;
Map.TileSize = 32; -- 32x32

Constants.Map = Map;

Constants.SpritesheetSize = 512;

---@class RustboltInputConstants
local Input = {};
Input.DoubleTapTimeout = 0.5;

Constants.Input = Input;

------------

Rustbolt.Constants = Constants;