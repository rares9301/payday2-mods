function MenuBackdropGUI:set_background(menu)
	if not MenuBackgrounds.Options:GetValue("Menus/"..menu) then
		return
	end
	for _, child in pairs(self._panel:children()) do
		child:hide()
		child:set_alpha(0)
	end
	self._panel:child("item_background_layer"):show()
	self._panel:child("item_background_layer"):set_alpha(1)
	self._panel:child("item_foreground_layer"):show()
	self._panel:child("item_foreground_layer"):set_alpha(1)
	MenuBackgrounds:ShowPanel()
	MenuBackgrounds:AddBackground(menu)
end

Hooks:PostHook(MenuBackdropGUI, "hide", "MenuBackgroundsHidePanel", function()
	MenuBackgrounds:HidePanel()
end)