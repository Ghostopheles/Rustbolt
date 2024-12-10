---@class RustboltGameAuthor
---@field Name string
---@field SocialHandle string?
---@field Role string?

---@alias RustboltGameVersion string | number

---@class RustboltGameSaved
---@field Name string
---@field Authors RustboltGameAuthor[]
---@field Version RustboltGameVersion

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

------------

---@class RustboltEditorObjects
local EditorObjects = Rustbolt.EditorObjects;

---@param gameInfo RustboltGameSaved
function EditorObjects.CreateGame(gameInfo)
    assert(gameInfo.Name and gameInfo.Name ~= "", "A name is required when creating games.");
    return CreateAndInitFromMixin(Game, gameInfo.Name, gameInfo.Authors, gameInfo.Version);
end