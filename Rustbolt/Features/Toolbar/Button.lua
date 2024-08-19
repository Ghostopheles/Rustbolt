RustboltToolbarButtonMixin = {};

---@param data RustboltToolbarButtonConfig
function RustboltToolbarButtonMixin:Init(data)
    if data.Text then
        self:SetText(data.Text);
    end
end

function RustboltToolbarButtonMixin:OnLoad()
end

function RustboltToolbarButtonMixin:SetText(text)
    self.Text:SetTextToFit(text);
end