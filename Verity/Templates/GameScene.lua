local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local GameEvents = Verity.GameEvents;
local GameRegistry = Verity.GameRegistry;

local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

VerityGameSceneMixin = {};

function VerityGameSceneMixin:OnLoad()
    self.Background:SetColorTexture(0, 0, 0);
end

function VerityGameSceneMixin:OnShow()
    local actor = self:CreateActor();
    actor:SetPosition(0, 0, 0);
    actor:SetModelByFileID(0);
end

function VerityGameSceneMixin:OnHide()
end