-- ============================================
-- Helper Utilities
-- Common functions used across modules
-- ============================================

local Helpers = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Get distance between two Vector3 positions
function Helpers:GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Get player's character
function Helpers:GetCharacter(player)
    player = player or Players.LocalPlayer
    return player.Character or player.CharacterAdded:Wait()
end

-- Get player's root part
function Helpers:GetRootPart(player)
    local character = self:GetCharacter(player)
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- Tween object properties
function Helpers:Tween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.5
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

-- Wait for child with timeout
function Helpers:WaitForChild(parent, childName, timeout)
    timeout = timeout or 5
    local startTime = tick()
    
    while not parent:FindFirstChild(childName) do
        if tick() - startTime > timeout then
            return nil
        end
        task.wait(0.1)
    end
    
    return parent:FindFirstChild(childName)
end

-- Get all players in range
function Helpers:GetPlayersInRange(position, range)
    local playersInRange = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local rootPart = self:GetRootPart(player)
            if rootPart then
                local distance = self:GetDistance(position, rootPart.Position)
                if distance <= range then
                    table.insert(playersInRange, {
                        Player = player,
                        Distance = distance,
                        RootPart = rootPart
                    })
                end
            end
        end
    end
    
    -- Sort by distance
    table.sort(playersInRange, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return playersInRange
end

-- Format number with commas
function Helpers:FormatNumber(number)
    local formatted = tostring(number)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Round number to decimal places
function Helpers:Round(number, decimals)
    decimals = decimals or 0
    local mult = 10^decimals
    return math.floor(number * mult + 0.5) / mult
end

-- Check if position is in bounds
function Helpers:IsInBounds(position, min, max)
    return position.X >= min.X and position.X <= max.X
       and position.Y >= min.Y and position.Y <= max.Y
       and position.Z >= min.Z and position.Z <= max.Z
end

-- Get all descendants of class
function Helpers:GetDescendantsOfClass(parent, className)
    local descendants = {}
    for _, obj in pairs(parent:GetDescendants()) do
        if obj:IsA(className) then
            table.insert(descendants, obj)
        end
    end
    return descendants
end

-- Deep copy table
function Helpers:DeepCopy(original)
    local copy
    if type(original) == 'table' then
        copy = {}
        for key, value in next, original, nil do
            copy[self:DeepCopy(key)] = self:DeepCopy(value)
        end
        setmetatable(copy, self:DeepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

-- Notification helper (console for now)
function Helpers:Notify(title, message, duration)
    print(string.format("[%s] %s", title, message))
end

print("[Helpers] Utility functions loaded")

return Helpers
