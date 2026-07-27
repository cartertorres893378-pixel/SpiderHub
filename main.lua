-- Isolated Master Loader for SpiderHub Architecture
local success, moduleSource = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and moduleSource then
    if string.find(moduleSource, "404: Not Found") or string.len(moduleSource) < 10 then
        warn("[SpiderHub Error]: Invalid GitHub raw path direction or private repository limits.")
        return
    end

    local loader, compileError = loadstring(moduleSource)
    if loader then
        local status, executionError = pcall(function()
            local AdminUI = loader()
            if AdminUI and type(AdminUI) == "table" and AdminUI.CreateMenu then
                AdminUI.CreateMenu()
            else
                warn("[SpiderHub Error]: AdminUI file failed to export structural functions.")
            end
        end)
        if not status then
            warn("[SpiderHub Runtime Error]: " .. tostring(executionError))
        end
    else
        warn("[SpiderHub Compilation Error]: " .. tostring(compileError))
    end
else
    warn("[SpiderHub Network Error]: Target assets could not be resolved from external GitHub nodes.")
end
