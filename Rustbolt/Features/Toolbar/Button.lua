RustboltToolbarButtonMixin = {};

function RustboltToolbarButtonMixin:OnLoad()
end

function RustboltToolbarButtonMixin:SetText(text)
    self.Text:SetTextToFit(text);
end