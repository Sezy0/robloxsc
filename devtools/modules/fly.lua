-- ============================================
-- Fly Module
-- Allows player to fly/levitate
-- ============================================

local Fly = {}
Fly.Version = "1.0.0"
Fly.Active = false
Fly.Speed = 50
Fly.BodyVelocity = nil
Fly.BodyGyro = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Key states
local Keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false,
}

-- Setup flying physics
function Fly:SetupPhysics()
    local character = Player.Character
    if not character then
        warn("[Fly] Character not found!")
        return false
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("[Fly] HumanoidRootPart not found!")
        return false
    end
    
    -- Create BodyVelocity for movement
    if not self.BodyVelocity then
        self.BodyVelocity = Instance.new("BodyVelocity")
        self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        self.BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        self.BodyVelocity.Parent = humanoidRootPart
    end
    
    -- Create BodyGyro for rotation
    if not self.BodyGyro then
        self.BodyGyro = Instance.new("BodyGyro")
        self.BodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        self.BodyGyro.P = 9000
        self.BodyGyro.Parent = humanoidRootPart
    end
    
    return true
end

-- Remove flying physics
function Fly:RemovePhysics()
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    
    if self.BodyGyro then
        self.BodyGyro:Destroy()
        self.BodyGyro = nil
    end
end

-- Calculate movement direction
function Fly:GetMoveDirection()
    local direction = Vector3.new(0, 0, 0)
    
    -- Forward/Backward
    if Keys.W then
        direction = direction + Camera.CFrame.LookVector
    end
    if Keys.S then
        direction = direction - Camera.CFrame.LookVector
    end
    
    -- Left/Right
    if Keys.A then
        direction = direction - Camera.CFrame.RightVector
    end
    if Keys.D then
        direction = direction + Camera.CFrame.RightVector
    end
    
    -- Up/Down
    if Keys.Space then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if Keys.LeftShift then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    return direction.Unit
end

-- Enable fly
function Fly:Enable()
    if self.Active then
        print("[Fly] Already enabled!")
        return
    end
    
    if not self:SetupPhysics() then
        return
    end
    
    self.Active = true
    
    -- Enable physics
    self.BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    self.BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    -- Movement loop
    self.FlyConnection = RunService.Heartbeat:Connect(function()
        if not self.Active then return end
        
        local character = Player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Update direction
        local moveDirection = self:GetMoveDirection()
        
        -- Update velocity
        if moveDirection.Magnitude > 0 then
            self.BodyVelocity.Velocity = moveDirection * self.Speed
        else
            self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Update rotation to match camera
        self.BodyGyro.CFrame = Camera.CFrame
    end)
    
    print("[Fly] Enabled! Speed:", self.Speed)
    print("  Controls: W/A/S/D = Move, Space = Up, Shift = Down")
end

-- Disable fly
function Fly:Disable()
    if not self.Active then
        print("[Fly] Already disabled!")
        return
    end
    
    self.Active = false
    
    if self.FlyConnection then
        self.FlyConnection:Disconnect()
        self.FlyConnection = nil
    end
    
    self:RemovePhysics()
    
    print("[Fly] Disabled!")
end

-- Toggle fly
function Fly:Toggle(state)
    if state == nil then
        state = not self.Active
    end
    
    if state then
        self:Enable()
    else
        self:Disable()
    end
    
    return self.Active
end

-- Set fly speed
function Fly:SetSpeed(speed)
    self.Speed = speed
    print("[Fly] Speed set to:", speed)
end

-- Initialize module
function Fly:Init()
    print("[Fly] Module initialized v" .. self.Version)
    
    -- Key input handling
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            Keys.W = true
        elseif input.KeyCode == Enum.KeyCode.A then
            Keys.A = true
        elseif input.KeyCode == Enum.KeyCode.S then
            Keys.S = true
        elseif input.KeyCode == Enum.KeyCode.D then
            Keys.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            Keys.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            Keys.LeftShift = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            Keys.W = false
        elseif input.KeyCode == Enum.KeyCode.A then
            Keys.A = false
        elseif input.KeyCode == Enum.KeyCode.S then
            Keys.S = false
        elseif input.KeyCode == Enum.KeyCode.D then
            Keys.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            Keys.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            Keys.LeftShift = false
        end
    end)
    
    return self
end

-- Unload module
function Fly:Unload()
    self:Disable()
    print("[Fly] Module unloaded")
end

return Fly:Init()
