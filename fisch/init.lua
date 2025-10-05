-- ============================================
-- Fisch Script System
-- Standalone script for Fisch game
-- GitHub: https://github.com/Sezy0/robloxsc
-- ============================================

local Fisch = {}
Fisch.Version = "1.0.0"
Fisch.Modules = {}

-- GitHub Raw URL Base
local GITHUB_BASE = "https://raw.githubusercontent.com/Sezy0/robloxsc/main/fisch/"

-- Print banner
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  🎣 Fisch Script v" .. Fisch.Version)
print("  Loading modules...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Module loader
function Fisch:LoadModule(moduleName)
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
        return nil
    end
end

-- Load utils
function Fisch:LoadUtils()
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

-- Initialize
function Fisch:Init()
    print("\n[Fisch] Initializing...")
    
    -- Load utils
    self:LoadUtils()
    
    -- Load modules
    local modulesToLoad = {
        "teleport",
    }
    
    for _, moduleName in ipairs(modulesToLoad) do
        self:LoadModule(moduleName)
    end
    
    print("\n[Fisch] ✓ Initialization complete!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    
    return self
end

-- Get module
function Fisch:GetModule(moduleName)
    return self.Modules[moduleName]
end

-- Unload
function Fisch:Unload()
    print("[Fisch] Unloading...")
    for name, module in pairs(self.Modules) do
        if module.Unload then
            module:Unload()
        end
    end
    self.Modules = {}
    print("[Fisch] Unloaded!")
end

return Fisch
