local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;

------------

---@class RustboltGameManager
local GameManager = {
    Games = {},
};

function GameManager:OnAddonLoaded()
    -- init necessary savedvars here
    if not RustboltGames then
        RustboltGames = {};
    end

    -- load games from savedvars
    for _, gameInfo in ipairs(RustboltGames) do
        local game = Rustbolt.EditorObjects.CreateGame(gameInfo);
        if game then
            self:RegisterGame(game);
        end
    end
end

---@param game RustboltGame
function GameManager:SetActiveGame(game)
    self.ActiveGame = game;
    Registry:TriggerEvent(Events.ACTIVE_GAME_CHANGED, game);
end

---@return RustboltGame? activeGame
function GameManager:GetActiveGame()
    return self.ActiveGame;
end

---@return boolean hasActiveGame
function GameManager:HasActiveGame()
    return self:GetActiveGame() ~= nil;
end

---@param game RustboltGame
function GameManager:RegisterGame(game)
    local name = game:GetName();
    assert(not self.Games[name], "Registration failed. A game with that name already exists.");
    self.Games[name] = game;
end

---@param gameName string
---@return RustboltGame? game
function GameManager:GetGameByName(gameName)
    return self.Games[gameName];
end

---@param gameName string
---@return boolean success
function GameManager:LoadGameByName(gameName)
    local game = self:GetGameByName(gameName);
    if not game then
        return false;
    end

    self:SetActiveGame(game);
    return true;
end

---@param game RustboltGame
---@return boolean success
function GameManager:LoadGame(game)
    self:SetActiveGame(game);
    return true;
end

------------

Registry:RegisterCallback(Events.ADDON_LOADED, GameManager.OnAddonLoaded, GameManager);

Rustbolt.GameManager = GameManager;