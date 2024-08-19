local MAX_BUTTONS_PER_SIDE = 8;
local DEFAULT_TEXT = "$uwu$";

local BUTTON_SCRIPTS = {
    "OnClick",
    "OnEnter",
    "OnLeave"
};

RustboltToolbarMixin = {};

---@enum RustboltToolbarSide
Rustbolt.Enum.ToolbarSide = {
    LEFT = 1,
    RIGHT = 2
};
local SIDE = Rustbolt.Enum.ToolbarSide;

---@enum RustboltToolbarButtonType
Rustbolt.Enum.ToolbarButtonType = {
    BASE = 1,
    DROPDOWN = 2,
};
local BUTTON_TYPE = Rustbolt.Enum.ToolbarButtonType;

---@enum RustboltToolbarMenuOpenDirection
Rustbolt.Enum.ToolbarMenuOpenDirection = {
    UP = 1,
    DOWN = 2,
};
local MENU_OPEN_DIRECTION = Rustbolt.Enum.ToolbarMenuOpenDirection;

local BUTTON_TYPE_TEMPLATES = {
    [BUTTON_TYPE.BASE] = "RustboltToolbarButtonTemplate",
    [BUTTON_TYPE.DROPDOWN] = "RustboltToolbarDropdownButtonTemplate"
};

function RustboltToolbarMixin:OnLoad()
    self.Buttons = {
        [SIDE.LEFT] = {},
        [SIDE.RIGHT] = {},
    };

    local stride = MAX_BUTTONS_PER_SIDE;
    local paddingX = 0;
    local paddingY = 0;
    local horizontalSpacing = 4;
    local verticalSpacing = 0;

    self.Layouts = {
        [SIDE.LEFT] = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.LeftToRight, stride, paddingX, paddingY, horizontalSpacing, verticalSpacing),
        [SIDE.RIGHT] = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.RightToLeft, stride, paddingX, paddingY, horizontalSpacing, verticalSpacing),
    };

    self.InitialAnchors = {
        [SIDE.LEFT] = AnchorUtil.CreateAnchor("LEFT", self.ContainerLeft, "LEFT", 0, 0),
        [SIDE.RIGHT] = AnchorUtil.CreateAnchor("RIGHT", self.ContainerRight, "RIGHT", 0, 0),
    };

    local function ResetButton(_, button)
        for _, script in ipairs(BUTTON_SCRIPTS) do
            button:SetScript(script, nil);
        end
    end

    local function InitButton()
    end

    self.Pools = {
        [BUTTON_TYPE.BASE] ={
            [SIDE.LEFT] = CreateFramePool("Button", self.ContainerLeft, BUTTON_TYPE_TEMPLATES[BUTTON_TYPE.BASE], ResetButton, false, InitButton, MAX_BUTTONS_PER_SIDE),
            [SIDE.RIGHT] = CreateFramePool("Button", self.ContainerRight, BUTTON_TYPE_TEMPLATES[BUTTON_TYPE.BASE], ResetButton, false, InitButton, MAX_BUTTONS_PER_SIDE),
        },
        [BUTTON_TYPE.DROPDOWN] = {
            [SIDE.LEFT] = CreateFramePool("DropdownButton", self.ContainerLeft, BUTTON_TYPE_TEMPLATES[BUTTON_TYPE.DROPDOWN], ResetButton, false, InitButton, MAX_BUTTONS_PER_SIDE),
            [SIDE.RIGHT] = CreateFramePool("DropdownButton", self.ContainerRight, BUTTON_TYPE_TEMPLATES[BUTTON_TYPE.DROPDOWN], ResetButton, false, InitButton, MAX_BUTTONS_PER_SIDE),
        };
    };

    self.IDToButton = {};
end

function RustboltToolbarMixin:OnShow()
end

function RustboltToolbarMixin:OnHide()
end

------------

---@class RustboltToolbarMenuConfig
---@field Elements table
---@field OpenDirection? RustboltToolbarMenuOpenDirection
---@field Title? string

---@class RustboltToolbarButtonConfig
---@field Text string
---@field IconAtlas? string
---@field Side? RustboltToolbarSide
---@field ID? string
---@field OnClick? function
---@field OnEnter? function
---@field OnLeave? function
---@field ButtonType? RustboltToolbarButtonType
---@field MenuConfig? RustboltToolbarMenuConfig

---@param buttonConfig RustboltToolbarButtonConfig
function RustboltToolbarMixin:AddButton(buttonConfig)
    local side = buttonConfig.Side or SIDE.LEFT;
    local type = buttonConfig.ButtonType;
    local pool = self.Pools[type or BUTTON_TYPE.BASE];

    local button = pool[side]:Acquire();
    if not button then
        return false;
    end

    if button.Init then
        button:Init(buttonConfig);
    end

    for _, script in ipairs(BUTTON_SCRIPTS) do
        button:SetScript(script, buttonConfig[script]);
    end

    tinsert(self.Buttons[side], button);

    if buttonConfig.ID then
        self.IDToButton[buttonConfig.ID] = button;
    end

    self:Layout();
    return button;
end

function RustboltToolbarMixin:Layout()
    for side, layout in ipairs(self.Layouts) do
        local InitialAnchor = self.InitialAnchors[side];
        AnchorUtil.ChainLayout(self.Buttons[side], InitialAnchor, layout);
    end
end

function RustboltToolbarMixin:GetButtonByID(id)
    return self.IDToButton[id];
end