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

------------

---@class VeritySave
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

---@return VeritySave
local function CreateSave(...)
    return CreateAndInitFromMixin(Save, ...);
end

------------

---@class VerityCampaign
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

---@return VerityCampaign
local function CreateCampaign(...)
    return CreateAndInitFromMixin(Campaign, ...);
end

------------

---@class VeritySavesManager
---@field Campaigns table<VerityCampaign>
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
---@return table<VerityCampaign>
function SaveManager:GetAllCampaigns()
    return self.Campaigns;
end

---Returns a stored campaign by name
---@param campaignName string
---@return VerityCampaign?
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

Verity.SaveManager = SaveManager;