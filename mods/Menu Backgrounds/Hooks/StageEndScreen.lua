Hooks:PostHook(HUDStageEndScreen, "show", "MenuBGsInit", function(self)
	self._backdrop:set_background("endscreen")
end)

function HUDStageEndScreen:spawn_animation() self:_wait_for_video() end

function HUDStageEndScreen:_wait_for_video()
	if not MenuBackgrounds.Options:GetValue("Menus/endscreen") then
		return
	end
	local video = self._background_layer_full:child("money_video")
	video:parent():remove(video)
end
