local Enum = Rustbolt.Enum;

local CONTROL_TYPE_TO_TEMPLATE = {
    [Enum.ReflectionEntryType.ENTRYBOX] = "RustboltEditorReflectionEntryEditBoxTemplate",
    [Enum.ReflectionEntryType.CHECKBOX] = "RustboltEditorReflectionEntryCheckboxTemplate",
    [Enum.ReflectionEntryType.ASSET] = "RustboltEditorReflectionEntryAssetTemplate"
};

local FRAME_POOLS = {};

local function ResetControl(frame)
    if frame.Reset then
        frame:Reset();
    end
end

do
    local frameType = "EditBox";
    local parent = nil;
    local template = CONTROL_TYPE_TO_TEMPLATE[Enum.ReflectionEntryType.ENTRYBOX];
    FRAME_POOLS[Enum.ReflectionEntryType.ENTRYBOX] = CreateFramePool(frameType, parent, template, ResetControl);
end

do
    local frameType = "CheckButton";
    local parent = nil;
    local template = CONTROL_TYPE_TO_TEMPLATE[Enum.ReflectionEntryType.CHECKBOX];
    FRAME_POOLS[Enum.ReflectionEntryType.CHECKBOX] = CreateFramePool(frameType, parent, template, ResetControl);
end

do
    local frameType = "Frame";
    local parent = nil;
    local template = CONTROL_TYPE_TO_TEMPLATE[Enum.ReflectionEntryType.ASSET];
    FRAME_POOLS[Enum.ReflectionEntryType.ASSET] = CreateFramePool(frameType, parent, template, ResetControl);
end

local function AcquireControl(parent, controlType)
    local f = FRAME_POOLS[controlType]:Acquire();
    f:SetParent(parent);
    return f;
end

------------

RustboltEditorReflectionHeaderMixin = {};

function RustboltEditorReflectionHeaderMixin:OnLoad()
end

function RustboltEditorReflectionHeaderMixin:OnMouseDown(button, down)
end

function RustboltEditorReflectionHeaderMixin:OnMouseUp(button)
end

function RustboltEditorReflectionHeaderMixin:OnClick(button)
end

function RustboltEditorReflectionHeaderMixin:Init(data)
    self:SetText(data.Text);
end

function RustboltEditorReflectionHeaderMixin:SetText(text)
    self.Text:SetText(text);
end

------------

RustboltEditorReflectionEntryEditBoxMixin = {};

function RustboltEditorReflectionEntryEditBoxMixin:OnLoad()
end

function RustboltEditorReflectionEntryEditBoxMixin:OnChar(char)
end

function RustboltEditorReflectionEntryEditBoxMixin:OnTabPressed()
end

function RustboltEditorReflectionEntryEditBoxMixin:OnEnterPressed()
end

function RustboltEditorReflectionEntryEditBoxMixin:Reset()
end

------------

RustboltEditorReflectionEntryCheckboxMixin = {};

function RustboltEditorReflectionEntryCheckboxMixin:OnLoad()
end

function RustboltEditorReflectionEntryCheckboxMixin:Reset()
end

------------

RustboltEditorReflectionEntryAssetMixin = {};

function RustboltEditorReflectionEntryAssetMixin:OnLoad()
end

function RustboltEditorReflectionEntryAssetMixin:Reset()
end

------------

---@class RustboltEditorReflectionEntryBoxData
---@field Amount number
---@field DefaultText string | number

---@class RustboltEditorReflectionEntryData
---@field ControlTitle string
---@field ControlType RustboltReflectionEntryType
---@field TooltipText string

RustboltEditorReflectionEntryMixin = {};

function RustboltEditorReflectionEntryMixin:OnLoad()
    self.ControlAnchors = {
        CreateAnchor("TOPLEFT", self.Text, "TOPRIGHT", 10, -2),
        CreateAnchor("BOTTOMRIGHT", self.Chevron, "BOTTOMLEFT", 0, -2)
    };

    -- text tooltip scripts
    self.Text:SetScript("OnEnter", function()
        self:OnTitleEnter();
    end);

    self.Text:SetScript("OnLeave", function()
        self:OnTitleLeave();
    end);
end

function RustboltEditorReflectionEntryMixin:OnTitleEnter()
    if self:HasTooltipText() then
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
        GameTooltip:SetText(self:GetTooltipText(), 1, 1, 1);
        GameTooltip:Show();
    end
end

function RustboltEditorReflectionEntryMixin:OnTitleLeave()
    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide();
    end
end

---@param data RustboltEditorReflectionEntryData
function RustboltEditorReflectionEntryMixin:Init(data)
    if self.ControlFrame then
        self.ControlFrame:Release();
    end

    self.ControlFrame = AcquireControl(self, data.ControlType);
    self:SetControlAnchors();

    self:SetTitle(data.ControlTitle);
    self:SetTooltipText(data.TooltipText);
end

function RustboltEditorReflectionEntryMixin:SetControlAnchors()
    local control = self.ControlFrame;
    if not control then
        return;
    end

    control:ClearAllPoints();
    for _, anchor in ipairs(self.ControlAnchors) do
        anchor:SetPoint(control);
    end
end

function RustboltEditorReflectionEntryMixin:SetTitle(title)
    self.Text:SetText(title);
end

function RustboltEditorReflectionEntryMixin:SetTooltipText(text)
    self.TooltipText = text;
end

function RustboltEditorReflectionEntryMixin:GetTooltipText()
    return self.TooltipText;
end

function RustboltEditorReflectionEntryMixin:HasTooltipText()
    return self.TooltipText ~= nil;
end

------------

--TODO: REMOVE AFTER TESTING

local function InsertTestData()
    local panel = Rustbolt.Reflection.GetWorldPanel();
    local data = {
        Template = "RustboltEditorReflectionEntryTemplate",
        ControlTitle = "Test",
        ControlType = Enum.ReflectionEntryType.ENTRYBOX,
        TooltipText = "Tooltip Text"
    };
    panel:AddEntry(data);
end

Rustbolt.EventRegistry:RegisterCallback(Rustbolt.Events.ADDON_LOADED, InsertTestData);