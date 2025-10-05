-- ============================================
-- Commands Module
-- Chat-based command system with prefix
-- ============================================

local Commands = {}
Commands.Version = "1.0.0"
Commands.Prefix = "."
Commands.CommandList = {}
Commands.DevTools = nil
Commands.PrefixGui = nil
Commands.PrefixPanel = nil

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Create prefix UI panel
function Commands:CreatePrefixPanel()
    if self.PrefixPanel then
        self.PrefixPanel:Destroy()
    end
    
    if not self.PrefixGui then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CommandPrefixPanel"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local success = pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        
        if not success then
            screenGui.Parent = Player:WaitForChild("PlayerGui")
        end
        
        self.PrefixGui = screenGui
    end
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "PrefixPanel"
    frame.Parent = self.PrefixGui
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 320, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.Y
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(100, 200, 255)
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
    title.Text = "💬 Command Prefix"
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
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
    
    -- Current prefix display
    local currentLabel = Instance.new("TextLabel")
    currentLabel.Parent = content
    currentLabel.Size = UDim2.new(1, 0, 0, 18)
    currentLabel.BackgroundTransparency = 1
    currentLabel.Font = Enum.Font.GothamBold
    currentLabel.Text = "Current Prefix:"
    currentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    currentLabel.TextSize = 12
    currentLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Prefix display with copy button
    local prefixFrame = Instance.new("Frame")
    prefixFrame.Parent = content
    prefixFrame.Size = UDim2.new(1, 0, 0, 40)
    prefixFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    prefixFrame.BorderSizePixel = 0
    
    local prefixCorner = Instance.new("UICorner")
    prefixCorner.CornerRadius = UDim.new(0, 6)
    prefixCorner.Parent = prefixFrame
    
    local prefixText = Instance.new("TextLabel")
    prefixText.Name = "PrefixText"
    prefixText.Parent = prefixFrame
    prefixText.Position = UDim2.new(0, 12, 0, 0)
    prefixText.Size = UDim2.new(1, -80, 1, 0)
    prefixText.BackgroundTransparency = 1
    prefixText.Font = Enum.Font.GothamBold
    prefixText.Text = self.Prefix
    prefixText.TextColor3 = Color3.fromRGB(100, 255, 100)
    prefixText.TextSize = 20
    prefixText.TextXAlignment = Enum.TextXAlignment.Left
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Parent = prefixFrame
    copyBtn.AnchorPoint = Vector2.new(1, 0.5)
    copyBtn.Position = UDim2.new(1, -10, 0.5, 0)
    copyBtn.Size = UDim2.new(0, 60, 0, 26)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    copyBtn.BorderSizePixel = 0
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Text = "📋 Copy"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 11
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 5)
    copyCorner.Parent = copyBtn
    
    -- Preset buttons
    local presetsLabel = Instance.new("TextLabel")
    presetsLabel.Parent = content
    presetsLabel.Size = UDim2.new(1, 0, 0, 18)
    presetsLabel.BackgroundTransparency = 1
    presetsLabel.Font = Enum.Font.GothamBold
    presetsLabel.Text = "Quick Presets:"
    presetsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    presetsLabel.TextSize = 12
    presetsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local presets = {".", "/", ";", "!", "-", ">", "$", "#"}
    local presetGrid = Instance.new("Frame")
    presetGrid.Parent = content
    presetGrid.Size = UDim2.new(1, 0, 0, 0)
    presetGrid.BackgroundTransparency = 1
    presetGrid.AutomaticSize = Enum.AutomaticSize.Y
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = presetGrid
    gridLayout.CellSize = UDim2.new(0, 65, 0, 32)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for _, prefix in ipairs(presets) do
        local btn = Instance.new("TextButton")
        btn.Parent = presetGrid
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.Text = prefix
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 18
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            self.Prefix = prefix
            prefixText.Text = prefix
            print("[Commands] Prefix changed to:", prefix)
        end)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
    end
    
    -- Copy button functionality
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(self.Prefix)
        copyBtn.Text = "✓ Copied"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(1)
        copyBtn.Text = "📋 Copy"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    end)
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        self:HidePrefixPanel()
    end)
    
    self.PrefixPanel = frame
    return frame
end

-- Show prefix panel
function Commands:ShowPrefixPanel()
    if not self.PrefixPanel then
        self:CreatePrefixPanel()
    else
        self.PrefixPanel.Visible = true
    end
end

-- Hide prefix panel
function Commands:HidePrefixPanel()
    if self.PrefixPanel then
        self.PrefixPanel.Visible = false
    end
end

-- Toggle prefix panel
function Commands:TogglePrefixPanel()
    if self.PrefixPanel and self.PrefixPanel.Visible then
        self:HidePrefixPanel()
    else
        self:ShowPrefixPanel()
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
    
    -- Prefix command
    self:Register("prefix", "Show/change command prefix", function(args)
        self:ShowPrefixPanel()
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
