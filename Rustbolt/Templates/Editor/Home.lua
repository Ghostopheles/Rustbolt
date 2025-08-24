local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;
local Editor = Rustbolt.Editor;
local L = Rustbolt.Strings;
local EditorConstants = Rustbolt.Constants.Editor;

------------

RustboltEditorHomeMixin = {};

function RustboltEditorHomeMixin:OnLoad()
    Registry:RegisterCallback(Events.ADDON_LOADED, self.RegisterToolbarButtons, self);

    self.HorizontalResizeBar:SetTarget(self.ReflectionPanel, nil, Rustbolt.Enum.ResizeDirection.HORIZONTAL);
    self.VerticalResizeBar:SetTarget(self.Viewport, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end

function RustboltEditorHomeMixin:RegisterToolbarButtons()
    do -- FILE BUTTON
        local newProjectDialogConfig = {
            Title = L.DIALOG_NEW_PROJECT_TITLE,
            Tag = "NEW_PROJECT_DIALOG",
            Fields = {
                {
                    RowType = Enum.DialogRowType.Editbox,
                    Title = L.DIALOG_NEW_PROJECT_NAME,
                    Required = true,
                    Tag = "Name"
                },
                {
                    RowType = Enum.DialogRowType.Editbox,
                    Title = L.DIALOG_NEW_PROJECT_AUTHOR,
                    Required = true,
                    Tag = "AuthorName"
                }
            }
        };

        local function NewProjectDialogCallback(results)
            Editor:NewGame(results.Name, {results.AuthorName}, EditorConstants.DefaultGameVersion);
        end

        local loadProjectDialogConfig = {
            Title = L.DIALOG_LOAD_PROJECT_TITLE,
            Tag = "LOAD_PROJECT_DIALOG",
            Fields = {
                {
                    RowType = Enum.DialogRowType.ScrollBox,
                    Title = L.DIALOG_LOAD_PROJECT_SCROLLBOX_NAME,
                    Required = true,
                    Tag = "ProjectName",
                    ScrollBoxDataFunc = Editor.GetAllSavedGamesByName
                }
            }
        };

        local function LoadProjectDialogCallback(results)
            Editor:LoadGameByName(results.ProjectName);
        end

        local function GenerateMenu(rootDescription)
            rootDescription:CreateButton(L.TOOLBAR_FILE_NEW_PROJECT, function()
                Rustbolt.Dialog.CreateAndShowDialog(newProjectDialogConfig, NewProjectDialogCallback);
            end);
            rootDescription:CreateButton(L.TOOLBAR_FILE_LOAD_PROJECT, function()
                Rustbolt.Dialog.CreateAndShowDialog(loadProjectDialogConfig, LoadProjectDialogCallback);
            end);
            rootDescription:CreateButton(L.TOOLBAR_FILE_SAVE_PROJECT, function()
                Editor:SaveProject();
            end);
        end

        local name = L.TOOLBAR_TITLE_FILE;
        local buttonConfig = {
            Text = name,
            ID = "Toolbar_" .. name,
            ButtonType = Rustbolt.Enum.ToolbarButtonType.DROPDOWN,
            MenuConfig = {
                Generator = GenerateMenu
            }
        };
        Editor:AddAtticButton(buttonConfig);
    end

    do -- EDIT BUTTON
        local function GenerateMenu(rootDescription)
            local newObjectSubmenu = rootDescription:CreateButton(L.TOOLBAR_EDIT_NEW);
            --TODO: generate this list of buttons dynamically based on the available objects to create
            newObjectSubmenu:CreateButton(L.TOOLBAR_EDIT_NEW_WORLD, function()
                local dialogConfig = {
                    Title = L.DIALOG_NEW_WORLD_TITLE,
                    Tag = "NEW_WORLD_DIALOG",
                    Fields = {
                        {
                            RowType = Enum.DialogRowType.Editbox,
                            Title = L.DIALOG_NEW_WORLD_NAME,
                            Required = true,
                            Tag = "Name"
                        },
                        {
                            RowType = Enum.DialogRowType.Editbox,
                            Title = L.DIALOG_NEW_WORLD_ID,
                            Required = true,
                            Tag = "ID"
                        },
                    }
                };

                local function DialogCallback(results)
                    local game = Editor:GetActiveGame();
                    if not game then
                        print("no active game")
                        return;
                    end

                    local world = Rustbolt.ObjectManager:CreateObject("World", results.Name, results.ID);
                    game:AddWorld(world);  -- triggers the event to load the world if it's the first one
                end

                Rustbolt.Dialog.CreateAndShowDialog(dialogConfig, DialogCallback);
            end);
        end

        local name = L.TOOLBAR_TITLE_EDIT;
        local buttonConfig = {
            Text = name,
            ID = "Toolbar_" .. name,
            ButtonType = Rustbolt.Enum.ToolbarButtonType.DROPDOWN,
            MenuConfig = {
                Generator = GenerateMenu
            }
        };
        Editor:AddAtticButton(buttonConfig);
    end
end