local apps = {
    "Google Chrome",
    "WezTerm",
    "Windsurf",
    "Microsoft Teams",
    "1Password",
    "Finder"
}

local function moveAppToSpace(appName, spaceIndex)
    local app = hs.application.find(appName)
    if not app then
        hs.alert.show("App not found: " .. appName)
        return
    end

    -- Focus app and make it full screen
    app:activate()
    hs.timer.doAfter(1, function()
        hs.eventtap.keyStroke({"cmd", "ctrl"}, "F") -- Toggle full screen

        hs.timer.doAfter(1, function()
            -- Move to the desired Space
            hs.spaces.moveWindowToSpace(app:mainWindow():id(), hs.spaces.allSpaces()[spaceIndex])
        end)
    end)
end

local function setupSpaces()
    -- Ensure there are enough spaces
    local allSpaces = hs.spaces.allSpaces()
    if #allSpaces < #apps + 1 then
        for i = 1, (#apps + 1) - #allSpaces do
            hs.spaces.addSpaceToDisplay(hs.screen.primaryScreen())
        end
    end

    -- Assign apps to spaces
    for i, appName in ipairs(apps) do
        hs.timer.doAfter(i * 2, function() -- Delay to ensure apps are ready
            moveAppToSpace(appName, i + 1) -- Desktop 1 reserved for general use
        end)
    end

    hs.alert.show("Spaces configured")
end

-- Launch all apps and then set up spaces
local function launchAndConfigureApps()
    for _, appName in ipairs(apps) do
        hs.application.launchOrFocus(appName)
    end

    hs.timer.doAfter(5, setupSpaces) -- Delay to allow apps to launch
end

-- Bind to a hotkey
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
    launchAndConfigureApps()
end)

hs.alert.show("Hammerspoon config loaded successfully!")
