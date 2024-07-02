local Constants = Rustbolt.Constants;

local InputManager = Rustbolt.InputManager;

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local GameEvents = Rustbolt.GameEvents;
local GameRegistry = Rustbolt.GameRegistry;

local Enum = Rustbolt.Enum;
local MapManager = Rustbolt.MapManager;

local AssetManager = Rustbolt.AssetManager;

local ObjectManager = Rustbolt.ObjectManager;

local Animations = Rustbolt.AnimationManager;
local ThemeManager = Rustbolt.ThemeManager;
local L = Rustbolt.Strings;

---@enum RustboltGameStatus
local GameStatus = {
    READY = 1,
    RUNNING = 2,
    PAUSED = 3,
    ENDED = 4,
    DEADGE = 5,
};

Rustbolt.GameStatus = GameStatus;

---@class RustboltGameState
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
    self.World = Rustbolt.World:NewWorld();
    self.World:SetMapID(mapID);
    self.World:ApplyWorldSettings(worldSettings);

    self:ApplyGameSettings(gameSettings);

    Rustbolt.Engine:LoadMap(mapID);

    self:SetStatus(GameStatus.READY);
end

---@param status RustboltGameStatus
function GameState:SetStatus(status)
    self.Status = status;
    GameRegistry:TriggerEvent(GameEvents.GAME_STATUS_CHANGED, self.Status);
end

---@return RustboltGameStatus status
function GameState:GetStatus()
    return self.Status;
end

---Applies game settings to the game state
---@param gameSettings table
function GameState:ApplyGameSettings(gameSettings)
    self.GameSettings = gameSettings;
end

---Returns the current world for the game state
---@return RustboltWorld
function GameState:GetWorld()
    return self.World;
end

function GameState:LoadGame(data)
    local character = self.World:CreateObject("PlayerCharacter", "Character");

    ---@cast character RustboltCharacterObject
    character:SetDoTick(true);
    character:SetInputEnabled(true);
    character:SetPosition(0, 0, 0);
    character:CreateSubObject("Mesh2D", "dragonriding_sgvigor_mask", 35, 35);
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
    Rustbolt.Engine:DispatchEvent("Tick", deltaTime);
end

--- called to begin the game loop
function GameState:Start()
    assert(self:GetStatus() == GameStatus.READY, "Attempt to begin game loop while game state is not ready");

    self:SetStatus(GameStatus.RUNNING);
    Rustbolt.Engine:DispatchEvent("BeginPlay");

    self:StartTicker();
end

function GameState:End()
    local status = self:GetStatus();
    assert(status == GameStatus.RUNNING or GameStatus.PAUSED, "Attempt to end a non-healthy game loop");

    self:SetStatus(GameStatus.ENDED);
    Rustbolt.Engine:DispatchEvent("EndPlay");

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

Rustbolt.GameState = GameState;