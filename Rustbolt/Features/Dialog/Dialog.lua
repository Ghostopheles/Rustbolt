local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;
local L = Rustbolt.Strings;

------------

local DEFAULT_ROW_TEMPLATE = "RustboltDialogRowTemplate_"; -- specialization is added in ElementFactory:GetRow

local RowTypeToName = tInvert(Enum.DialogRowType);

local function ResetRow(_, row)
    row:Reset();
end

local FramePools = {};

local function InitFramePools()
    -- initialize pools
    for rowType, _ in pairs(Enum.DialogRowType) do
        local frameType = "Frame";
        local parent = RustboltDialog;
        local template = DEFAULT_ROW_TEMPLATE .. rowType;
        local resetFunc = ResetRow;
        local pool = CreateFramePool(frameType, parent, template, resetFunc);
        FramePools[rowType] = pool;
    end
end

Registry:RegisterCallback(Events.ADDON_LOADED, InitFramePools);

---@class RustboltDialogElementFactory
local ElementFactory = {};

function ElementFactory:GetPoolForRowType(rowType)
    local name = RowTypeToName[rowType];
    return FramePools[name];
end

---@param rowType RustboltDialogRowType
function ElementFactory:CreateRow(rowType)
    local pool = self:GetPoolForRowType(rowType);
    return pool:Acquire();
end

function ElementFactory:Release(row)
    local pool = self:GetPoolForRowType(row.RowType);
    pool:Release(row);
end

------------

---@class RustboltDialogField
---@field RowType RustboltDialogRowType
---@field Title string
---@field Required boolean?

---@class RustboltDialogStructure
---@field Title string
---@field Fields RustboltDialogField[]
---@field SubmitText string?
---@field Tag string?

RustboltDialogMixin = {};

function RustboltDialogMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self.SubmitButton:SetText(L.DIALOG_SUBMIT_TEXT);
    self.SubmitButton:SetScript("OnClick", function() self:OnSubmit() end);

    self.InitialAnchor = CreateAnchor("TOP", self, "TOP", 0, -20);

    local direction = GridLayoutMixin.Direction.BottomToTop; -- inverted because ???
    local stride = 5;
    local paddingX, paddingY = 0, 0;
    self.GridLayout = AnchorUtil.CreateGridLayout(direction, stride, paddingX, paddingY);

    self.Rows = {};
end

function RustboltDialogMixin:OnShow()
    Registry:TriggerEvent(Events.DIALOG_SHOWN, self:GetTag());
end

function RustboltDialogMixin:OnHide()
    Registry:TriggerEvent(Events.DIALOG_HIDDEN, self:GetTag());
end

function RustboltDialogMixin:OnSubmit()
    local data = {};
    for i, row in ipairs(self.Rows) do
        local rowData = row:GetData();
        tinsert(data, i, rowData);
    end

    self.Callback(data);
end

function RustboltDialogMixin:Layout()
    AnchorUtil.GridLayout(self.Rows, self.InitialAnchor, self.GridLayout);
end

function RustboltDialogMixin:Reset()
    for _, row in pairs(self.Rows) do
        row:Release();
    end
    wipe(self.Rows);
end

function RustboltDialogMixin:SetTag(tag)
    self.Tag = tag;
end

function RustboltDialogMixin:GetTag()
    return self.Tag;
end

---@param dialogStructure RustboltDialogStructure
---@param callback function
function RustboltDialogMixin:CreateAndShow(dialogStructure, callback)
    self:Reset();

    self:SetTitle(dialogStructure.Title);
    for _, rowInfo in ipairs(dialogStructure.Fields) do
        local row = ElementFactory:CreateRow(rowInfo.RowType);
        row:Init(rowInfo.Title, rowInfo.Required);
        tinsert(self.Rows, row);
    end

    self.SubmitButton:SetText(dialogStructure.SubmitText or "Submit");
    self.Callback = callback;
    self:SetTag(dialogStructure.Tag);

    self:Layout();
    self:Show();
end

------------

---@class RustboltDialog
local Dialog = {};

function Dialog.CreateAndShowDialog(dialogStructure, callback)
    local dialog = RustboltDialog;
    dialog:CreateAndShow(dialogStructure, callback);
end

Rustbolt.Dialog = Dialog;

------------

--[[
function ExampleDialog()
    local dialog = {
        Title = "uwu",
        Tag = "TEST_DIALOG",
        Fields = {
            {
                RowType = Enum.DialogRowType.Editbox,
                Title = "owo",
                Required = true,
            },
            {
                RowType = Enum.DialogRowType.Checkbox,
                Title = "check deez",
            }
        },
        SubmitText = "bark"
    };
    RustboltDialog:CreateAndShow(dialog);
end
]]--