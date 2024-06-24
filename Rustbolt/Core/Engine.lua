local Constants = Rustbolt.Constants;

local InputManager = Rustbolt.InputManager;

local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local GameEvents = Rustbolt.GameEvents;
local GameRegistry = Rustbolt.GameRegistry;

local SaveManager = Rustbolt.SaveManager;

local L = Rustbolt.Strings;

---@class RustboltEngine
---@field ActiveCampaign? RustboltCampaign
local Engine = {};

--[[
the engine is going to be the CIA of our project, overseeing the interaction of all the different systems
    additionally, it'll connect our (non-game) UI to the game in a (hopefully) sane manner
]]

---Starts and activates a new campaign
---@param campaignName string
---@return RustboltCampaign?
function Engine:StartNewCampaign(campaignName)
    local campaign = SaveManager:NewCampaign(campaignName);
    self:SetActiveCampaign(campaign);
    return campaign;
end

---@param campaign RustboltCampaign
function Engine:SetActiveCampaign(campaign)
    if self.ActiveCampaign == campaign then
        return;
    end

    self.ActiveCampaign = campaign;
    GameRegistry:TriggerEvent(GameEvents.ACTIVE_CAMPAIGN_CHANGED);
end

---@return RustboltCampaign?
function Engine:GetActiveCampaign()
    return self.ActiveCampaign;
end

function Engine:GetGameState()
    return Rustbolt.GameState;
end

function Engine:LoadMap(mapID)
    RustboltGameWindow.GameCanvas:LoadMap(mapID);
end

function Engine:CreateTexture(...)
    local canvas = RustboltGameWindow.GameCanvas;
    return canvas:AddTexture(...);
end

function Engine:PositionObjectByWorldCoords(object, x, y, z)
    local canvas = RustboltGameWindow.GameCanvas;
    local scale = 10;
    local xOffset, yOffset = x * scale, y * scale;

    object:SetPoint("CENTER", canvas, "CENTER", xOffset, yOffset);
end

------------

Rustbolt.Engine = Engine;