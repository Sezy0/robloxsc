-- ============================================
-- Dev Tools by Sezy
-- Modular Roblox Development Tools
-- GitHub: https://github.com/Sezy0/robloxsc
-- ============================================

local DevTools = {}
DevTools.Version = "1.0.0"
DevTools.Modules = {}

-- GitHub Raw URL Base
local GITHUB_BASE = "https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/"

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Print banner
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  Dev Tools by Sezy v" .. DevTools.Version)
print("  Loading modules...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Module loader with error handling
function DevTools:LoadModule(moduleName)
    local url = GITHUB_BASE .. "modules/" .. moduleName .. ".lua"
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and module then
        self.Modules[moduleName] = module
        print("[✓] Loaded: " .. moduleName)
        return module
    else
        warn("[✗] Failed to load: " .. moduleName)
        warn("    Error: " .. tostring(module))
        return nil
    end
end

-- Load utility functions
function DevTools:LoadUtils()
    local url = GITHUB_BASE .. "utils/helpers.lua"
    local success, utils = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and utils then
        self.Utils = utils
        print("[✓] Loaded: Utils")
        return utils
    else
        warn("[✗] Failed to load utils")
        return nil
    end
end

-- Initialize function
function DevTools:Init()
    print("\n[DevTools] Initializing...")
    
    -- Load utils first
    self:LoadUtils()
    
    -- Load all modules
    local modulesToLoad = {
        "select_object",
        "esp",
        "teleport",
        "ui_manager",
    }
    
    for _, moduleName in ipairs(modulesToLoad) do
        self:LoadModule(moduleName)
    end
    
    print("\n[DevTools] ✓ Initialization complete!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    
    return self
end

-- Get module
function DevTools:GetModule(moduleName)
    return self.Modules[moduleName]
end

-- Unload all modules
function DevTools:Unload()
    print("[DevTools] Unloading...")
    for name, module in pairs(self.Modules) do
        if module.Unload then
            module:Unload()
        end
    end
    self.Modules = {}
    print("[DevTools] Unloaded!")
end

return DevTools
