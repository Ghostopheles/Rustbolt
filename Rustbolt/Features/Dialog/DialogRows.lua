local Enum = Rustbolt.Enum;
local RowType = Enum.DialogRowType;
local L = Rustbolt.Strings;

------------

RustboltDialogRowBaseMixin = {};

function RustboltDialogRowBaseMixin:OnLoad()
    self.RequiredIcon:SetScript("OnEnter", function() self:OnRequiredButtonEnter() end);
    self.RequiredIcon:SetScript("OnLeave", function() self:OnRequiredButtonLeave() end);
end

function RustboltDialogRowBaseMixin:SetTitle(text)
    self.Title:SetText(text);
end

function RustboltDialogRowBaseMixin:SetRequired(isRequired)
    self.Required = isRequired;
    self.RequiredIcon:SetShown(self.Required);
end

function RustboltDialogRowBaseMixin:IsRequired()
    return self.Required;
end

function RustboltDialogRowBaseMixin:Reset()
    self.Title:SetText("");
    self.Required = false;

    if self.OnReset then
        self:OnReset();
    end
end

function RustboltDialogRowBaseMixin:HasBeenModified()
    return self:GetData() ~= self.DefaultValue;
end

function RustboltDialogRowBaseMixin:OnRequiredButtonEnter()
    GameTooltip:SetOwner(self.RequiredIcon, "ANCHOR_TOPLEFT");
    GameTooltip:SetText(L.DIALOG_FIELD_REQUIRED_TOOLTIP, 1, 1, 1);
    GameTooltip:Show();
end

function RustboltDialogRowBaseMixin:OnRequiredButtonLeave()
    GameTooltip:Hide();
end

------------

RustboltDialogRowEditboxMixin = CreateFromMixins(RustboltDialogRowBaseMixin);

function RustboltDialogRowEditboxMixin:Init(title, required)
    self.RowType = RowType.Editbox;
    self.DefaultValue = "";

    self:SetTitle(title);
    self:SetRequired(required);
end

function RustboltDialogRowEditboxMixin:OnReset()
    self.Editbox:SetText(self.DefaultValue);
end

function RustboltDialogRowEditboxMixin:GetData()
    return self.Editbox:GetText();
end

------------

RustboltDialogRowCheckboxMixin = CreateFromMixins(RustboltDialogRowBaseMixin);

function RustboltDialogRowCheckboxMixin:Init(title, required)
    self.RowType = RowType.Checkbox;
    self.DefaultValue = false;

    self:SetTitle(title);
    self:SetRequired(required);
end

function RustboltDialogRowCheckboxMixin:OnReset()
    self.Checkbox:SetChecked(self.DefaultValue);
end

function RustboltDialogRowCheckboxMixin:GetData()
    return self.Checkbox:GetChecked();
end

------------
--- SCROLLBOX

------------

RustboltDialogRowScrollBoxMixin = CreateFromMixins(RustboltDialogRowBaseMixin);

---@diagnostic disable-next-line: duplicate-set-field
function RustboltDialogRowScrollBoxMixin:OnLoad()
    self.ScrollView = CreateScrollBoxListLinearView();

    --TODO: improve this in the future to support more types of data in the scrollbox
    local function Initializer(frame, data)
        frame:SetText(data);
    end
    self.ScrollView:SetElementInitializer("RustboltDialogScrollBoxElementTemplate", Initializer);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    -- readjust title
    self.Title:ClearAllPoints();
    self.Title:SetPoint("TOP");

    self.RequiredIcon:ClearAllPoints();
    self.RequiredIcon:SetPoint("LEFT", self.Title, "RIGHT", 5, 0);
end

function RustboltDialogRowScrollBoxMixin:Init(title, required)
    self.RowType = RowType.ScrollBox;
    self.DefaultValue = {};

    self:SetTitle(title);
    self:SetRequired(required);
end

function RustboltDialogRowScrollBoxMixin:OnReset()
    self.ScrollBox:ScrollToStart();
    self:ResetDataProvider();
end

function RustboltDialogRowScrollBoxMixin:GetData()
    local data = {};
    self.ScrollBox:ForEachFrame(function(frame)
        table.insert(data, frame:GetData());
    end);

    return data;
end

function RustboltDialogRowScrollBoxMixin:CheckDataProvider()
    if not self.DataProvider then
        self:ResetDataProvider();
    end
end

function RustboltDialogRowScrollBoxMixin:ResetDataProvider()
    self.DataProvider = CreateDataProvider();
    self.ScrollView:SetDataProvider(self.DataProvider);
end

function RustboltDialogRowScrollBoxMixin:AddEntry(data)
    self:CheckDataProvider();

    return self.DataProvider:Insert(data);
end

function RustboltDialogRowScrollBoxMixin:AddEntries(data)
    self:CheckDataProvider();

    self.DataProvider:InsertTable(data);
end