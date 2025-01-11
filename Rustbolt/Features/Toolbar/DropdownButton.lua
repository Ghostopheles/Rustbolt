local MENU_OPEN_DIRECTION = Rustbolt.Enum.ToolbarMenuOpenDirection;

local function CreateAnchorForUpMenu(owner)
    return AnchorUtil.CreateAnchor("BOTTOMLEFT", owner, "TOPLEFT", 0, 0);
end

------------

RustboltToolbarDropdownButtonMixin = {};

--- see Toolbar.lua for typedefs

---@param data RustboltToolbarButtonConfig
function RustboltToolbarDropdownButtonMixin:Init(data)
    self:SetText(data.Text);

    local cfg = data.MenuConfig;
    if not cfg then
        return;
    end

    self.MenuConfig = cfg;

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
    if not self.MenuConfig then
        return;
    end

    local title = self.MenuConfig.Title;
    if title and strtrim(title) ~= "" then
        rootDescription:CreateTitle(title);
    end

    if self.MenuConfig.Generator then
        self.MenuConfig.Generator(rootDescription);
    end
end

function RustboltToolbarDropdownButtonMixin:SetText(text)
    self.Text:SetText(text);
end