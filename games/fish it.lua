local NextUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/LIBui/main/nextjs_mobile_compact/init.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- Remote Functions (with safe loading)
local RFUpdateAutoFishingState = nil
local RFSellAllItems = nil

pcall(function()
    RFUpdateAutoFishingState = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/UpdateAutoFishingState"]
end)

pcall(function()
    RFSellAllItems = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]
end)

-- Auth & UI Setup
NextUI:Auth({
    UseKeySystem = true,
    KeyUrl = "https://raw.githubusercontent.com/Sezy0/LIBui/main/key.txt",
    LogoId = "133508780883906",
    DiscordLink = "https://discord.gg/utp3vmsyjY",
    OnSuccess = function()
        
local Window = NextUI:Window({
    Title = "Fish It v3.2.2",
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

-- Anti AFK Section
local AntiAFKSection = MainTab:Section("Anti AFK")
local antiAfkActive = false
local antiAfkLoop = nil

AntiAFKSection:Toggle("Anti AFK", false, function(state)
    antiAfkActive = state
    
    if state then
        -- Start Anti AFK loop
        antiAfkLoop = task.spawn(function()
            while antiAfkActive do
                local char = Player.Character
                if char and char:FindFirstChild("Humanoid") then
                    local humanoid = char.Humanoid
                    
                    -- Random jump
                    humanoid.Jump = true
                end
                
                -- Random delay between 1-3 seconds
                task.wait(math.random(10, 30) / 10)
            end
        end)
        
        NextUI:Notification("Anti AFK", "Enabled", 1.5)
    else
        -- Stop Anti AFK
        if antiAfkLoop then
            task.cancel(antiAfkLoop)
            antiAfkLoop = nil
        end
        NextUI:Notification("Anti AFK", "Disabled", 1.5)
    end
end)

AntiAFKSection:Label("")
AntiAFKSection:Label("Prevents AFK kick")

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
-- SHOP TAB
-- ============================================
local ShopTab = Window:Tab("Shop")
local ShopSection = ShopTab:Section("Auto Sell Fish")
local autoSellActive = false
local autoSellLoop = nil

ShopSection:Toggle("Auto Sell All Fish (5 min)", false, function(state)
    autoSellActive = state

    if state then
        -- Start Auto Sell loop
        autoSellLoop = task.spawn(function()
            while autoSellActive do
                if RFSellAllItems then
                    local success = pcall(function()
                        RFSellAllItems:InvokeServer()
                    end)
                    if success then
                        NextUI:Notification("Auto Sell", "Fish sold", 1.5)
                    else
                        NextUI:Notification("Auto Sell Error", "Failed to sell", 1.5)
                    end
                else
                    NextUI:Notification("Auto Sell Error", "Remote not found", 1.5)
                    autoSellActive = false -- Stop if remote not found
                    break
                end

                -- Wait 5 minutes (300 seconds)
                task.wait(300)
            end
        end)

        NextUI:Notification("Auto Sell", "Enabled", 1.5)
    else
        -- Stop Auto Sell
        if autoSellLoop then
            task.cancel(autoSellLoop)
            autoSellLoop = nil
        end
        NextUI:Notification("Auto Sell", "Disabled", 1.5)
    end
end)

ShopSection:Label("")
if RFSellAllItems then
    ShopSection:Label("Server-side auto sell every 5 minutes")
else
    ShopSection:Label("Remote not detected")
end

-- ============================================
-- INFO TAB
-- ============================================
local InfoTab = Window:Tab("Info")
local AboutSection = InfoTab:Section("About")

AboutSection:Label("Fish It Script")
AboutSection:Label("")
AboutSection:Label("Created by: Foxzy")
AboutSection:Label("Version: 3.2.2")
AboutSection:Label("")
AboutSection:Label("Status: Active")

local ContactSection = InfoTab:Section("Contact")
ContactSection:Label("Developer: Foxzy")
ContactSection:Label("")
ContactSection:Label("Clean & Safe Version")

local ChangelogSection = InfoTab:Section("Changelog v3.2.2")
ChangelogSection:Label("Features:")
ChangelogSection:Label("• Auto Fishing (server-side)")
ChangelogSection:Label("• Auto equip rod")
ChangelogSection:Label("• Teleport to Islands")
ChangelogSection:Label("• Teleport to NPCs")
ChangelogSection:Label("• Auto Sell Fish (every 5 minutes)")
ChangelogSection:Label("")
ChangelogSection:Label("Note: Requires Level 3+")
ChangelogSection:Label("Just toggle and AFK!")

    end -- OnSuccess
}) -- Auth
