MenuBackgrounds.Menus = {
	 -- Copied from MenuSceneManagerVR
	"standard",
	"blackmarket",
	"blackmarket_mask",
	"infamy_preview",
	"blackmarket_item",
	"character_customization",
	"play_online",
	"options",
	"lobby",
	--"lobby1",
	--"lobby2",
	--"lobby3",
	--"lobby4",
	"inventory",
	"blackmarket_crafting",
	"blackmarket_weapon_color",
	"safe",
	"blackmarket_customize",
	"blackmarket_character",
	"blackmarket_customize_armour",
	"blackmarket_armor",
	"blackmarket_screenshot",
	"crime_spree_lobby",
	"crew_management",
	"blackmarket_item",
	"movie_theater",

	-- Custom
	"crimenet",
	"briefing",
	"blackscreen",
	"endscreen",
	"loot",
	"loading"
}

function MenuBackgrounds:Init()
	self.AssetsPath = Path:Combine(self.ModPath, "Assets")
	self.Sets = self.Sets or {}
	self.Updaters = {}

	MenuBackgrounds:LoadSets()
	MenuBackgrounds:LoadTextures()
end

function MenuBackgrounds:LoadSets()
	self.Sets = {}
	for _, set in pairs(FileIO:GetFolders(self.AssetsPath)) do
		table.insert(self.Sets, {path = Path:Combine(self.AssetsPath, set), name = set})
	end
	self:LoaSetsFromMods("assets/mod_overrides")
	self:LoaSetsFromMods("mods")
end

function MenuBackgrounds:LoaSetsFromMods(path)
	for _, mod in pairs(FileIO:GetFolders(path)) do
		local dir = Path:Combine(path, mod, "menu_backgrounds")
		if FileIO:Exists(dir) then
			for _, set in pairs(FileIO:GetFolders(dir)) do
				table.insert(self.Sets, {path = Path:Combine(dir, set), name = mod .. "/" .. set})
			end
		end
	end
end

local allowed = {
	png = true,
	dds = true,
	texture = true,
	tga = true,
	movie = true,
	bik = true
}

function MenuBackgrounds:LoadTextures()
	self._files = {}
	local saved_set = self.Options:GetValue("BGsSet")
	if saved_set ~= self._last_set then
		self._last = nil
	end
	self._last_set = saved_set

	local set_path
	for _, set in pairs(self.Sets) do
		if set.name == saved_set then
			set_path = set.path
		end
	end

	set_path = set_path or self.Sets[1].path
	
	local ids_strings = {}
	local config = FileIO:ReadScriptData(Path:Combine(set_path, "config.json"), "json")
	for _, file in pairs(FileIO:GetFiles(set_path)) do
		local ext, name = Path:GetFileExtension(file), Path:GetFilePathNoExt(file)
		if allowed[ext] then
			local path = Path:Combine(set_path, file)
			local in_path = "guis/textures/backgrounds/" .. name
			local in_ext = (ext == "movie" or ext == "bik") and "movie" or "texture"

			table.insert(ids_strings, Idstring(in_path))
			DB:create_entry(in_ext:id(), in_path:id(), path)
			self._files[name] = {in_path = in_path, in_ext = in_ext, path = path, ext = ext}
		end
	end

	if config then
		if config.overrides then
			for k, v in pairs(config.overrides) do
				if self._files[v] then
					self._files[k] = self._files[v]
				else
					self:Err("[config.json] Background named %s was not found, cannot add override backgrounds.", v)
				end
			end
		end
		self._fallback = NotNil(config.fallback, "standard")
	else
		self._fallback = "standard"
	end

	Application:reload_textures(ids_strings)
	if managers.menu_scene then
		managers.menu_scene:RefreshBackground()
	end
end

function MenuBackgrounds:AddUpdate(pnl, bg, layer)
	self.Updaters[bg] = {pnl = pnl, layer = layer}
end

function MenuBackgrounds:SetIgnoreOtherPanels(ignore)
	self._ignore_other_panel = ignore
end

function MenuBackgrounds:ShowPanel()
	self.MainPanel:set_visible(true)
	self._hidden = false
	if self._last and self._last.is_movie and alive(self._last.bg_mod) then
		self._last.bg_mod:set_volume_gain(self.Options:GetValue("Volume"))
	end
end

function MenuBackgrounds:HidePanel()
	self.MainPanel:set_visible(false)
	self:SetIgnoreOtherPanels(false)
	self._hidden = true
	if self._last and self._last.is_movie and alive(self._last.bg_mod) then
		self._last.bg_mod:set_volume_gain(0)
	end
end

local default = {in_path = "guis/textures/backgrounds/standard", ext = "png", in_ext = "texture"}

function MenuBackgrounds:GetBackgroundFile(bg)
	bg = self.Options:GetValue("UseStandard") and "standard" or bg
	if bg:begins("blackmarket") and not self._files[bg] then
		bg = "blackmarket_all"
	end

	local file_tbl = self._files[bg]
	if not file_tbl then
		if self._fallback then
			file_tbl = self._files[self._fallback]
		else
			return nil, nil, nil
		end
	end

	if not file_tbl then
		return nil, nil, nil
	end

	local file = file_tbl.in_path
	if not DB:has(file_tbl.in_ext:id(), file:id()) then
		file = default.in_path
	end
	return file, file_tbl.ext, file_tbl.in_ext
end

function MenuBackgrounds:AddBackground(bg, pnl, layer)
	if self._ignore_other_panel and pnl then
		return true
	end
	local orig_pnl = pnl
	if pnl and pnl:alive() then
		self.MainPanel:set_visible(false)
	elseif self.MainPanel and self.MainPanel:alive() then
		pnl = self.MainPanel
		self.MainPanel:set_visible(not self._hidden)
		self.MainPanel:set_alpha(1)
	else
		return false
	end

	local file, ext, in_ext = self:GetBackgroundFile(bg)

	if not file then
		return false
	end

	local is_movie = in_ext == "movie"
	local volume = not self._hidden and self.Options:GetValue("Volume") or 0
	if not self._reload and (self._last and self._last.is_movie and alive(self._last.bg_mod) and self._last.file == file) then
		self._last.bg_mod:set_volume_gain(volume)
		return true
	end

	if self._last and alive(self._last.bg_mod) then
		self._last.bg_mod:parent():remove(self._last.bg_mod)
	end

	if alive(pnl:child("bg_mod")) then
		pnl:remove(pnl:child("bg_mod"))
	end

	local bg_mod
	if is_movie then
		bg_mod = pnl:video({
			name = "bg_mod",
			w = 1920,
			h = 1080,
			video = file,
			loop = true,
			speed = self.Options:GetValue("Speed"),
			layer = layer or 1
		})
		bg_mod:set_volume_gain(volume)
	else
		bg_mod = pnl:bitmap({
		    name = "bg_mod",
		    texture = file,
			w = 1920,
			h = ext == "png" and 1920 or 1080, -- I have no idea why pngs act this way but they just do.
		    layer = layer or 1
		})
	end

	self._last = {file = file, pnl = pnl, bg_mod = bg_mod, is_movie = is_movie}

	self:AddUpdate(orig_pnl, bg, layer)
	return true
end

function MenuBackgrounds:UpdateSetsItem()
	local item = managers.menu and managers.menu:active_menu().logic:get_item("BGsSet")
	if item then
		item:clear_options()
		local saved_set = self.Options:GetValue("BGsSet")
		local found = false
		for _, set in pairs(self.Sets) do
			table.insert(item._all_options, CoreMenuItemOption.ItemOption:new({value = set.name, text_id = set.name, localize = false}))
			if set.name == saved_set then
				found = true
			end
		end
		item._options = item._all_options
		if found then
			item:set_value(saved_set)
		else
			item:set_value(self.Sets[1].name)
		end
	end
end

function MenuBackgrounds:UpdateWait()
	BeardLib:AddDelayedCall("StopSpammingMyEarsMenuBgs", 0.25, function()
		self:Update()
	end)
end

function MenuBackgrounds:ReloadWait()
	BeardLib:AddDelayedCall("StopSpammingMyEarsMenuBgs", 0.25, function()
		self:Reload()
	end)
end

function MenuBackgrounds:Reload()
	self._reload = true
	self:Update()
	self._reload = nil
end

function MenuBackgrounds:Update()
	self:LoadSets()
	self:UpdateSetsItem()
	self:LoadTextures()
	for bg, v in pairs(self.Updaters) do
		if not self:AddBackground(bg, v.pnl, v.layer) then
			table.delete(self.Updaters, bg)
		end
	end
end