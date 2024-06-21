local Constants = Verity.Constants;

local InputManager = Verity.InputManager;

local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local GameEvents = Verity.GameEvents;
local GameRegistry = Verity.GameRegistry;

local Enum = Verity.Enum;
local MapManager = Verity.MapManager;

local AssetManager = Verity.AssetManager;

local ObjectManager = Verity.ObjectManager;

local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

---@enum VerityGameStatus
local GameStatus = {
    READY = 1,
    RUNNING = 2,
    PAUSED = 3,
    ENDED = 4,
    DEADGE = 5,
};

Verity.GameStatus = GameStatus;

---@class VerityGameState
local GameState = {};

--[[
what does the game state need to know in order to begin running the main loop?
    1. the map
    2. world settings (meta stuff like game speed, multiplayer, etc)
    3. game settings (difficulty, etc)
        note worldSettings live on GameState.World, game settings live on the GameState directly

after we've got the startup params, we can create our World instance and store that for anything that might
need it later

]]--  

---Initializer for our game state
---@param mapID number
---@param worldSettings table
---@param gameSettings table
function GameState:Init(mapID, worldSettings, gameSettings)
    self.World = Verity.World:NewWorld();
    self.World:SetMapID(mapID);
    self.World:ApplyWorldSettings(worldSettings);

    self:ApplyGameSettings(gameSettings);

    Verity.Engine:LoadMap(mapID);

    self:SetStatus(GameStatus.READY);
end

---@param status VerityGameStatus
function GameState:SetStatus(status)
    self.Status = status;
    GameRegistry:TriggerEvent(GameEvents.GAME_STATUS_CHANGED, self.Status);
end

---@return VerityGameStatus status
function GameState:GetStatus()
    return self.Status;
end

---Applies game settings to the game state
---@param gameSettings table
function GameState:ApplyGameSettings(gameSettings)
    self.GameSettings = gameSettings;
end

---Returns the current world for the game state
---@return VerityWorld
function GameState:GetWorld()
    return self.World;
end

function GameState:LoadSave(data)
    local character = self.World:CreateObject("PlayerCharacter", "Character");

    ---@cast character VerityCharacterObject
    character:SetDoTick(true);
    character:SetInputEnabled(true);
    character:SetPosition(32, 32, 1);
end

function GameState:StartTicker()
    self.Ticker = C_Timer.NewTicker(0, function() self:Tick(); end);
    return self.Ticker;
end

function GameState:StopTicker()
    self.Ticker:Cancel();
end

--- main game loop
function GameState:Tick()
    local deltaTime = GetTickTime();
    self.World:TickObjects(deltaTime);
end

--- called to begin the game loop
function GameState:Start()
    assert(self:GetStatus() == GameStatus.READY, "Attempt to begin game loop while game state is not ready");

    self:SetStatus(GameStatus.RUNNING);
    self.World:BeginPlay();

    self:StartTicker();
end

function GameState:End()
    local status = self:GetStatus();
    assert(status == GameStatus.RUNNING or GameStatus.PAUSED, "Attempt to end a non-healthy game loop");

    self:SetStatus(GameStatus.ENDED);
    self.World:EndPlay();

    self:StopTicker();
end

function GameState:Pause()
    assert(self:GetStatus() == GameStatus.RUNNING, "Attempt to pause a non-running game loop");

    self:SetStatus(GameStatus.PAUSED);
    self:StopTicker();
end

function GameState:Resume()
    assert(self:GetStatus() == GameStatus.PAUSED, "Attempt to resume a non-paused game loop");

    self:SetStatus(GameStatus.RUNNING);
    self:StartTicker();
end

------------

Verity.GameState = GameState;