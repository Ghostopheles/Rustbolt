local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;

local MapManager = Rustbolt.MapManager;
local AssetManager = Rustbolt.AssetManager;
local Animations = Rustbolt.AnimationManager;
local ThemeManager = Rustbolt.ThemeManager;
local L = Rustbolt.Strings;

local ASSET_PICKER_STRIDE = 4;
local ASSET_PICKER_BUTTON_SIZE = 64; -- 64x64;

------------

RustboltAssetButtonMixin = {};

function RustboltAssetButtonMixin:OnLoad()
    Registry:RegisterCallback(Events.ASSET_PICKER_ASSET_CHANGED, self.OnSelectedAssetChanged, self);
end

function RustboltAssetButtonMixin:OnClick()
    RustboltAssetPicker:SetSelectedAsset(self.Asset.Name);
end

function RustboltAssetButtonMixin:Init(assetName)
    self:SetSize(ASSET_PICKER_BUTTON_SIZE, ASSET_PICKER_BUTTON_SIZE);

    self.Asset = AssetManager:GetAsset(assetName);
    self:SetTexture(self.Asset);
end

function RustboltAssetButtonMixin:SetTexture(asset)
    asset:Apply(self.Texture);
end

function RustboltAssetButtonMixin:OnSelectedAssetChanged(selected)
    if not self:IsShown() then
        return;
    end

    self.SelectedTexture:SetShown(selected == self.Asset.Name);
end

------------

RustboltAssetPickerMixin = {};

function RustboltAssetPickerMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Assets");

    self.AssetButtonTemplate = "RustboltAssetButtonTemplate";

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

function RustboltAssetPickerMixin:OnShow()
    if self.DataProvider:GetSize() == 0 then
        self:PopulateAssets();
    end
end

function RustboltAssetPickerMixin:OnMouseDown()
    self:StartMoving();
end

function RustboltAssetPickerMixin:OnMouseUp()
    self:StopMovingOrSizing();
end

function RustboltAssetPickerMixin:PopulateAssets()
    local assets = AssetManager:GetAllAssets();

    for assetName, _ in pairs(assets) do
        self.DataProvider:Insert(assetName);
    end
end

function RustboltAssetPickerMixin:SetSelectedAsset(assetName)
    self.SelectedAsset = assetName;
    Registry:TriggerEvent(Events.ASSET_PICKER_ASSET_CHANGED, self.SelectedAsset);
end

function RustboltAssetPickerMixin:GetSelectedAsset()
    return self.SelectedAsset;
end

function RustboltAssetPickerMixin:Toggle()
    self:SetShown(not self:IsShown());
end