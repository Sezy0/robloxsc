-- ============================================
-- Dev Tools by Sezy - Example Usage
-- Shows how to use dev tools with UI
-- ============================================

-- Load Dev Tools
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/loader.lua"))()

-- Get UI Manager
local UIManager = DevTools:GetModule("ui_manager")

-- Quick setup UI (auth + create window)
local Window = UIManager:QuickSetup("Dev Tools v1.0")

-- Get other modules
local SelectObject = DevTools:GetModule("select_object")
local Teleport = DevTools:GetModule("teleport")
local ESP = DevTools:GetModule("esp")

-- Create tabs
local MainTab = Window:Tab("Main", "🏠")
local ToolsTab = Window:Tab("Tools", "🔧")
local SettingsTab = Window:Tab("Settings", "⚙️")

-- Main Tab
local MainSection = MainTab:Section("Welcome")
MainSection:Label("Dev Tools by Sezy v1.0")
MainSection:Label("Modular development toolkit")
MainSection:Button("Send Test Notification", function()
    UIManager:Notify("Success!", "Button clicked!", 2)
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
InfoSection:Label("Version: 1.0.0")
InfoSection:Label("Author: Sezy")
InfoSection:Label("GitHub: Sezy0/robloxsc")

local ActionsSection = SettingsTab:Section("Actions")
ActionsSection:Button("Unload All Modules", function()
    DevTools:Unload()
    UIManager:Notify("Unloaded", "All modules unloaded", 2)
end)

print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Dev Tools by Sezy - Ready!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  UI Features:
  • Mobile-optimized compact UI
  • Object selection with Ctrl+Click
  • Teleportation utilities
  • ESP system (placeholder)
  
  Press tabs to explore features!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
