--- See Types/Game.d.lua

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local ObjectManager = Rustbolt.ObjectManager;

------------

---@class RustboltGame
local Game = {};

---@param name string
---@param authors RustboltGameAuthor[]
---@param version RustboltGameVersion
function Game:Init(name, authors, version)
    self:SetName(name);
    self:SetAuthors(authors);
    self:SetVersion(version);

    self.NumWorlds = 0;
end

---@param name string
function Game:SetName(name)
    self.Name = name;
end

---@return string name
function Game:GetName()
    return self.Name;
end

---@param authors RustboltGameAuthor[]
function Game:SetAuthors(authors)
    self.Authors = authors;
end

---@return RustboltGameAuthor[] authors
function Game:GetAuthors()
    if not self.Authors then
        self.Authors = {};
    end

    return self.Authors;
end

---@param version RustboltGameVersion
function Game:SetVersion(version)
    self.Version = version;
end

---@return RustboltGameVersion version
function Game:GetVersion()
    return self.Version;
end

---@return boolean success
function Game:Save()
    local name = self:GetName();
    assert(name, "Unable to save a game with no name");

    RustboltGames[name] = self;

    return true;
end

---@param world RustboltWorld
function Game:AddWorld(world)
    local isFirstWorld = false;
    if not self.Worlds then
        self.Worlds = {};
        isFirstWorld = true;
    end

    local worldID = world:GetID();
    if not self.Worlds[worldID] then
        self.Worlds[worldID] = world;
    end

    if isFirstWorld then
        self:SetStartupWorldID(worldID);
        Registry:TriggerEvent(Events.EDITOR_LOAD_WORLD, world);
    end
end

---@param worldID RustboltWorldID
---@return RustboltWorld?
function Game:GetWorldByID(worldID)
    if not self.Worlds then
        return;
    end

    return self.Worlds[worldID];
end

---@return table<RustboltWorldID, RustboltWorld> worlds?
function Game:GetWorlds()
    return self.Worlds;
end

function Game:SetStartupWorldID(worldID)
    assert(self.Worlds[worldID], "Specified startup world does not exist within the current game.");
    self.StartupWorldID = worldID;
end

function Game:GetStartupWorldID()
    return self.StartupWorldID;
end

------------

local function SerializeGame(game)
    local serializedGame = {
        Name = game:GetName(),
        Authors = game:GetAuthors(),
        Version = game:GetVersion(),
        Worlds = {},
        StartupWorldID = game:GetStartupWorldID(),
    };

    local worldSerializer = ObjectManager:GetSerializerForObject(Rustbolt.ObjectType.WORLD);
    if worldSerializer then
        for _, world in pairs(game:GetWorlds()) do
            table.insert(serializedGame.Worlds, worldSerializer(world));
        end
    end

    return serializedGame;
end

ObjectManager:RegisterObjectType("Game", Rustbolt.ObjectType.GAME, Game);
ObjectManager:SetObjectTypeSerializer(Rustbolt.ObjectType.GAME, SerializeGame);