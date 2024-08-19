local BUTTON_TYPE = Rustbolt.Enum.ToolbarButtonType;
local MENU_OPEN_DIRECTION = Rustbolt.Enum.ToolbarMenuOpenDirection;

local function CreateAnchorForUpMenu(owner)
    return AnchorUtil.CreateAnchor("BOTTOMLEFT", owner, "TOPLEFT", 0, 0);
end

------------

RustboltToolbarDropdownButtonMixin = {};

---@param data RustboltToolbarButtonConfig
function RustboltToolbarDropdownButtonMixin:Init(data)
    self:SetText(data.Text);

    local cfg = data.MenuConfig;
    if not cfg then
        return;
    end

    local openDirection = cfg.OpenDirection or MENU_OPEN_DIRECTION.DOWN;
    if openDirection == MENU_OPEN_DIRECTION.UP then
        local anchor = CreateAnchorForUpMenu(self);
        self:SetMenuAnchor(anchor);
    end
end

function RustboltToolbarDropdownButtonMixin:OnLoad()
    self:SetupMenu(self.CreateToolbarMenu);
end

function RustboltToolbarDropdownButtonMixin:CreateToolbarMenu(rootDescription)
    rootDescription:CreateTitle(self.LabelText);
    rootDescription:CreateButton("Button", function(_)
        print("uwu");
    end);
end

function RustboltToolbarDropdownButtonMixin:SetText(text)
    self.LabelText = text;
    self.Text:SetText(text);
end

EventUtil.ContinueOnAddOnLoaded("Rustbolt", function()
    local BUTTONS = {
        "File",
        "Edit",
        "Selection",
        "View",
        "Go",
        "Run",
        "Terminal",
        "Help"
    };

    for _, name in ipairs(BUTTONS) do
        Rustbolt.Engine:AddAtticButton({
            Text = name,
            ButtonType = BUTTON_TYPE.DROPDOWN,
        });
        Rustbolt.Engine:AddBasementButton({
            Text = name,
            ButtonType = BUTTON_TYPE.DROPDOWN,
            MenuConfig = {
                Elements = {
                    "uwu"
                },
                OpenDirection = "UP"
            }
        });
    end
end);