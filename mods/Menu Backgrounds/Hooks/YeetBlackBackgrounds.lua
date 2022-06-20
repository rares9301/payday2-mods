
local script = table.remove(RequiredScript:split("/"))

local function yeet(self)
	for _, child in pairs(self._fullscreen_panel:children()) do
		if (child:layer() == 1 and child.color and child:color() == Color(0.4, 0, 0, 0)) or (child.texture_name and child:texture_name() == Idstring("guis/textures/test_blur_df")) then
			child:hide()
		end
	end
end

if script == "blackmarketgui" then
    Hooks:PreHook(BlackMarketGui, "_setup", "MenuBackgroundsRemoveShittyAssBlur", function(self, is_start_page, component_data)
        self._data = component_data or self:_start_page_data()
        self._data.skip_blur = 0
    end)
elseif script == "infamytreegui" then
	Hooks:PostHook(InfamyTreeGui, "_setup", "YeetBlackScreen", yeet)
elseif script == "menuguicomponentgeneric" then
    function MenuGuiComponentGeneric:_blur_background() end
elseif script == "skilltreeguinew" then
	Hooks:PostHook(NewSkillTreeGui, "_setup", "YeetBlackScreen", yeet)
elseif script == "skilltreegui" then
	Hooks:PostHook(SkillTreeGui, "_setup", "YeetBlackScreen", yeet)
end