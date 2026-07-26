-- main.lua
print("[SpiderHub] Fetching UI Framework from cloud...")

-- The link to your public raw AdminUI source file
local rawModuleUrl = "https://githubusercontent.com"

local success, response = pcall(function()
    return game:HttpGet(rawModuleUrl)
end)

if success then
    -- Convert the downloaded text string into executable code
    local compiledCode, err = loadstring(response)
    if compiledCode then
        task.spawn(compiledCode)
        print("[SpiderHub] Bootloader complete.")
    else
        warn("[SpiderHub] Framework Compile Failed: " .. tostring(err))
    end
else
    warn("[SpiderHub] Communication failure during web asset sync.")
end
