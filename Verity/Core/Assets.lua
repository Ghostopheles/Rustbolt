
local function FilePath(fileName)
    return format("Interface/AddOns/Verity/Assets/%s.png", fileName);
end

---@class VerityAssetManager
local AssetManager = {};

AssetManager.Assets = {
    Grass = FilePath("Grass"),
    Water = FilePath("Water"),
    Dirt = FilePath("Dirt"),
};

function AssetManager:GetAllAssets()
    return self.Assets;
end

function AssetManager:GetAssetPath(assetName)
    return self.Assets[assetName];
end

------------

Verity.AssetManager = AssetManager;