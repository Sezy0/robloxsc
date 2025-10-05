-- ============================================
-- Commands Module
-- Chat-based command system with prefix
-- ============================================

local Commands = {}
Commands.Version = "1.0.0"
Commands.Prefix = "."
Commands.CommandList = {}
Commands.DevTools = nil
Commands.PositionGui = nil
Commands.PositionPanel = nil
Commands.PositionUpdateConnection = nil

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Create position display panel
function Commands:CreatePositionPanel()
    if self.PositionPanel then
        self.PositionPanel:Destroy()
    end
    
    if not self.PositionGui then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PositionDisplayPanel"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local success = pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        
        if not success then
            screenGui.Parent = Player:WaitForChild("PlayerGui")
        end
        
        self.PositionGui = screenGui
    end
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "PositionPanel"
    frame.Parent = self.PositionGui
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Position = UDim2.new(0, 10, 0, 100)
    frame.Size = UDim2.new(0, 280, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.Y
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(255, 200, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- Header (draggable)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = frame
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.BorderSizePixel = 0
    header.Active = true
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    local headerCover = Instance.new("Frame")
    headerCover.Parent = header
    headerCover.Position = UDim2.new(0, 0, 0.5, 0)
    headerCover.Size = UDim2.new(1, 0, 0.5, 0)
    headerCover.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    headerCover.BorderSizePixel = 0
    
    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "📍 Position Display"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = header
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- Content
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = frame
    content.Position = UDim2.new(0, 0, 0, 40)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.AutomaticSize = Enum.AutomaticSize.Y
    
    local padding = Instance.new("UIPadding")
    padding.Parent = content
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    -- Position displays
    local function createCoordDisplay(parent, label, color)
        local coordFrame = Instance.new("Frame")
        coordFrame.Parent = parent
        coordFrame.Size = UDim2.new(1, 0, 0, 45)
        coordFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        coordFrame.BorderSizePixel = 0
        
        local coordCorner = Instance.new("UICorner")
        coordCorner.CornerRadius = UDim.new(0, 6)
        coordCorner.Parent = coordFrame
        
        local coordLabel = Instance.new("TextLabel")
        coordLabel.Parent = coordFrame
        coordLabel.Position = UDim2.new(0, 12, 0, 5)
        coordLabel.Size = UDim2.new(1, -24, 0, 15)
        coordLabel.BackgroundTransparency = 1
        coordLabel.Font = Enum.Font.GothamBold
        coordLabel.Text = label
        coordLabel.TextColor3 = color
        coordLabel.TextSize = 11
        coordLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Parent = coordFrame
        valueLabel.Position = UDim2.new(0, 12, 0, 22)
        valueLabel.Size = UDim2.new(1, -24, 0, 18)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = "0.000"
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 16
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        return valueLabel
    end
    
    local xValue = createCoordDisplay(content, "X Axis", Color3.fromRGB(255, 80, 80))
    local yValue = createCoordDisplay(content, "Y Axis", Color3.fromRGB(80, 255, 80))
    local zValue = createCoordDisplay(content, "Z Axis", Color3.fromRGB(80, 120, 255))
    
    -- Copy all button
    local copyAllBtn = Instance.new("TextButton")
    copyAllBtn.Parent = content
    copyAllBtn.Size = UDim2.new(1, 0, 0, 35)
    copyAllBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    copyAllBtn.BorderSizePixel = 0
    copyAllBtn.Font = Enum.Font.GothamBold
    copyAllBtn.Text = "📋 Copy Position"
    copyAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyAllBtn.TextSize = 12
    
    local copyAllCorner = Instance.new("UICorner")
    copyAllCorner.CornerRadius = UDim.new(0, 6)
    copyAllCorner.Parent = copyAllBtn
    
    -- Update position in real-time
    if self.PositionUpdateConnection then
        self.PositionUpdateConnection:Disconnect()
    end
    
    self.PositionUpdateConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local character = Player.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                xValue.Text = string.format("%.3f", pos.X)
                yValue.Text = string.format("%.3f", pos.Y)
                zValue.Text = string.format("%.3f", pos.Z)
            end
        end
    end)
    
    -- Copy button functionality
    copyAllBtn.MouseButton1Click:Connect(function()
        local character = Player.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                local posText = string.format("X: %.3f, Y: %.3f, Z: %.3f", pos.X, pos.Y, pos.Z)
                setclipboard(posText)
                copyAllBtn.Text = "✓ Copied!"
                copyAllBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
                task.wait(1)
                copyAllBtn.Text = "📋 Copy Position"
                copyAllBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
            end
        end
    end)
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        self:HidePositionPanel()
    end)
    
    self.PositionPanel = frame
    return frame
end

-- Show position panel
function Commands:ShowPositionPanel()
    if not self.PositionPanel then
        self:CreatePositionPanel()
    else
        self.PositionPanel.Visible = true
    end
end

-- Hide position panel
function Commands:HidePositionPanel()
    if self.PositionPanel then
        self.PositionPanel.Visible = false
        if self.PositionUpdateConnection then
            self.PositionUpdateConnection:Disconnect()
            self.PositionUpdateConnection = nil
        end
    end
end

-- Toggle position panel
function Commands:TogglePositionPanel()
    if self.PositionPanel and self.PositionPanel.Visible then
        self:HidePositionPanel()
    else
        self:ShowPositionPanel()
    end
end

-- Register a command
function Commands:Register(name, description, callback)
    self.CommandList[name:lower()] = {
        Name = name,
        Description = description,
        Callback = callback
    }
    print("[Commands] Registered:", self.Prefix .. name)
end

-- Execute command
function Commands:Execute(message)
    -- Check if message starts with prefix
    if not message:sub(1, #self.Prefix) == self.Prefix then
        return false
    end
    
    -- Remove prefix
    local commandString = message:sub(#self.Prefix + 1)
    
    -- Parse command and args
    local args = {}
    for word in commandString:gmatch("%S+") do
        table.insert(args, word)
    end
    
    if #args == 0 then
        return false
    end
    
    local commandName = args[1]:lower()
    table.remove(args, 1)
    
    -- Find and execute command
    local command = self.CommandList[commandName]
    if command then
        print("[Commands] Executing:", self.Prefix .. commandName)
        local success, err = pcall(function()
            command.Callback(args)
        end)
        
        if not success then
            warn("[Commands] Error:", err)
        end
        
        return true
    else
        warn("[Commands] Unknown command:", commandName)
        return false
    end
end

-- Register built-in commands
function Commands:RegisterBuiltInCommands()
    -- Help command
    self:Register("help", "Show all commands", function(args)
        print("\n━━━━━━━━━ COMMANDS ━━━━━━━━━")
        for name, cmd in pairs(self.CommandList) do
            print(string.format("  %s%s - %s", self.Prefix, cmd.Name, cmd.Description))
        end
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    end)
    
    -- Fly command
    self:Register("fly", "Toggle fly mode", function(args)
        if not self.DevTools then return end
        local Fly = self.DevTools:GetModule("fly")
        if Fly then
            Fly:Toggle()
        else
            warn("[Commands] Fly module not loaded!")
        end
    end)
    
    -- Flyspeed command
    self:Register("flyspeed", "Set fly speed (usage: .flyspeed 100)", function(args)
        if not self.DevTools then return end
        local Fly = self.DevTools:GetModule("fly")
        if Fly then
            local speed = tonumber(args[1]) or 50
            Fly:SetSpeed(speed)
        else
            warn("[Commands] Fly module not loaded!")
        end
    end)
    
    -- Speed command (WalkSpeed)
    self:Register("speed", "Set walk speed (usage: .speed 50)", function(args)
        local speed = tonumber(args[1]) or 16
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
                print("[Commands] WalkSpeed set to:", speed)
            end
        end
    end)
    
    -- Jump command (JumpPower)
    self:Register("jump", "Set jump power (usage: .jump 100)", function(args)
        local power = tonumber(args[1]) or 50
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = power
                print("[Commands] JumpPower set to:", power)
            end
        end
    end)
    
    -- Teleport to player
    self:Register("tp", "Teleport to player (usage: .tp PlayerName)", function(args)
        if not self.DevTools then return end
        local Teleport = self.DevTools:GetModule("teleport")
        if Teleport and args[1] then
            Teleport:ToPlayer(args[1])
        else
            warn("[Commands] Usage: .tp PlayerName")
        end
    end)
    
    -- God mode
    self:Register("god", "Toggle god mode (infinite health)", function(args)
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if humanoid.MaxHealth == math.huge then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                    print("[Commands] God mode: OFF")
                else
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                    print("[Commands] God mode: ON")
                end
            end
        end
    end)
    
    -- Noclip
    self:Register("noclip", "Toggle noclip mode", function(args)
        local character = Player.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not part.CanCollide
            end
        end
        
        print("[Commands] Noclip toggled!")
    end)
    
    -- Clear command
    self:Register("clear", "Clear output console", function(args)
        for i = 1, 50 do
            print("\n")
        end
    end)
    
    -- Position command
    self:Register("pos", "Show position display", function(args)
        self:ShowPositionPanel()
    end)
    
    self:Register("position", "Show position display", function(args)
        self:ShowPositionPanel()
    end)
end

-- Setup chat listener
function Commands:SetupChatListener()
    -- Try TextChatService first (new chat system)
    local success = pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.MessageReceived:Connect(function(message)
                if message.TextSource and message.TextSource.UserId == Player.UserId then
                    self:Execute(message.Text)
                end
            end)
            print("[Commands] Using TextChatService")
            return
        end
    end)
    
    -- Fallback to legacy chat
    if not success then
        Player.Chatted:Connect(function(message)
            self:Execute(message)
        end)
        print("[Commands] Using Legacy Chat")
    end
end

-- Set DevTools reference
function Commands:SetDevTools(devTools)
    self.DevTools = devTools
end

-- Initialize module
function Commands:Init()
    print("[Commands] Module initialized v" .. self.Version)
    print("[Commands] Prefix: " .. self.Prefix)
    
    self:RegisterBuiltInCommands()
    self:SetupChatListener()
    
    print("[Commands] Type " .. self.Prefix .. "help for command list")
    
    return self
end

-- Unload module
function Commands:Unload()
    self.CommandList = {}
    print("[Commands] Module unloaded")
end

return Commands:Init()
