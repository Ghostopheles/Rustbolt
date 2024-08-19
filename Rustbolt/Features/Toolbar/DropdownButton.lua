RustboltToolbarDropdownButtonMixin = {};

function RustboltToolbarDropdownButtonMixin:OnLoad()
    Ghost.AddToDevTool(self);

    self:SetText("UwU");

    self:SetupMenu(self.CreateToolbarMenu);
end

function RustboltToolbarDropdownButtonMixin:CreateToolbarMenu(rootDescription)
    rootDescription:CreateTitle("Title");
    rootDescription:CreateButton("Button", function(_)
        print("uwu");
    end);
end

EventUtil.ContinueOnAddOnLoaded("Rustbolt", function()
    Rustbolt.Engine:AddAtticButton({
        Side = Rustbolt.Enum.ToolbarSide.LEFT,
        IsDropdown = true,
    });
end);