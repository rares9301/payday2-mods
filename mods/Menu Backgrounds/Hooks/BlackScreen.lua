Hooks:PreHook(HUDBlackScreen, "fade_in_mid_text", "MenuBgsInit", function()
	if not MenuBackgrounds.Options:GetValue("Menus/blackscreen") then
		return
	end
	MenuBackgrounds:AddBackground("blackscreen", nil, 350)
end)

Hooks:PostHook(HUDBlackScreen, "fade_in_mid_text", "MenuBgsFadeIn", function(self)
	if MenuBackgrounds.Options:GetValue("FadeToBlack") then
		play_anim(MenuBackgrounds.MainPanel, {set = {alpha = 1}})
	else
		self._blackscreen_panel:child("mid_text"):stop()
		self._blackscreen_panel:child("mid_text"):set_alpha(1)
		self._blackscreen_panel:set_alpha(1)
		local job_panel = self._blackscreen_panel:child("job_panel")
		if alive(job_panel) then
			job_panel:set_alpha(1)
		end
	end
end)

Hooks:PostHook(HUDBlackScreen, "fade_out_mid_text", "MenuBgsFadeOut", function(self)
	play_anim(MenuBackgrounds.MainPanel, {set = {alpha = 0}, time = 1})
end)