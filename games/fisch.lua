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
local NextUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/LIBui/main/nextjs_mobile_compact/init.lua"))()

-- Bypass auth
NextUI:ValidateKey("bypass", nil)

-- Create window
local Window = NextUI:Window({
    Title = "Fisch Script v1.0",
    SubTitle = "by Foxzy",
    Size = UDim2.fromOffset(500, 400)
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- Island Locations
local Islands = {
    {name = "Weather Machine", position = Vector3.new(-1498.268, 6.451, 1895.814)},
    {name = "Tropical Grove", position = Vector3.new(-2031.045, 6.268, 3678.402)},
    {name = "Esoteric Depths", position = Vector3.new(3257.165, -1300.655, 1390.807)},
}

-- NPC Locations
local NPCs = {
    {name = "Lava Fisherman", position = Vector3.new(-595.717, 59.000, 135.619)},
    {name = "Esoteric Gatekeeper", position = Vector3.new(2101.216, -29.026, 1351.308)},
}

-- Selected island & NPC (default first)
local selectedIsland = Islands[1]
local selectedNPC = NPCs[1]

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
-- MAIN TAB
-- ============================================
local MainTab = Window:Tab("Main", "🏠")

local FishingSection = MainTab:Section("🎣 Auto Fishing")

-- Auto Fish variables
local autoFishEnabled = false
local autoFishConnection = nil

local function castRod()
    -- Try to find fishing rod tool
    local character = Player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        -- Check backpack
        tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            -- Equip the tool
            character.Humanoid:EquipTool(tool)
            task.wait(0.3)
        else
            return false
        end
    end
    
    -- Cast the rod (simulate mouse click)
    local args = {"fishing", "cast"}
    
    -- Try different methods to cast
    pcall(function()
        -- Method 1: Try firing remote
        if ReplicatedStorage:FindFirstChild("events") then
            local events = ReplicatedStorage.events
            if events:FindFirstChild("fishing") then
                events.fishing:FireServer(unpack(args))
            end
        end
    end)
    
    return true
end

local function reelIn()
    -- Try to reel in fish
    local args = {"fishing", "reel"}
    
    pcall(function()
        if ReplicatedStorage:FindFirstChild("events") then
            local events = ReplicatedStorage.events
            if events:FindFirstChild("fishing") then
                events.fishing:FireServer(unpack(args))
            end
        end
    end)
    
    return true
end

local function checkBobber()
    -- Check if bobber is in water and fish is caught
    local character = Player.Character
    if not character then return false end
    
    -- Look for bobber in workspace
    local bobber = workspace:FindFirstChild(Player.Name .. "'s bobber", true)
    if not bobber then
        bobber = workspace:FindFirstChild("bobber", true)
    end
    
    if bobber then
        -- Check if bobber has a fish (usually indicated by shake or particle effect)
        local hasParticle = bobber:FindFirstChildOfClass("ParticleEmitter")
        if hasParticle then
            return true
        end
    end
    
    return false
end

local function autoFishLoop()
    while autoFishEnabled do
        local character = Player.Character
        if character then
            -- Cast the rod
            local casted = castRod()
            
            if casted then
                -- Wait for fish (check bobber)
                local maxWait = 30 -- Max 30 seconds
                local waited = 0
                
                while waited < maxWait and autoFishEnabled do
                    if checkBobber() then
                        -- Fish caught! Reel in
                        task.wait(0.2)
                        reelIn()
                        task.wait(2) -- Wait for reel animation
                        break
                    end
                    
                    task.wait(0.5)
                    waited = waited + 0.5
                end
            end
            
            task.wait(1) -- Wait before next cast
        else
            task.wait(1)
        end
    end
end

FishingSection:Toggle("Auto Fish", false, function(state)
    autoFishEnabled = state
    
    if state then
        NextUI:Notification("Auto Fish", "Enabled! Casting rod...", 2)
        -- Start auto fishing in separate thread
        task.spawn(autoFishLoop)
    else
        NextUI:Notification("Auto Fish", "Disabled", 1.5)
    end
end)

FishingSection:Label("")
FishingSection:Label("💡 Otomatis lempar kail & tarik ikan")
FishingSection:Label("⚠️ Pastikan rod sudah equipped")

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

-- NPC Teleport Section
local NPCSection = TeleportTab:Section("👤 NPC Teleport")

-- Create NPC names list for dropdown
local npcNames = {}
for i, npc in ipairs(NPCs) do
    table.insert(npcNames, npc.name)
end

-- Dropdown to select NPC
NPCSection:Dropdown("Select NPC", npcNames, function(selected)
    -- Find the selected NPC
    for i, npc in ipairs(NPCs) do
        if npc.name == selected then
            selectedNPC = npc
            Window:Notify({
                Title = "NPC Selected",
                Content = selected,
                Duration = 1.5
            })
            break
        end
    end
end)

-- Teleport to NPC button
NPCSection:Button("🚀 Teleport to Selected NPC", function()
    if selectedNPC then
        local success = TeleportTo(selectedNPC.position)
        if success then
            Window:Notify({
                Title = "Teleported!",
                Content = "→ " .. selectedNPC.name,
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
-- OTHER TAB
-- ============================================
local OtherTab = Window:Tab("Other", "⚙️")

local MovementSection = OtherTab:Section("🚶 Movement")

-- NoClip variables
local noclipEnabled = false
local noclipConnection = nil

local function enableNoClip()
    if noclipConnection then return end
    
    noclipConnection = RunService.Stepped:Connect(function()
        local character = Player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    -- Restore collision
    local character = Player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

MovementSection:Toggle("NoClip (Nembus Tembok)", false, function(state)
    noclipEnabled = state
    
    if state then
        enableNoClip()
        NextUI:Notification("NoClip", "Enabled! You can walk through walls", 2)
    else
        disableNoClip()
        NextUI:Notification("NoClip", "Disabled", 1.5)
    end
end)

MovementSection:Label("")
MovementSection:Label("💡 Aktifkan untuk jalan tembus tembok")

-- ============================================
-- COMPLETION
-- ============================================
print([[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎣 Fisch Script - Ready!
  Created by: Foxzy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  Simple UI with 4 tabs:
  • 🏠 Main - Auto Fish!
  • ℹ️  Info - About Foxzy & script
  • 📍 Teleport - Island teleport ready!
  • ⚙️  Other - NoClip & more
  
  🏝️ Islands Available:
  • Weather Machine
  • Tropical Grove
  • Esoteric Depths
  
  👤 NPCs Available:
  • Lava Fisherman
  • Esoteric Gatekeeper
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]])
