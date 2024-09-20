RustboltEditorReflectionEntryEditBoxMixin = {};

function RustboltEditorReflectionEntryEditBoxMixin:OnLoad()
end

function RustboltEditorReflectionEntryEditBoxMixin:OnChar(char)
end

function RustboltEditorReflectionEntryEditBoxMixin:OnTabPressed()
end

function RustboltEditorReflectionEntryEditBoxMixin:OnEntryPressed()
end

function RustboltEditorReflectionEntryEditBoxMixin:OnResetButtonPressed()
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

RustboltEditorReflectionEntryMixin = {};

function RustboltEditorReflectionEntryMixin:OnLoad()
end

function RustboltEditorReflectionEntryMixin:Init()
end