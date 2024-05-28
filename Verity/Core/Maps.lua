---@class VerityCoordinate
---@field X number
---@field Y number

---@class VerityMapTile
---@field AssetName string
---@field Walkable boolean
---@field Buildable boolean

---@class VerityMap
---@field Fill? string
---@field Tiles? table<VerityMapTile>
---@field Start table<VerityMapTile>
---@field End table<VerityMapTile>

---@class VerityMapManager
local MapManager = {};

---@type table<number, VerityMap>
MapManager.Maps = {};

---@param mapID number
---@return VerityMap map
function MapManager:GetMap(mapID)
    return self.Maps[mapID];
end

------------

Verity.MapManager = MapManager;

EventUtil.ContinueOnAddOnLoaded("Verity", function() MapManager.Maps[1] = VerityDevMap; end);