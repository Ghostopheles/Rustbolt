local Enum = Rustbolt.Enum;
local RowType = Enum.DialogRowType;

------------

RustboltDialogRowBaseMixin = {};

function RustboltDialogRowBaseMixin:SetTitle(text)
    self.Title:SetText(text);
end

function RustboltDialogRowBaseMixin:SetRequired(isRequired)
    self.Required = isRequired;
end

function RustboltDialogRowBaseMixin:IsRequired()
    return self.Required;
end

function RustboltDialogRowBaseMixin:Reset()
    self.Title:SetText("");
    self.Required = false;
end

------------

RustboltDialogRowEditboxMixin = CreateFromMixins(RustboltDialogRowBaseMixin);

function RustboltDialogRowEditboxMixin:Init(title, required)
    self.RowType = RowType.Editbox;

    self:SetTitle(title);
    self:SetRequired(required);
end

------------

RustboltDialogRowCheckboxMixin = CreateFromMixins(RustboltDialogRowBaseMixin);

function RustboltDialogRowCheckboxMixin:Init(title, required)
    self.RowType = RowType.Checkbox;

    self:SetTitle(title);
    self:SetRequired(required);
end