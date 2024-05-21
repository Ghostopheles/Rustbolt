local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local MapManager = Verity.MapManager;
local AssetManager = Verity.AssetManager;
local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

local ASSET_PICKER_STRIDE = 3;
local ASSET_PICKER_BUTTON_SIZE = 64; -- 64x64;

------------

VerityAssetButtonMixin = {};

function VerityAssetButtonMixin:OnLoad()
    Registry:RegisterCallback(Events.ASSET_PICKER_ASSET_CHANGED, self.OnSelectedAssetChanged, self);
end

function VerityAssetButtonMixin:OnClick()
    local parent = self:GetParent();
    parent:SetSelectedAsset(self.Asset);
end

function VerityAssetButtonMixin:Init(assetName, assetPath)
    self:ClearAllPoints();
    self:SetSize(ASSET_PICKER_BUTTON_SIZE, ASSET_PICKER_BUTTON_SIZE);

    self.Asset = assetName;
    assetPath = assetPath or AssetManager:GetAssetPath(assetName);
    self:SetTexture(assetPath);
end

function VerityAssetButtonMixin:Reset(self)
    self.Asset = nil;
end

function VerityAssetButtonMixin:SetTexture(texture)
    self.Texture:SetTexture(texture);
end

function VerityAssetButtonMixin:OnSelectedAssetChanged(selected)
    if not self:IsShown() then
        return;
    end

    self.SelectedTexture:SetShown(selected == self.Asset);
end

------------

VerityAssetPickerMixin = {};

function VerityAssetPickerMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Assets");

    self.AssetButtonPool = CreateFramePool("Button", self, "VerityAssetButtonTemplate", VerityAssetButtonMixin.Reset);
    self.AssetButtonPool:SetResetDisallowedIfNew(true);
end

function VerityAssetPickerMixin:OnShow()
    if self.AssetButtonPool:GetNumActive() == 0 then
        self:PopulateAssets();
    end
end

function VerityAssetPickerMixin:OnMouseDown()
    self:StartMoving();
end

function VerityAssetPickerMixin:OnMouseUp()
    self:StopMovingOrSizing();
end

function VerityAssetPickerMixin:PopulateAssets()
    local assets = AssetManager:GetAllAssets();

    local buttons = {};
    for assetName, assetPath in pairs(assets) do
        local button = self.AssetButtonPool:Acquire();
        button:Init(assetName, assetPath);

        tinsert(buttons, button);
    end

    local spacing = ASSET_PICKER_BUTTON_SIZE + 20;
    local layout = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.TopLeftToBottomRight, ASSET_PICKER_STRIDE, nil, nil, spacing, spacing);

    local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 20, -35);
    AnchorUtil.GridLayout(buttons, initialAnchor, layout);
end

function VerityAssetPickerMixin:SetSelectedAsset(assetName)
    self.SelectedAsset = assetName;
    Registry:TriggerEvent(Events.ASSET_PICKER_ASSET_CHANGED, self.SelectedAsset);
end

function VerityAssetPickerMixin:GetSelectedAsset()
    return self.SelectedAsset;
end

function VerityAssetPickerMixin:Toggle()
    self:SetShown(not self:IsShown());
end