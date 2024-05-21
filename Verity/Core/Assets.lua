local TILE_SIZE = 32;
local SHEET_SIZE = 512;

local function FilePath(fileName)
    return format("Interface/AddOns/Verity/Assets/%s.png", fileName);
end

---@class VerityAssetManager
local AssetManager = {};

AssetManager.Assets = {
    Grass = {
        Path = FilePath("environment"),
        Row = 1,
        Column = 4
    },
    Water = {
        Path = FilePath("environment"),
        Row = 1,
        Column = 5
    },
    Dirt = {
        Path = FilePath("environment"),
        Row = 1,
        Column = 1
    },
    Dirt2 = {
        Path = FilePath("environment"),
        Row = 1,
        Column = 2
    },
    Fill = FilePath("PHTile"),
};

function AssetManager:GetAssetCount()
    local i = 1;
    for _ in pairs(self.Assets) do
        i = i + 1;
    end

    return i;
end

function AssetManager:GetAllAssets()
    return self.Assets;
end

function AssetManager:GetAssetPath(assetName)
    local asset = self.Assets[assetName];
    local path = asset.Path;

    local top = (asset.Row - 1) * TILE_SIZE;
    local bottom = SHEET_SIZE - top;

    local left = (asset.Column - 1) * TILE_SIZE;
    local right = SHEET_SIZE - left;

    return path, left, right, top, bottom;
end

------------

Verity.AssetManager = AssetManager;