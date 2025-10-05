-- ============================================
-- Teleport Module
-- Quick teleportation utilities
-- ============================================

local Teleport = {}
Teleport.Version = "1.0.0"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Teleport:Init()
    print("[Teleport] Initialized")
    return self
end

-- Teleport to position
function Teleport:ToPosition(position)
    local character = LocalPlayer.Character
    if not character then
        warn("[Teleport] Character not found!")
        return false
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("[Teleport] HumanoidRootPart not found!")
        return false
    end
    
    humanoidRootPart.CFrame = CFrame.new(position)
    print("[Teleport] Teleported to position: " .. tostring(position))
    return true
end

-- Teleport to player
function Teleport:ToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer then
        warn("[Teleport] Player not found: " .. playerName)
        return false
    end
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        warn("[Teleport] Target character not found!")
        return false
    end
    
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        warn("[Teleport] Target HumanoidRootPart not found!")
        return false
    end
    
    return self:ToPosition(targetRoot.Position)
end

-- Teleport to part
function Teleport:ToPart(part)
    if not part or not part:IsA("BasePart") then
        warn("[Teleport] Invalid part!")
        return false
    end
    
    return self:ToPosition(part.Position)
end

function Teleport:Unload()
    print("[Teleport] Unloaded")
end

return Teleport:Init()
