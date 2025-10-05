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

-- Island Locations
local Islands = {
    {name = "Weather Machine", position = Vector3.new(-1498.268, 6.451, 1895.814)},
    {name = "Tropical Grove", position = Vector3.new(-2031.045, 6.268, 3678.402)},
    {name = "Esoteric Depths", position = Vector3.new(3257.165, -1300.655, 1390.807)},
}

-- Selected island (default first)
local selectedIsland = Islands[1]

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

local IslandSection = TeleportTab:Section("🏝️ Island Teleport")

-- Create island names list for dropdown
local islandNames = {}
for i, island in ipairs(Islands) do
    table.insert(islandNames, island.name)
end

-- Dropdown to select island
IslandSection:Dropdown("Select Island", islandNames, function(selected)
    -- Find the selected island
    for i, island in ipairs(Islands) do
        if island.name == selected then
            selectedIsland = island
            Window:Notify({
                Title = "Island Selected",
                Content = selected,
                Duration = 1.5
            })
            break
        end
    end
end)

-- Teleport button
IslandSection:Button("🚀 Teleport to Selected Island", function()
    if selectedIsland then
        local success = TeleportTo(selectedIsland.position)
        if success then
            Window:Notify({
                Title = "Teleported!",
                Content = "→ " .. selectedIsland.name,
                Duration = 2
            })
        else
            Window:Notify({
                Title = "Failed",
                Content = "Teleport failed!",
                Duration = 1.5
            })
        end
    end
end)


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
  • 📍 Teleport - Island teleport ready!
  
  🏝️ Islands Available:
  • Weather Machine
  • Tropical Grove
  • Esoteric Depths
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
