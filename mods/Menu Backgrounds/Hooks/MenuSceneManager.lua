function MenuSceneManager:UpdateBackground()
	if self._camera_object then
		self._camera_object:set_fov(50 + math.min(0, self._fov_mod or 0))
	end
	local cam = managers.viewport:get_current_camera()
	if type(cam) == "boolean" then
		return
	end
	local w,h = 1920, 1080
	local a,b,c = cam:position() + Vector3(-0.5, 584, -h/2+0.5):rotate_with(cam:rotation()), Vector3(0, w, 0):rotate_with(cam:rotation()) , Vector3(0, 0, h):rotate_with(cam:rotation())
	if alive(self._background_ws) then
		self._background_ws:set_world(w,h,a,b,c)
	else
		self._background_ws = World:newgui():create_world_workspace(w,h,a,b,c)
		self._background_ws:set_billboard(Workspace.BILLBOARD_BOTH)
	end
	self:SetBackground()
end

Hooks:PostHook(MenuSceneManager, "_set_up_templates", "MenuBGsFixPlayerPosition", function(self)
--	self._scene_templates.blackmarket_customize_armour.character_pos = self._scene_templates.blackmarket_customize_armour.character_pos + Vector3(0, -300, 0)
	self._scene_templates.blackmarket_armor.character_pos = self._scene_templates.blackmarket_armor.character_pos + Vector3(-30, -300, 50)
end)

Hooks:PostHook(MenuSceneManager, "update", "MenuBGsUpdate", function(self)
	self:UpdateBackground()
end)

local logo = "units/menu/menu_scene/menu_logo"
function MenuSceneManager:SetUnwantedVisible(visible)
	local unwanted = {
		"units/menu/menu_scene/menu_cylinder",
		"units/menu/menu_scene/menu_smokecylinder1",
		"units/menu/menu_scene/menu_smokecylinder2",
		"units/menu/menu_scene/menu_smokecylinder3",
		"units/menu/menu_scene/menu_cylinder_pattern",
		"units/menu/menu_scene/menu_cylinder_pattern",
		logo,
		"units/pd2_dlc_shiny/menu_showcase/menu_showcase",
		"units/payday2_cash/safe_room/cash_int_safehouse_saferoom",
	}
	for _, unit in pairs(World:find_units_quick("all")) do 
		for _, unit_name in pairs(unwanted) do
			if unit:name() == unit_name:id() then
				unit:set_visible(visible and unit:name() ~= logo:id())
			end
		end
	end
	if visible then
		if self._shaker then
			self._shaker:stop_all()
		end
	else
		if managers.environment_controller._vp then
			managers.environment_controller._vp:vp():set_post_processor_effect("World", Idstring("bloom_combine_post_processor"), Idstring("bloom_combine_empty"))
		end
	end
	World:effect_manager():set_rendering_enabled(visible or Global.load_level)
	managers.environment_controller:set_default_color_grading("color_off", not MenuBackgrounds.Options:GetValue("ColorGrading"))
	managers.environment_controller:refresh_render_settings()
end

function MenuSceneManager:RefreshBackground()
	self._last_bg = nil
end

function MenuSceneManager:SetBackground(force)
	if self._last_bg == self._current_scene_template and not force then
		return
	end
	local panel = self._background_ws:panel():child("bg") or self._background_ws:panel():panel({
		name = "bg",
		layer = 2000000
	})
	self._last_bg = self._current_scene_template
	local enabled = MenuBackgrounds.Options:GetValue("Menus/"..self._last_bg)
	if enabled then
		local success = MenuBackgrounds:AddBackground(self._last_bg, panel)
		self:SetUnwantedVisible(not success)
	else
		self:SetUnwantedVisible(true)
		self._background_ws:panel():remove(panel)
	end
end