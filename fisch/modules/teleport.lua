-- ============================================
-- Teleport Module for Fisch
-- Manage teleport locations
-- ============================================

local Teleport = {}
Teleport.Version = "1.0.0"
Teleport.Locations = {}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Define locations (EMPTY - will be filled later)
local LocationsData = {
    -- Format: {name = "Location Name", position = Vector3.new(x, y, z)}
    -- Example:
    -- {name = "Spawn", position = Vector3.new(0, 10, 0)},
    -- {name = "Shop", position = Vector3.new(50, 5, 100)},
    -- {name = "Fishing Spot 1", position = Vector3.new(100, 5, 200)},
}

-- Teleport player to position
function Teleport:ToPosition(position)
    local character = Player.Character
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
    print("[Teleport] Teleported to:", position)
    return true
end

-- Teleport by location name
function Teleport:Teleport(locationName)
    for _, location in ipairs(self.Locations) do
        if location.name == locationName then
            return self:ToPosition(location.position)
        end
    end
    
    warn("[Teleport] Location not found:", locationName)
    return false
end

-- Get all locations
function Teleport:GetAll()
    return self.Locations
end

-- Add location (for future use)
function Teleport:Add(name, position)
    table.insert(self.Locations, {
        name = name,
        position = position
    })
    print("[Teleport] Added location:", name)
end

-- Initialize
function Teleport:Init()
    -- Load locations
    self.Locations = LocationsData
    
    print("[Teleport] Module initialized v" .. self.Version)
    print("[Teleport] Loaded " .. #self.Locations .. " locations")
    
    return self
end

-- Unload
function Teleport:Unload()
    self.Locations = {}
    print("[Teleport] Module unloaded")
end

return Teleport:Init()
