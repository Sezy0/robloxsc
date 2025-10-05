-- ============================================
-- Dev Tools by Sezy - Example Usage
-- Shows how to use dev tools with UI
-- ============================================

-- Load Dev Tools
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/loader.lua"))()

-- Get UI Manager
local UIManager = DevTools:GetModule("ui_manager")

-- Quick setup UI (auth + create window)
local Window = UIManager:QuickSetup("Dev Tools v2.0")

-- Get other modules
local SelectObject = DevTools:GetModule("select_object")
local Teleport = DevTools:GetModule("teleport")
local ESP = DevTools:GetModule("esp")
local Fly = DevTools:GetModule("fly")
local Commands = DevTools:GetModule("commands")

-- Create tabs
local MainTab = Window:Tab("Main", "🏠")
local PlayerTab = Window:Tab("Player", "🏃")
local ToolsTab = Window:Tab("Tools", "🔧")
local SettingsTab = Window:Tab("Settings", "⚙️")

-- Main Tab
local MainSection = MainTab:Section("Welcome")
MainSection:Label("Dev Tools by Sezy v2.0")
MainSection:Label("Modular development toolkit")
MainSection:Label("")
MainSection:Label("💬 Commands: Type .help in chat")
MainSection:Label("Prefix: . (dot)")
MainSection:Button("Show All Commands", function()
    print("\n━━━━━━━━━ AVAILABLE COMMANDS ━━━━━━━━━")
    print("  .help - Show all commands")
    print("  .fly - Toggle fly mode")
    print("  .flyspeed 100 - Set fly speed")
    print("  .speed 50 - Set walk speed")
    print("  .jump 100 - Set jump power")
    print("  .tp PlayerName - Teleport to player")
    print("  .god - Toggle god mode")
    print("  .noclip - Toggle noclip")
    print("  .clear - Clear console")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    UIManager:Notify("Commands", "Check console for list", 2)
end)

-- Player Tab
local FlySection = PlayerTab:Section("✈️ Fly")
local flySpeed = 50

FlySection:Toggle("Enable Fly", false, function(state)
    Fly:Toggle(state)
    if state then
        UIManager:Notify("Fly", "Enabled! WASD to move", 2)
    else
        UIManager:Notify("Fly", "Disabled", 1.5)
    end
end)

FlySection:Button("Speed: 25 (Slow)", function()
    flySpeed = 25
    Fly:SetSpeed(flySpeed)
    UIManager:Notify("Fly Speed", "Set to 25", 1.5)
end)

FlySection:Button("Speed: 50 (Normal)", function()
    flySpeed = 50
    Fly:SetSpeed(flySpeed)
    UIManager:Notify("Fly Speed", "Set to 50", 1.5)
end)

FlySection:Button("Speed: 100 (Fast)", function()
    flySpeed = 100
    Fly:SetSpeed(flySpeed)
    UIManager:Notify("Fly Speed", "Set to 100", 1.5)
end)

FlySection:Button("Speed: 200 (Super Fast)", function()
    flySpeed = 200
    Fly:SetSpeed(flySpeed)
    UIManager:Notify("Fly Speed", "Set to 200!", 1.5)
end)

local PlayerSection = PlayerTab:Section("🏃 Player")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

PlayerSection:Button("Walk Speed: 16 (Normal)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            UIManager:Notify("Speed", "Normal (16)", 1.5)
        end
    end
end)

PlayerSection:Button("Walk Speed: 50 (Fast)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
            UIManager:Notify("Speed", "Fast (50)", 1.5)
        end
    end
end)

PlayerSection:Button("Walk Speed: 100 (Very Fast)", function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
            UIManager:Notify("Speed", "Very Fast (100)", 1.5)
        end
    end
end)

PlayerSection:Toggle("God Mode", false, function(state)
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

-- Tools Tab
local SelectSection = ToolsTab:Section("Object Selection")
SelectSection:Toggle("Enable Selection", false, function(state)
    SelectObject:Toggle(state)
end)
SelectSection:Button("Delete Selected", function()
    SelectObject:DeleteSelected()
    UIManager:Notify("Deleted", "Object removed", 1.5)
end)
SelectSection:Button("Clone Selected", function()
    SelectObject:CloneSelected()
    UIManager:Notify("Cloned", "Object duplicated", 1.5)
end)
SelectSection:Button("Print Properties", function()
    local props = SelectObject:GetProperties()
    if props then
        print("━━━━━━━━━ OBJECT PROPERTIES ━━━━━━━━━")
        for key, value in pairs(props) do
            print(key .. " = " .. tostring(value))
        end
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        UIManager:Notify("Properties", "Check console output", 2)
    end
end)

local TeleportSection = ToolsTab:Section("Teleportation")
TeleportSection:Button("Teleport to Spawn", function()
    local success = Teleport:ToPosition(Vector3.new(0, 10, 0))
    if success then
        UIManager:Notify("Teleported", "Moved to spawn", 1.5)
    end
end)

local ESPSection = ToolsTab:Section("ESP")
ESPSection:Toggle("Enable ESP", false, function(state)
    ESP:Toggle(state)
end)

-- Settings Tab
local InfoSection = SettingsTab:Section("Information")
InfoSection:Label("Version: 2.0.0")
InfoSection:Label("Author: Sezy")
InfoSection:Label("GitHub: Sezy0/robloxsc")
InfoSection:Label("")
InfoSection:Label("Features:")
InfoSection:Label("• Fly system with adjustable speed")
InfoSection:Label("• Command system (.help)")
InfoSection:Label("• Object selection with ESP")
InfoSection:Label("• Teleportation tools")

local ActionsSection = SettingsTab:Section("Actions")
ActionsSection:Button("Unload All Modules", function()
    DevTools:Unload()
    UIManager:Notify("Unloaded", "All modules unloaded", 2)
end)

print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Dev Tools by Sezy v2.0 - Ready!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  ✨ NEW Features:
  • ✈️  Fly system (Tab: Player)
  • 💬 Command system (Type: .help)
  • 📦 Object selection with ESP
  • 🚀 Speed controls
  • 🛡️  God mode
  
  💡 Quick Start:
  • Type .fly in chat to start flying!
  • Type .help for all commands
  • Check Player tab for controls
  
  Press tabs to explore!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
