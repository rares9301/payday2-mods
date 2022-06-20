Hooks:PostHook(IngameWaitingForPlayersState, "sync_start", "MenuBGsRemoveFade", function(self)
	if not MenuBackgrounds.Options:GetValue("FadeToBlack") and MenuBackgrounds.Options:GetValue("Menus/blackscreen") and MenuBackgrounds.Options:GetValue("Menus/briefing")  then
		if self._intro_event then
			self._delay_audio_t = 0
		else
			self._delay_start_t = 0
		end
	end
end)

Hooks:PostHook(HUDMissionBriefing, "show", "MenuBGsInit", function(self)
	if not MenuBackgrounds.Options:GetValue("Menus/briefing") then
		return
	end
	self._backdrop:set_background("briefing")
	if alive(self._background_layer_two) and alive(self._background_layer_two:child("panel")) then
		self._background_layer_two:child("panel"):hide()
	end
end)