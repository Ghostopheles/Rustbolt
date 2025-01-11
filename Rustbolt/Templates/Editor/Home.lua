local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;
local Engine = Rustbolt.Engine;
local L = Rustbolt.Strings;

------------

RustboltEditorHomeMixin = {};

function RustboltEditorHomeMixin:OnLoad()
    Registry:RegisterCallback(Events.ADDON_LOADED, self.RegisterToolbarButtons, self);

    self.HorizontalResizeBar:SetTarget(self.ReflectionPanel, nil, Rustbolt.Enum.ResizeDirection.HORIZONTAL);
    self.VerticalResizeBar:SetTarget(self.BlueprintEditor, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end

function RustboltEditorHomeMixin:RegisterToolbarButtons()
    do
        local dialogConfig = {
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
                },
                {
                    RowType = Enum.DialogRowType.Checkbox,
                    Title = L.DIALOG_NEW_PROJECT_OPEN,
                    Tag = "OpenProject"
                },
            }
        };

        local function DialogCallback(results)
            local game = Rustbolt.EditorObjects.CreateGame({
                Name = results.Name,
                Authors = {results.AuthorName},
                Version = "0.0.1"
            });
            local open = results.OpenProject;
            Registry:TriggerEvent(Events.GAME_CREATED, game, open);
        end

        local function GenerateMenu(rootDescription)
            rootDescription:CreateButton("New project...", function()
                Rustbolt.Dialog.CreateAndShowDialog(dialogConfig, DialogCallback);
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
        Engine:AddAtticButton(buttonConfig);
    end
end