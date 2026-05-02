local function notify(title, text)
    hs.notify.new({ title = title, informativeText = text }):send()
end

local function runWs(args)
    local ws = os.getenv("HOME") .. "/bin/ws"
    hs.task.new(ws, function(exitCode, stdOut, stdErr)
        if exitCode ~= 0 then
            local message = stdErr
            if message == nil or message == "" then
                message = stdOut or ("ws exited " .. tostring(exitCode))
            end
            notify("Workspace command failed", message)
        end
    end, args):start()
end

hs.urlevent.bind("ws", function(_, params)
    local workspace = params["workspace"] or params["name"]
    local target = params["target"]
    local tab = params["tab"]

    if workspace == nil or workspace == "" then
        notify("Workspace URL missing workspace", "Use hammerspoon://ws?workspace=start&target=chrome")
        return
    end

    if target == "chrome" then
        runWs({ "chrome", workspace })
    elseif target == "ghostty" then
        local args = { "ghostty", workspace }
        if tab ~= nil and tab ~= "" then
            table.insert(args, tab)
        end
        runWs(args)
    elseif target == "ghostty-open" then
        runWs({ "ghostty-open", workspace })
    else
        notify("Workspace URL unknown target", tostring(target))
    end
end)
