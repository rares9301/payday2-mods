Hooks:PostHook(HUDLootScreen, "show", "MenuBGsShow", function(self)
	if MenuBackgrounds.Options:GetValue("Menus/loot") and alive(self._video) then
		self._backdrop:set_background("loot")
		self._video:hide()
		if not MenuBackgrounds.Options:GetValue("FadeToBlack") then
			for _, child in pairs(self._foreground_layer_full:children())  do
				if child:layer() == 10000 then
					child:hide()
				end
			end
		end
	end
end)