Hooks:PostHook(MenuManager, "init", "InitBGsPanel", function()
    MenuBackgrounds.MainWs = managers.gui_data:create_fullscreen_1080p_workspace()
    MenuBackgrounds.MainPanel = MenuBackgrounds.MainWs:panel():panel()

	for _, menu in pairs(MenuBackgrounds.Menus) do
		local pretty = string.pretty(menu)
		local text = pretty
		if pretty:upper() ~= menu:upper() then
			text = string.format("%s (%s)", text, menu)
		end
		LocalizationManager:add_localized_strings({
			["MenuBgs_"..menu.."TitleID"] = pretty,
			["MenuBgs_"..menu.."DescID"] = string.format(managers.localization:text("MenuBgs_MenuDesc"), text)
		})
	end
end)

Hooks:PostHook(MenuManager, "_node_selected", "MenuBackgroundsNodeSelected", function(this, name, node)
	if node and node:parameters().name == "MenuBgs_OptionsNode" then
		MenuBackgrounds:UpdateSetsItem()
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenusMenuBackgrounds", function(this, nodes)
	World:effect_manager():set_rendering_enabled(Global.load_level)
end)

local plt = MenuComponentManager.play_transition
function MenuComponentManager:play_transition(...)
	if MenuBackgrounds.Options:GetValue("FadeToBlack") then
		plt(self, ...)
	end
end