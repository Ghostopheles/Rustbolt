local Constants = Verity.Constants;

local InputManager = Verity.InputManager;

local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local GameEvents = Verity.GameEvents;
local GameRegistry = Verity.GameRegistry;

local SaveManager = Verity.SaveManager;

local L = Verity.Strings;

---@class VerityEngine
---@field ActiveCampaign? VerityCampaign
local Engine = {};

--[[
the engine is going to be the CIA of our project, overseeing the interaction of all the different systems
    additionally, it'll connect our (non-game) UI to the game in a (hopefully) sane manner
]]

---Starts and activates a new campaign
---@param campaignName string
---@return VerityCampaign?
function Engine:StartNewCampaign(campaignName)
    local campaign = SaveManager:NewCampaign(campaignName);
    self:SetActiveCampaign(campaign);
    return campaign;
end

---@param campaign VerityCampaign
function Engine:SetActiveCampaign(campaign)
    if self.ActiveCampaign == campaign then
        return;
    end

    self.ActiveCampaign = campaign;
    GameRegistry:TriggerEvent(GameEvents.ACTIVE_CAMPAIGN_CHANGED);
end

---@return VerityCampaign?
function Engine:GetActiveCampaign()
    return self.ActiveCampaign;
end

------------

Verity.Engine = Engine;