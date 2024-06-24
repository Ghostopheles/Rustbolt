local Constants = Rustbolt.Constants;

local TILE_SIZE = Constants.Map.TileSize; -- 32x32
local SHEET_SIZE = Constants.SpritesheetSize; -- 512x512

local function FilePath(fileName)
    return format("Interface/AddOns/Rustbolt/Assets/%s.png", fileName);
end

local AssetCache = {};

---@class RustboltAsset
---@field Name string
---@field Path string
---@field Left number
---@field Right number
---@field Top number
---@field Bottom number
local AssetBase = {};

function AssetBase:Init(name, path, left, right, top, bottom)
    self.Name = name;
    self.Path = path;
    self.Left = left or 0;
    self.Right = right or 1;
    self.Top = top or 1;
    self.Bottom = bottom or 0;
end

---@return number left
---@return number right
---@return number top
---@return number bottom
function AssetBase:GetTexCoords()
    return self.Left, self.Right, self.Top, self.Bottom;
end

---@param texture Texture
function AssetBase:Apply(texture)
    texture:SetTexture(self.Path);
    texture:SetTexCoord(self:GetTexCoords());
end

---@class RustboltAssetManager
local AssetManager = {};

AssetManager.Assets = {
    Dirt = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 1
    },
    Dirt2 = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 2
    },
    DirtGrass = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 3
    },
    DirtGrass2 = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 4
    },
    DirtWater = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 5
    },
    WaterClear = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 6
    },
    WaterRough = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 7
    },
    GrassRough = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 8
    },
    GrassClear = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 9
    },
    Rocks = {
        Path = FilePath("EnvironmentSheet"),
        Row = 1,
        Column = 10
    },
    MissingNo = {
        Path = FilePath("EnvironmentSheet"),
        Row = 16,
        Column = 16,
    },
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

function AssetManager:CreateAsset(name, path, left, right, top, bottom)
    if AssetCache[name] then
        return AssetCache[name];
    end

    return CreateAndInitFromMixin(AssetBase, name, path, left, right, top, bottom);
end

---@param assetName string
---@return RustboltAsset
function AssetManager:GetAsset(assetName)
    local asset = self.Assets[assetName];
    if not asset then
        asset = self.Assets.MissingNo;
    end

    local path = asset.Path;

    if not asset.Row or not asset.Column then
        return self:CreateAsset(assetName, path);
    end

    local left = (asset.Column - 1) * TILE_SIZE;
    local right;
    if left == 0 then
        right = TILE_SIZE;
    else
        right = left + TILE_SIZE;
    end

    local top = (asset.Row - 1) * TILE_SIZE;
    local bottom;
    if top == 0 then
        bottom = TILE_SIZE;
    else
        bottom = top + TILE_SIZE;
    end

    return self:CreateAsset(assetName, path, left / SHEET_SIZE, right / SHEET_SIZE, top / SHEET_SIZE, bottom / SHEET_SIZE);
end

------------

Rustbolt.AssetManager = AssetManager;