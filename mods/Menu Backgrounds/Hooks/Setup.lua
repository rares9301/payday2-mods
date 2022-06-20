Hooks:PreHook(Setup, "_start_loading_screen", "MenuBackgroundsInjectLoadingData", function()
    if MenuBackgrounds.Options:GetValue("Menus/loading") then
        if LoadingEnvironment then
            Hooks:PreHook(getmetatable(LoadingEnvironment), "start", "MenuBackgroundsInjectLoadingData", function(self, setup, load, data)
                local file, ext, in_ext = MenuBackgrounds:GetBackgroundFile("loading")
                if not file or in_ext == "movie" then
                    return
                end
                data.menu_bgs = {
                    file = file,
                    ext = ext
                }
            end)
        end
    end
end)