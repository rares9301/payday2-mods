local script = LevelLoadingScreenGuiScript or LightLoadingScreenGuiScript
local init = script.init

function script:init(scene_gui, res, progress, base_layer, ...)
    init(self, scene_gui, res, progress, base_layer, ...)

    local arg = arg
    if MenuBackgrounds and not arg then
        if not MenuBackgrounds.Options:GetValue("Menus/loading") then
            return
        end
        local file, ext, in_ext = MenuBackgrounds:GetBackgroundFile("loading")
        if not file or in_ext == "movie" then -- Movies are not supported in loading screens :(
            return
        end
        arg = {
            menu_bgs = {
                volume = MenuBackgrounds.Options:GetValue("Volume"),
                file = file,
                ext = ext
            }
        }
    end

    if arg and arg.menu_bgs then
        if self._back_drop_gui then
            self._back_drop_gui._panel:child("particles_layer"):hide()
            self._back_drop_gui._panel:child("light_layer"):hide()
            self._back_drop_gui._panel:set_layer(base_layer - 2.5)
        end
        local w, h = 1920, 1080
        local sh = math.min(res.y, res.x / (w / h))
        local sw = math.min(res.x, res.y * w / h)

        self._bg_ws = scene_gui:create_scaled_screen_workspace(10, 10, 10, 10, 10)
        self._bg_ws:set_screen(w, h, res.x / 2 - sh * w / h / 2, res.y / 2 - sw / (w / h) / 2, sw)
        self._bg_panel = self._bg_ws:panel():panel()

        if self._bg_gui and self._bg_gui:alive() then
            self._bg_gui:hide()
        end

        self._bg_panel:bitmap({
            name = "bg_mod",
            w = 1920,
            h = arg.menu_bgs.ext == "png" and 1920 or 1080,
            texture = arg.menu_bgs.file,
            layer = base_layer - 1
        })
    end
end

local destroy = script.destroy
function script:destroy(...)
    if self._bg_ws and self._bg_ws:alive() then
		self._scene_gui:destroy_workspace(self._bg_ws)
		self._bg_ws = nil
        self._bg_panel = nil
	end

    destroy(self, ...)
end

local set_visible = script.set_visible
function script:set_visible(visible, ...)
    if self._bg_ws then
        if visible then
            self._bg_ws:show()
        else
            self._bg_ws:hide()
        end
    end
    set_visible(self, visible, ...)
end