VerityDevToolsMixin = {};

function VerityDevToolsMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("Dev Tools");

    self.ScreenName:SetText("GAME");
    self.SwitchScreen:SetScript("OnClick", function() VerityGameWindow:SetScreen(self.ScreenName:GetText()); end);
    self.SwitchScreen:SetText("Set Screen");

    self.Assets:SetText("Assets");
    self.Assets:SetScript("OnClick", function() VerityAssetPicker:Toggle(); end);
end