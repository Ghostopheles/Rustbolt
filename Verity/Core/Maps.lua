

---@class VerityMapManager
local MapManager = {};

MapManager.Maps = {};

function MapManager:GetMap(mapID)
    return self.Maps[mapID];
end

------------

Verity.MapManager = MapManager;

EventUtil.ContinueOnAddOnLoaded("Verity", function() MapManager.Maps[1] = VerityDevMap; end);