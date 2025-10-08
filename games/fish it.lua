local NextUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/LIBui/main/nextjs_mobile_compact/init.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- Remote Functions (with safe loading)
local RFUpdateAutoFishingState = nil

pcall(function()
    RFUpdateAutoFishingState = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/UpdateAutoFishingState"]
end)

-- Auth & UI Setup
NextUI:Auth({
    UseKeySystem = true,
    KeyUrl = "https://raw.githubusercontent.com/Sezy0/LIBui/main/key.txt",
    LogoId = "133508780883906",
    DiscordLink = "https://discord.gg/utp3vmsyjY",
    OnSuccess = function()
        
local Window = NextUI:Window({
    Title = "Fish It v3.2",
    LogoId = "133508780883906"
})

local MainTab = Window:Tab("Main")
local FishingSection = MainTab:Section("Fishing")

FishingSection:Toggle("Auto Fishing", false, function(state)
    if not RFUpdateAutoFishingState then
        NextUI:Notification("Error", "Remote not found", 1.5)
        return
    end
    
    local success = pcall(function()
        RFUpdateAutoFishingState:InvokeServer(state)
    end)
    
    if success then
        NextUI:Notification("Auto Fishing", state and "Enabled" or "Disabled", 1.5)
    else
        NextUI:Notification("Error", "Failed to toggle", 1.5)
    end
end)

FishingSection:Label("")
if RFUpdateAutoFishingState then
    FishingSection:Label("Server-side auto fishing")
else
    FishingSection:Label("Remote not detected")
end

local TeleportTab = Window:Tab("Teleport")
local IslandSection = TeleportTab:Section("Islands")

-- Teleport function (lightweight, local scope)
local function teleportTo(position)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Island Teleports
local Islands = {
    {name = "Weather Machine", pos = Vector3.new(-1498.268, 6.451, 1895.814)},
    {name = "Tropical Grove", pos = Vector3.new(-2031.045, 6.268, 3678.402)},
    {name = "Esoteric Depths", pos = Vector3.new(3257.165, -1300.655, 1390.807)},
}

for _, island in ipairs(Islands) do
    IslandSection:Button(island.name, function()
        local success = teleportTo(island.pos)
        NextUI:Notification(success and "Teleported!" or "Failed", island.name, 1.5)
    end)
end

-- NPC Teleports
local NPCSection = TeleportTab:Section("NPCs")

local NPCs = {
    {name = "Lava Fisherman", pos = Vector3.new(-595.717, 59.000, 135.619)},
    {name = "Esoteric Gatekeeper", pos = Vector3.new(2101.216, -29.026, 1351.308)},
}

for _, npc in ipairs(NPCs) do
    NPCSection:Button(npc.name, function()
        local success = teleportTo(npc.pos)
        NextUI:Notification(success and "Teleported!" or "Failed", npc.name, 1.5)
    end)
end

-- ============================================
-- INFO TAB
-- ============================================
local InfoTab = Window:Tab("Info")
local AboutSection = InfoTab:Section("About")

AboutSection:Label("Fish It Script")
AboutSection:Label("")
AboutSection:Label("Created by: Foxzy")
AboutSection:Label("Version: 3.2.1")
AboutSection:Label("Game: Fisch")
AboutSection:Label("")
AboutSection:Label("Status: Active")

local ContactSection = InfoTab:Section("Contact")
ContactSection:Label("Developer: Foxzy")
ContactSection:Label("")
ContactSection:Label("Clean & Safe Version")

local ChangelogSection = InfoTab:Section("Changelog v3.2")
ChangelogSection:Label("Features:")
ChangelogSection:Label("• Auto Fishing (server-side)")
ChangelogSection:Label("• Auto equip rod")
ChangelogSection:Label("• Teleport to Islands")
ChangelogSection:Label("• Teleport to NPCs")
ChangelogSection:Label("• NoClip movement")
ChangelogSection:Label("")
ChangelogSection:Label("Note: Requires Level 3+")
ChangelogSection:Label("Just toggle and AFK!")

    end -- OnSuccess
}) -- Auth
