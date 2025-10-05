-- ============================================
-- Fisch Script by Foxzy
-- Game: Fisch (Fishing Game)
-- Version: 1.0.0
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  🎣 Fisch Script by Foxzy")
print("  Version: 1.0.0")
print("  Loading NextUI...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Load NextUI Library
local NextUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/libs/nextui.lua"))()
local Window = NextUI:Window({
    Title = "Fisch Script v1.0",
    SubTitle = "by Foxzy",
    Size = UDim2.fromOffset(500, 400)
})

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

-- Simple Teleport Function
local function TeleportTo(position)
    local character = Player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    hrp.CFrame = CFrame.new(position)
    return true
end

-- ============================================
-- INFO TAB
-- ============================================
local InfoTab = Window:Tab("Info", "ℹ️")

local AboutSection = InfoTab:Section("👤 About")
AboutSection:Label("🎣 Fisch Script")
AboutSection:Label("")
AboutSection:Label("Created by: Foxzy")
AboutSection:Label("Version: 1.0.0")
AboutSection:Label("Game: Fisch")
AboutSection:Label("")
AboutSection:Label("Status: Active ✅")

local ContactSection = InfoTab:Section("📞 Contact")
ContactSection:Label("Developer: Foxzy")
ContactSection:Label("GitHub: Sezy0/robloxsc")
ContactSection:Label("")
ContactSection:Label("💡 More features coming soon!")

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
else
    -- Add teleport buttons for each location
    for i, location in ipairs(TeleportLocations) do
        TeleportSection:Button(location.name, function()
            local success = TeleportTo(location.position)
            if success then
                Window:Notify({
                    Title = "Teleported",
                    Content = "→ " .. location.name,
                    Duration = 1.5
                })
            else
                Window:Notify({
                    Title = "Failed",
                    Content = "Teleport failed!",
                    Duration = 1.5
                })
            end
        end)
    end
end


-- ============================================
-- COMPLETION
-- ============================================
print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎣 Fisch Script - Ready!
  Created by: Foxzy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  Simple UI with 2 tabs:
  • ℹ️  Info - About Foxzy & script
  • 📍 Teleport - Locations (empty)
  
  💡 Teleport locations will be added soon!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
