max_line_length = false;

exclude_files = {
	"Rustbolt/Libs",
	"Rustbolt/Types",
};

ignore = {
	 -- ignore globals prefixed with Rustbolt
	"11./^Rustbolt",

	-- ignore unused self
	"212/self",
};

std = "lua51"

globals = {
	"CreateScrollBoxListLinearView",
	"GetLocale",
	"TRANSMOGRIFY_FONT_COLOR",
	"C_FunctionContainers",
	"math",
	"CreateAnchor",
	"format",
	"assert",
	"getmetatable",
	"strmatch",
	"IsMouseButtonDown",
	"CreateDataProvider",
	"rawequal",
	"loadfile",
	"CreateAndInitFromMixin",
	"GetTickTime",
	"rawget",
	"CreateVector3D",
	"GridLayoutMixin",
	"LibStub",
	"SafePack",
	"debug",
	"newproxy",
	"tinsert",
	"CreateFromMixins",
	"floor",
	"ScrollUtil",
	"geterrorhandler",
	"ipairs",
	"RunNextFrame",
	"tonumber",
	"type",
	"CreateScrollBoxListGridView",
	"C_Timer",
	"CallErrorHandler",
	"CreateColor",
	"EventUtil",
	"hooksecurefunc",
	"UISpecialFrames",
	"string",
	"AnchorUtil",
	"MathUtil",
	"tostring",
	"pcall",
	"CreateTexturePool",
	"CreateFramePool",
	"EventTrace",
	"_G",
	"CallbackRegistryMixin",
	"ButtonFrameTemplate_HidePortrait",
	"rawset",
	"error",
	"print",
	"debugstack",
	"GAME_LOCALE",
	"CopyTable",
	"tInvert",
	"setmetatable",
	"pairs",
	"GameTooltip",
};
