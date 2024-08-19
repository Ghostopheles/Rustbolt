RustboltReflectionPanelMixin = {};

function RustboltReflectionPanelMixin:OnLoad()
    self.ResizeBar:SetTarget(self.World, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end