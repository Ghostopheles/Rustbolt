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
        Text = "Test",
        ButtonType = Rustbolt.Enum.ToolbarButtonType.DROPDOWN,
    });
end);