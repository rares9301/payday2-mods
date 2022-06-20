core:module("CoreGuiDataManager")

Hooks:PostHook(GuiDataManager, "_setup_workspace_data", "Setup1080pData", function(self)
	local res = RenderSettings.resolution
    local w, h = 1920, 1080
	local sh = math.min(res.y, res.x / (w / h))
	local sw = math.min(res.x, res.y * w / h)
	local x = res.x / 2 - sh * w / h / 2
	local y = res.y / 2 - sw / (w / h) / 2

    self._fullrect_1080p_data = {}
    self._fullrect_1080p_data.w = w
	self._fullrect_1080p_data.h = h
	self._fullrect_1080p_data.width = self._fullrect_1080p_data.w
	self._fullrect_1080p_data.height = self._fullrect_1080p_data.h
	self._fullrect_1080p_data.x = x
	self._fullrect_1080p_data.y = y
	self._fullrect_1080p_data.on_screen_width = sw
	self._fullrect_1080p_data.convert_x = math.floor((self._fullrect_1080p_data.w - self._saferect_data.w) / 2)
	self._fullrect_1080p_data.convert_y = (self._fullrect_1080p_data.h - self._saferect_data.h) / 2
end)

function GuiDataManager:create_fullscreen_1080p_workspace(workspace_object, scene)
	local ws = (scene or self._scene_gui or Overlay:gui()):create_scaled_screen_workspace(10, 10, 10, 10, 10)
	self._workspace_configuration[ws:key()] = {
		workspace_object = workspace_object
	}

	self:_set_layout(ws, self._fullrect_1080p_data)

	return ws
end
