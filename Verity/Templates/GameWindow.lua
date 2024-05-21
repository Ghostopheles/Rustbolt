local L = Verity.Strings;

VerityGameWindowMixin = {};

function VerityGameWindowMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.GAME_WINDOW_TITLE);

    RunNextFrame(function() tinsert(UISpecialFrames, self:GetName()); end);
end

function VerityGameWindowMixin:Toggle()
    self:SetShown(not self:IsShown());
end