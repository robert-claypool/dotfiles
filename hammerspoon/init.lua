-- List of applications to launch and set to fullscreen.
-- To have the apps appear in the desired left-to-right order in Mission Control,
-- they must be listed in reverse order here since macOS inserts fullscreen
-- Spaces adjacent to "Desktop 1".
local apps = {
    "Finder",
    "Leapp",
    "1Password",
    "Microsoft Teams",
    "Windsurf",
    "WezTerm",
    "Google Chrome"
}

-- Launches an app and sets it to fullscreen.
-- appName: Name of the app to launch.
-- index: The position of the app in the list (used for logging).
-- callback: Function to call after processing the current app (used for sequential execution).
local function launchAndFullscreenApp(appName, index, callback)
    hs.alert.show("Launching " .. appName)
    hs.application.launchOrFocus(appName)

    -- Wait for the app to launch and create its main window.
    hs.timer.doAfter(3, function()
        local app = hs.application.get(appName)
        if app then
            local win = app:mainWindow()
            if win then
                -- Set the window to fullscreen mode, creating a new Space.
                win:setFullscreen(true)
                hs.alert.show("Set " .. appName .. " to fullscreen in Space " .. index)
            else
                hs.alert.show("No main window found for " .. appName)
            end
        else
            hs.alert.show("App not found: " .. appName)
        end

        -- Proceed to the next app after a short delay to ensure proper sequencing.
        if callback then
            hs.timer.doAfter(2, callback)
        end
    end)
end

-- Launches all apps sequentially.
-- index: The current position in the apps list.
local function launchAppsSequentially(index)
    if index > #apps then
        hs.alert.show("All apps launched and set to fullscreen")
        return
    end

    local appName = apps[index]
    launchAndFullscreenApp(appName, index, function()
        launchAppsSequentially(index + 1)
    end)
end

-- Binds the launching function to the hotkey Cmd + Alt + Ctrl + S.
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
    hs.alert.show("Starting app launch and fullscreen process")
    launchAppsSequentially(1)
end)

hs.alert.show("Hammerspoon config loaded successfully!")
