local Engine = Rustbolt.Engine;
local WorldConstants = Rustbolt.Constants.World;
local ObjectManager = Rustbolt.ObjectManager;

------------

local function GenerateTilesForEmptyWorld()
    local w, h = WorldConstants.MaxWidth, WorldConstants.MaxHeight;
    local tiles = {};
    for x=1, w do
        for y=1, h do
            local tile = {
                PositionX = x,
                PositionY = y,
                TileAtlas = "uitools-window-background"
            };
            tinsert(tiles, tile);
        end
    end

    return tiles;
end

------------

---@alias RustboltWorldID string

---@class RustboltWorldTile
---@field PositionX number
---@field PositionY number
---@field TileTexture string
---@field TileAtlas string

---@class RustboltWorldSettings

---@class RustboltWorld
---@field protected ID RustboltWorldID Unique world identifier
---@field protected Name string Human-readable world name
---@field protected Objects RustboltObject[]
---@field protected NameToObject table<string, RustboltObject>
---@field protected Settings RustboltWorldSettings
---@field protected Tiles RustboltWorldTile[]
---@field private CoordinatesToTile table<number, table<number, RustboltWorldTile>>
local World = {};

function World:Init(name, id)
    self.Objects = {};
    self.NameToObject = {};

    self:SetName(name);
    self:SetID(id);
    self:GenerateEmptyWorld();
end

function World:ApplyWorldSettings(worldSettings)
    self.Settings = worldSettings;
end

---@param name string
function World:SetName(name)
    self.Name = name;
end

---@return string
function World:GetName()
    return self.Name;
end

---@param id RustboltWorldID
function World:SetID(id)
    self.ID = id;
end

---@return RustboltWorldID
function World:GetID()
    return self.ID;
end

function World:GenerateEmptyWorld()
    assert(not self.Tiles, "World is already populated with tiles.");
    self:SetWorldTiles(GenerateTilesForEmptyWorld());
end

---@param tiles RustboltWorldTile[]
function World:SetWorldTiles(tiles)
    assert(not self.Tiles, "World tiles have already been set.");

    self.Tiles = tiles;
    self.CoordinatesToTile = {};

    for _, tile in ipairs(tiles) do
        local x = tile.PositionX;
        local y = tile.PositionY;

        if not self.CoordinatesToTile[x] then
            self.CoordinatesToTile[x] = {};
        end

        self.CoordinatesToTile[x][y] = tile;
    end
end

---@return RustboltWorldTile[]? tiles
function World:GetWorldTiles()
    return self.Tiles;
end

---@param x number
---@param y number
---@return RustboltWorldTile? tile
function World:GetWorldTileAtCoodinates(x, y)
    if not self.CoordinatesToTile[x] then
        return nil;
    end

    return self.CoordinatesToTile[x][y];
end

---Creates and initializes an object in the world
---@param name string
---@param objectTypeName string
---@param ... any Arguments passed to object constructor
---@return RustboltObject? object
function World:CreateObject(name, objectTypeName, ...)
    local object = ObjectManager:CreateObject(objectTypeName, ...);
    object:SetWorld(self);
    Engine:DispatchEventForObject(object, "Create");

    tinsert(self.Objects, object);
    self.NameToObject[name] = object;
    return object;
end

---@return RustboltObject[] objects
function World:GetAllObjects()
    return self.Objects;
end

---@param name string
---@return RustboltObject? object
function World:GetObjectByName(name)
    return self.Objects[name];
end

---@param guid RustboltGUID
---@return RustboltObject? object
function World:GetObjectByGUID(guid)
    return ObjectManager:GetObjectByGUID(guid);
end

------------

local function SerializeWorld(world)
    local serializedWorld = {
        ID = world:GetID(),
        Name = world:GetName(),
        Tiles = world:GetWorldTiles(),
        Objects = {},
        Settings = world.Settings,
    };

    local objectSerializer = ObjectManager:GetSerializerForObject(Rustbolt.ObjectType.OBJECT);
    if objectSerializer then
        for _, object in pairs(world:GetAllObjects()) do
            table.insert(serializedWorld.Objects, objectSerializer(object));
        end
    end

    return serializedWorld;
end

ObjectManager:RegisterObjectType("World", Rustbolt.ObjectType.WORLD, World);
ObjectManager:SetObjectTypeSerializer(Rustbolt.ObjectType.WORLD, SerializeWorld);