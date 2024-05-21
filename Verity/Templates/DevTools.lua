VerityDevToolsMixin = {};

function VerityDevToolsMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Dev Tools");

    self.ScreenName:SetText("GAME");
    self.SwitchScreen:SetScript("OnClick", function() VerityGameWindow:SetScreen(self.ScreenName:GetText()); end);
    self.SwitchScreen:SetText("Set Screen");

    self.SelectedTile = nil;

    self.Dirt:SetText("Dirt");
    self.Dirt:SetScript("OnClick", function() self.SelectedTile = "Dirt" end);

    self.Grass:SetText("Grass");
    self.Grass:SetScript("OnClick", function() self.SelectedTile = "Grass" end);

    self.Water:SetText("Water");
    self.Water:SetScript("OnClick", function() self.SelectedTile = "Water" end);
end