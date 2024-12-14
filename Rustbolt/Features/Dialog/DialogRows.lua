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
