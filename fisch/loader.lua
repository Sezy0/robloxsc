-- ============================================
-- Fisch Script - Main Loader
-- Load Fisch UI with NextUI
-- ============================================

-- Load NextUI
local NextUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/LIBui/main/nextjs_mobile_compact/init.lua"))()

-- Auth (bypass)
NextUI:Auth({
    UseKeySystem = false,
    OnSuccess = function()
        print("[Fisch] Authenticated!")
    end
})

task.wait(0.1)

-- Load Fisch system
local Fisch = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/fisch/init.lua"))()
Fisch:Init()

-- Create Window
local Window = NextUI:Window({
    Title = "Fisch Script v" .. Fisch.Version
})

-- Get modules
local TeleportModule = Fisch:GetModule("teleport")

-- ============================================
-- MAIN TAB
-- ============================================
local MainTab = Window:Tab("Main")

local InfoSection = MainTab:Section("Information")
InfoSection:Label("🎣 Fisch Script by Sezy")
InfoSection:Label("Version: " .. Fisch.Version)
InfoSection:Label("")
InfoSection:Label("Status: Active ✅")

-- ============================================
-- TELEPORT TAB
-- ============================================
local TeleportTab = Window:Tab("Teleport")

local TeleportSection = TeleportTab:Section("Locations")

if TeleportModule then
    local locations = TeleportModule:GetAll()
    
    if #locations == 0 then
        TeleportSection:Label("⚠️ No locations yet")
        TeleportSection:Label("Will be added soon!")
    else
        for _, location in ipairs(locations) do
            TeleportSection:Button(location.name, function()
                TeleportModule:Teleport(location.name)
            end)
        end
    end
else
    TeleportSection:Label("⚠️ Module not loaded")
end

-- ============================================
-- SETTINGS TAB
-- ============================================
local SettingsTab = Window:Tab("Settings")

local InfoSection2 = SettingsTab:Section("Information")
InfoSection2:Label("Script: Fisch by Sezy")
InfoSection2:Label("Version: " .. Fisch.Version)

local ActionsSection = SettingsTab:Section("Actions")
ActionsSection:Button("Unload Script", function()
    Fisch:Unload()
    NextUI:Notification("Unloaded", "Script unloaded", 2)
end)

print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎣 Fisch Script - Ready!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
