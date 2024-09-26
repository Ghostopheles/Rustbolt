local Events = Rustbolt.Events;
local Registry = Rustbolt.EventRegistry;
local Enum = Rustbolt.Enum;

CONTROL_FRAME_POOL_COLLECTION = CreateFramePoolCollection();
local CONTROL_TYPE_TO_TEMPLATE = {
    [Enum.ReflectionEntryType.ENTRYBOX] = "RustboltEditorReflectionEntryEditBoxTemplate",
    [Enum.ReflectionEntryType.CHECKBOX] = "RustboltEditorReflectionEntryCheckboxTemplate",
    [Enum.ReflectionEntryType.ASSET] = "RustboltEditorReflectionEntryAssetTemplate"
};

local function ResetControl(frame)
    frame:Reset();
end

local function SetupFramePools()
    do
        local frameType = "EditBox";
        local parent = nil;
        local template = CONTROL_TYPE_TO_TEMPLATE[Enum.ReflectionEntryType.ENTRYBOX];
        local resetFunc = ResetControl;
        CONTROL_FRAME_POOL_COLLECTION:CreatePool(frameType, parent, template, resetFunc);
    end
end

Registry:RegisterCallback(Events.ADDON_LOADED, SetupFramePools);

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

    local template = CONTROL_TYPE_TO_TEMPLATE[data.ControlType];
    local pool = CONTROL_FRAME_POOL_COLLECTION:GetOrCreatePool(template);
    self.ControlFrame = pool:Acquire();

end