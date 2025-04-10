--- See Types/Game.d.lua

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
    if not self.Worlds then
        self.Worlds = {};
    end

    local worldID = world:GetID();
    if not self.Worlds[worldID] then
        self.Worlds[worldID] = world;
    end
end

---@param worldID string
---@return RustboltWorld?
function Game:GetWorldByID(worldID)
    if not self.Worlds then
        return;
    end

    return self.Worlds[worldID];
end

---@return RustboltWorld[]?
function Game:GetWorlds()
    return self.Worlds;
end

------------

-- TODO: Add a serializer for the game object

ObjectManager:RegisterObjectType("Game", Rustbolt.ObjectType.GAME, Game);