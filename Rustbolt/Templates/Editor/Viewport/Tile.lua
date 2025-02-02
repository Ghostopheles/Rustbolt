RustboltEditorViewportTileMixin = {};

function RustboltEditorViewportTileMixin:OnLoad()
    self:SetMouseClickEnabled(false); -- because OnEnter enables mouse clicks for some reason
end

function RustboltEditorViewportTileMixin:OnEnter()
    local canvas = self:GetParent();
    canvas:OnTileEnter(self);
end

function RustboltEditorViewportTileMixin:OnLeave()
    local canvas = self:GetParent();
    canvas:OnTileLeave(self);
end