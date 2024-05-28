local Events = Verity.Events;
local Registry = Verity.EventRegistry;

local MapManager = Verity.MapManager;
local AssetManager = Verity.AssetManager;
local Animations = Verity.AnimationManager;
local ThemeManager = Verity.ThemeManager;
local L = Verity.Strings;

local ASSET_PICKER_STRIDE = 4;
local ASSET_PICKER_BUTTON_SIZE = 64; -- 64x64;

------------

VerityAssetButtonMixin = {};

function VerityAssetButtonMixin:OnLoad()
    Registry:RegisterCallback(Events.ASSET_PICKER_ASSET_CHANGED, self.OnSelectedAssetChanged, self);
end

function VerityAssetButtonMixin:OnClick()
    VerityAssetPicker:SetSelectedAsset(self.Asset.Name);
end

function VerityAssetButtonMixin:Init(assetName)
    self:SetSize(ASSET_PICKER_BUTTON_SIZE, ASSET_PICKER_BUTTON_SIZE);

    self.Asset = AssetManager:GetAsset(assetName);
    self:SetTexture(self.Asset);
end

function VerityAssetButtonMixin:SetTexture(asset)
    asset:Apply(self.Texture);
end

function VerityAssetButtonMixin:OnSelectedAssetChanged(selected)
    if not self:IsShown() then
        return;
    end

    self.SelectedTexture:SetShown(selected == self.Asset.Name);
end

------------

VerityAssetPickerMixin = {};

function VerityAssetPickerMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Assets");

    self.AssetButtonTemplate = "VerityAssetButtonTemplate";

    self.DataProvider = CreateDataProvider();

    local stride = ASSET_PICKER_STRIDE;
    local topPadding = 0;
    local bottomPadding = 0;
    local leftPadding = 0;
    local rightPadding = 0;
    self.ScrollView = CreateScrollBoxListGridView(
        stride,
        topPadding,
        bottomPadding,
        leftPadding,
        rightPadding
    );

    self.ScrollView:SetDataProvider(self.DataProvider);
    self.ScrollView:SetPanExtent(ASSET_PICKER_BUTTON_SIZE);
    self.ScrollView:SetElementExtent(ASSET_PICKER_BUTTON_SIZE);

    local function Initializer(frame, data)
        frame:Init(data);
    end

    self.ScrollView:SetElementInitializer(self.AssetButtonTemplate, Initializer);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local anchorsWithScrollBar = {
        CreateAnchor("TOPLEFT", self, "TOPLEFT", 20, -30);
        CreateAnchor("BOTTOMRIGHT", self.ScrollBar, -13, 4),
    };

    local anchorsWithoutScrollBar = {
        anchorsWithScrollBar[1],
        CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 4);
    };

    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, anchorsWithScrollBar, anchorsWithoutScrollBar);
end

function VerityAssetPickerMixin:OnShow()
    if self.DataProvider:GetSize() == 0 then
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

    for assetName, _ in pairs(assets) do
        self.DataProvider:Insert(assetName);
    end
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