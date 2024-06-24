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

------------

---@class RustboltSave
---@field Name string
---@field Timestamp number
---@field Campaign table
---@field Data table
local Save = {};

---Initializes a save using existing data or sets attributes to default
---@param name string
---@param data table
---@param campaign table
---@param timestamp? number
function Save:Init(name, data, campaign, timestamp)
    self.Name = name;
    self.Data = data;
    self.Campaign = campaign;
    self.Timestamp = timestamp or GetServerTime();
end

---@return RustboltSave
local function CreateSave(...)
    return CreateAndInitFromMixin(Save, ...);
end

------------

---@class RustboltCampaign
local Campaign = {};

---Initializes a campaign object from savedvars or creates a new one
---@param name string
---@param timestamp? number
---@param saves? table
---@param lastSaveName? string
function Campaign:Init(name, timestamp, saves, lastSaveName)
    self.Name = name;
    self.Timestamp = timestamp or GetServerTime();
    self.Saves = saves or {};
    self.LastSaveName = lastSaveName or L.CAMPAIGN_NEW_PH;
end

---Creates a new save in this campaign
---@param saveName string
---@param data table
function Campaign:NewSave(saveName, data)
    local save = CreateSave(saveName, data, self);
    tinsert(self.Saves, save);
    self.LastSaveName = saveName;

    --TODO: trim saves table over time, probably
end

---@return RustboltCampaign
local function CreateCampaign(...)
    return CreateAndInitFromMixin(Campaign, ...);
end

------------

---@class RustboltSavesManager
---@field Campaigns table<RustboltCampaign>
local SaveManager = {
    Campaigns = {},
};

---Creates a new campaign that can store game saves
---@param campaignName string
function SaveManager:NewCampaign(campaignName)
    local campaign = CreateCampaign(campaignName);
    tinsert(self.Campaigns, campaign);

    return campaign;
end

---Returns all stored campaigns
---@return table<RustboltCampaign>
function SaveManager:GetAllCampaigns()
    return self.Campaigns;
end

---Returns a stored campaign by name
---@param campaignName string
---@return RustboltCampaign?
function SaveManager:GetCampaignByName(campaignName)
    for _, campaign in pairs(self.Campaigns) do
        if campaign.Name == campaignName then
            return campaign;
        end
    end
end

---Returns if a campaign exists or not by name
---@param campaignName string
---@return boolean
function SaveManager:DoesCampaignExist(campaignName)
    return self:GetCampaignByName(campaignName) ~= nil;
end

------------

Rustbolt.SaveManager = SaveManager;