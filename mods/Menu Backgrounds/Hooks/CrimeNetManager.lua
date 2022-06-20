Hooks:PostHook(CrimeNetGui, "init", "MenuBgsInit", function(self)
	if not MenuBackgrounds.Options:GetValue("Menus/crimenet") then
		return
	end
	MenuBackgrounds:ShowPanel()
	MenuBackgrounds:SetIgnoreOtherPanels(true)
	MenuBackgrounds:AddBackground("crimenet")
	self._fullscreen_panel:child("vignette"):hide()
	self._fullscreen_panel:child("bd_light"):hide()
	self._fullscreen_panel:child("blur_top"):hide()
	self._fullscreen_panel:child("blur_right"):hide()
	self._fullscreen_panel:child("blur_bottom"):hide()
	self._fullscreen_panel:child("blur_left"):hide()
	self._map_panel:child("map"):set_alpha(0)
	for _, child in pairs(self._panel:children()) do
		if CoreClass.type_name(child) == "Rect" and child:color() == tweak_data.screen_colors.crimenet_lines then
			child:hide()
		end
	end
end)

Hooks:PostHook(CrimeNetGui, "close", "MenuBgsClose", function(self)
	MenuBackgrounds:HidePanel()
	managers.menu_scene:SetBackground(true)
end)

Hooks:PostHook(CrimeNetGui, "_create_polylines", "MenuBgsRemovePolyLines", function(self, o, x, y)
	if not MenuBackgrounds.Options:GetValue("Menus/crimenet") then
		return
	end
	if self._region_panel then
		for _, child in pairs(self._region_panel:children()) do
			child:hide()
		end
	end
end)