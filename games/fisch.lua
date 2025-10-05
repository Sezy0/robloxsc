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
        -- Check backpack for rod
        for _, item in pairs(Player.Backpack:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("rod") or item.Name:lower():find("fishing")) then
                tool = item
                character.Humanoid:EquipTool(tool)
                task.wait(0.5)
                break
            end
        end
        
        if not tool then
            return false
        end
    end
    
    -- Activate tool (cast)
    pcall(function()
        tool:Activate()
    end)
    
    -- Also try remote event
    pcall(function()
        local events = ReplicatedStorage:FindFirstChild("events")
        if events then
            for _, remote in pairs(events:GetChildren()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    remote:FireServer("cast")
                end
            end
        end
    end)
    
    return true
end

local function autoClickLoop()
    -- Auto spam click terus dengan random delay
    while autoFishEnabled do
        local character = Player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            
            if tool then
                -- Click/Activate tool
                pcall(function()
                    tool:Activate()
                end)
                
                -- Also try remote events
                pcall(function()
                    local events = ReplicatedStorage:FindFirstChild("events")
                    if events then
                        for _, remote in pairs(events:GetChildren()) do
                            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                                remote:FireServer("reelfinished")
                            end
                        end
                    end
                end)
            end
        end
        
        -- Random delay 0.5s - 1s
        local randomDelay = math.random(50, 100) / 100 -- 0.5 to 1.0 seconds
        task.wait(randomDelay)
    end
end

local function checkBobber()
    -- Check if bobber is in water and fish is caught
    local character = Player.Character
    if not character then return false end
    
    -- Look for bobber in workspace  
    local bobber = nil
    
    -- Method 1: Check workspace for bobber
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("bobber") or obj.Name:lower():find("float") then
            if obj:IsA("BasePart") or obj:IsA("Model") then
                bobber = obj
                break
            end
        end
    end
    
    if bobber then
        -- Check if bobber has particle effect (fish caught indicator)
        local hasParticle = bobber:FindFirstChildOfClass("ParticleEmitter", true)
        if hasParticle then
            return true
        end
        
        -- Check for splash sound
        local hasSound = bobber:FindFirstChildOfClass("Sound", true)
        if hasSound and hasSound.IsPlaying then
            return true
        end
    end
    
    -- Method 2: Check PlayerGui for fishing prompt
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                local text = gui.Text:lower()
                if text:find("reel") or text:find("catch") or text:find("!") then
                    return true
                end
            end
        end
    end
    
    return false
end

-- Auto fish removed - just use auto click spam

FishingSection:Toggle("Auto Fish (Spam Click)", false, function(state)
    autoFishEnabled = state
    
    if state then
        NextUI:Notification("Auto Fish", "Enabled! Auto clicking...", 2)
        -- Start auto click loop
        task.spawn(autoClickLoop)
    else
        NextUI:Notification("Auto Fish", "Disabled", 1.5)
    end
end)

FishingSection:Label("")
FishingSection:Label("💡 Spam click otomatis (delay random)")
FishingSection:Label("🔄 Delay: 0.5s - 1s (random)")
FishingSection:Label("⚠️ Equip rod & mulai fishing manual")

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
