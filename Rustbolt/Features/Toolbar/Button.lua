RustboltBasementButtonMixin = {};

function RustboltBasementButtonMixin:OnLoad()
end

function RustboltBasementButtonMixin:SetText(text)
    self.Text:SetTextToFit(text);
end