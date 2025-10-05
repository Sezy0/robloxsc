-- ============================================
-- Fisch Script by Sezy
-- Game: Fisch (Fishing Game)
-- Version: 1.0.0
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  🎣 Fisch Script by Sezy")
print("  Version: 1.0.0")
print("  Loading...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Load Dev Tools
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/init.lua"))()
DevTools:Init()

-- Get modules
local UIManager = DevTools:GetModule("ui_manager")
local Teleport = DevTools:GetModule("teleport")
local Fly = DevTools:GetModule("fly")
local Commands = DevTools:GetModule("commands")

-- Quick setup UI
local Window = UIManager:QuickSetup("Fisch Script v1.0")

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Teleport Locations (Empty for now - akan diisi nanti)
local TeleportLocations = {
    -- Format: {name = "Location Name", position = Vector3.new(x, y, z)}
    -- Example:
    -- {name = "Spawn", position = Vector3.new(0, 10, 0)},
    -- {name = "Shop", position = Vector3.new(50, 5, 100)},
}

-- ============================================
-- MAIN TAB
-- ============================================
local MainTab = Window:Tab("Main", "🏠")

local InfoSection = MainTab:Section("ℹ️ Information")
InfoSection:Label("🎣 Fisch Script by Sezy")
InfoSection:Label("Game: Fisch (Fishing)")
InfoSection:Label("")
InfoSection:Label("Status: Active ✅")
InfoSection:Label("Version: 1.0.0")

local QuickSection = MainTab:Section("⚡ Quick Actions")
QuickSection:Button("Show Position", function()
    Commands:ShowPositionPanel()
    UIManager:Notify("Position", "Opening display...", 1.5)
end)

QuickSection:Button("Show Commands", function()
    print("\n━━━━━━━━━ AVAILABLE COMMANDS ━━━━━━━━━")
    print("  .fly - Toggle fly mode")
    print("  .speed 50 - Set walk speed")
    print("  .pos - Show position display")
    print("  .help - Show all commands")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    UIManager:Notify("Commands", "Check console for list", 2)
end)

-- ============================================
-- TELEPORT TAB
-- ============================================
local TeleportTab = Window:Tab("Teleport", "📍")

local TeleportSection = TeleportTab:Section("📍 Locations")

-- Check if locations are available
if #TeleportLocations == 0 then
    TeleportSection:Label("⚠️ No teleport locations yet")
    TeleportSection:Label("")
    TeleportSection:Label("Locations will be added soon!")
    TeleportSection:Label("")
    TeleportSection:Label("💡 Tip: Use Position Display")
    TeleportSection:Label("to find coordinates of locations")
else
    -- Add teleport buttons for each location
    for i, location in ipairs(TeleportLocations) do
        TeleportSection:Button(location.name, function()
            local success = Teleport:ToPosition(location.position)
            if success then
                UIManager:Notify("Teleported", "→ " .. location.name, 1.5)
            else
                UIManager:Notify("Failed", "Teleport failed!", 1.5)
            end
        end)
    end
end

-- Manual teleport section
local ManualSection = TeleportTab:Section("🎯 Manual Teleport")
ManualSection:Label("Use Position Display to get coords")
ManualSection:Label("Then use command:")
ManualSection:Label(".tp x y z")

-- ============================================
-- PLAYER TAB
-- ============================================
local PlayerTab = Window:Tab("Player", "🏃")

local MovementSection = PlayerTab:Section("✈️ Movement")
MovementSection:Toggle("Enable Fly", false, function(state)
    Fly:Toggle(state)
    if state then
        UIManager:Notify("Fly", "Enabled! WASD to move", 2)
    else
        UIManager:Notify("Fly", "Disabled", 1.5)
    end
end)

MovementSection:Button("Fly Speed: 25", function()
    Fly:SetSpeed(25)
    UIManager:Notify("Fly Speed", "Set to 25", 1.5)
end)

MovementSection:Button("Fly Speed: 50", function()
    Fly:SetSpeed(50)
    UIManager:Notify("Fly Speed", "Set to 50", 1.5)
end)

MovementSection:Button("Fly Speed: 100", function()
    Fly:SetSpeed(100)
    UIManager:Notify("Fly Speed", "Set to 100", 1.5)
end)

local SpeedSection = PlayerTab:Section("🏃 Walk Speed")
SpeedSection:Button("Speed: 16 (Normal)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            UIManager:Notify("Speed", "Normal (16)", 1.5)
        end
    end
end)

SpeedSection:Button("Speed: 50 (Fast)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
            UIManager:Notify("Speed", "Fast (50)", 1.5)
        end
    end
end)

SpeedSection:Button("Speed: 100 (Very Fast)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
            UIManager:Notify("Speed", "Very Fast (100)", 1.5)
        end
    end
end)

local PowerSection = PlayerTab:Section("🛡️ Powers")
PowerSection:Toggle("God Mode", false, function(state)
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if state then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                UIManager:Notify("God Mode", "Enabled!", 1.5)
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
                UIManager:Notify("God Mode", "Disabled", 1.5)
            end
        end
    end
end)

-- ============================================
-- FISHING TAB (Game-specific features)
-- ============================================
local FishingTab = Window:Tab("Fishing", "🎣")

local FishSection = FishingTab:Section("🎣 Fishing Features")
FishSection:Label("⚠️ Coming Soon!")
FishSection:Label("")
FishSection:Label("Features in development:")
FishSection:Label("• Auto Fish")
FishSection:Label("• Auto Sell")
FishSection:Label("• Fish ESP")
FishSection:Label("• Best Spot Finder")

-- ============================================
-- SETTINGS TAB
-- ============================================
local SettingsTab = Window:Tab("Settings", "⚙️")

local InfoSection2 = SettingsTab:Section("ℹ️ Information")
InfoSection2:Label("Script: Fisch by Sezy")
InfoSection2:Label("Version: 1.0.0")
InfoSection2:Label("Game: Fisch")
InfoSection2:Label("")
InfoSection2:Label("GitHub: Sezy0/robloxsc")

local FeatureSection = SettingsTab:Section("✨ Features")
FeatureSection:Label("✅ Teleport System (Empty)")
FeatureSection:Label("✅ Fly & Speed Control")
FeatureSection:Label("✅ God Mode")
FeatureSection:Label("✅ Position Display")
FeatureSection:Label("✅ Command System (.help)")
FeatureSection:Label("")
FeatureSection:Label("⏳ Auto Fishing (Coming Soon)")
FeatureSection:Label("⏳ Auto Sell (Coming Soon)")

local ActionsSection = SettingsTab:Section("🔧 Actions")
ActionsSection:Button("Unload Script", function()
    DevTools:Unload()
    UIManager:Notify("Unloaded", "Script unloaded", 2)
    task.wait(1)
    if Window then
        pcall(function()
            Window:Destroy()
        end)
    end
end)

-- ============================================
-- COMPLETION
-- ============================================
print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎣 Fisch Script - Ready!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  Features:
  • 📍 Teleport System (Menu ready)
  • ✈️  Fly & Movement Controls
  • 🏃 Speed Controls
  • 🛡️  God Mode
  • 💬 Command System
  
  💡 Quick Start:
  • Use Position Display to find coords
  • Type .help for commands
  • Check Teleport tab (empty for now)
  
  🎣 Fishing features coming soon!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
