local Enum = Rustbolt.Enum;

local CONTROL_TYPE_TO_TEMPLATE = {
    [Enum.ReflectionEntryType.ENTRYBOX] = "RustboltEditorReflectionEntryEditBoxTemplate",
    [Enum.ReflectionEntryType.CHECKBOX] = "RustboltEditorReflectionEntryCheckboxTemplate",
    [Enum.ReflectionEntryType.ASSET] = "RustboltEditorReflectionEntryAssetTemplate"
};

local FRAME_POOLS = {};

local function ResetControl(frame)
    frame:Reset();
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

function RustboltEditorReflectionEntryEditBoxMixin:OnResetButtonPressed()
end

------------

RustboltEditorReflectionEntryCheckboxMixin = {};

function RustboltEditorReflectionEntryCheckboxMixin:OnLoad()
end

------------

RustboltEditorReflectionEntryAssetMixin = {};

function RustboltEditorReflectionEntryAssetMixin:OnLoad()
end

------------

---@class RustboltEditorReflectionEntryData
---@field ControlType RustboltReflectionEntryType

RustboltEditorReflectionEntryMixin = {};

function RustboltEditorReflectionEntryMixin:OnLoad()
end

---@param data RustboltEditorReflectionEntryData
function RustboltEditorReflectionEntryMixin:Init(data)
    if self.ControlFrame then
        self.ControlFrame:Release();
    end

    self.ControlFrame = AcquireControl(self, data.ControlType);
end