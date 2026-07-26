-- main.lua
print("[SpiderHub] Initializing Layout Modules...")

-- The repository link pointing to your UI source file on GitHub
local rawModuleUrl = "https://githubusercontent.com"

local success, response = pcall(function()
    return game:HttpGet(rawModuleUrl)
end)

if success then
    local compiledCode, err = loadstring(response)
    if compiledCode then
        local Module = compiledCode()
        Module.CreateMenu()
        print("[SpiderHub] UI compiled successfully onto client. Press ALT to toggle visibility.")
    else
        warn("[SpiderHub] Framework Compile Failed: " .. tostring(err))
    end
else
    warn("[SpiderHub] Communication failure during web asset sync.")
end
