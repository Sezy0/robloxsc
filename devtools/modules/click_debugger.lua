-- ============================================
-- Click Debugger Module
-- Track and log all mouse/touch clicks
-- ============================================

local ClickDebugger = {}
ClickDebugger.Version = "1.0.0"
ClickDebugger.Active = false
ClickDebugger.ClickHistory = {}
ClickDebugger.MaxHistory = 100
ClickDebugger.LogPanel = nil
ClickDebugger.LogGui = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Format timestamp
local function getTimestamp()
    local time = os.date("*t")
    return string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
end

-- Get UI elements under click
local function getUIElementsAtPosition(x, y)
    local elements = {}
    
    -- Check PlayerGui
    local success, playerGuis = pcall(function()
        return Player.PlayerGui:GetGuiObjectsAtPosition(x, y)
    end)
    
    if success and playerGuis then
        for _, gui in ipairs(playerGuis) do
            table.insert(elements, gui)
        end
    end
    
    -- Check CoreGui
    local success2, coreGuis = pcall(function()
        return game:GetService("CoreGui"):GetGuiObjectsAtPosition(x, y)
    end)
    
    if success2 and coreGuis then
        for _, gui in ipairs(coreGuis) do
            table.insert(elements, gui)
        end
    end
    
    return elements
end

-- Log click event
function ClickDebugger:LogClick(clickData)
    -- Add to history
    table.insert(self.ClickHistory, 1, clickData)
    
    -- Limit history size
    if #self.ClickHistory > self.MaxHistory then
        table.remove(self.ClickHistory, #self.ClickHistory)
    end
    
    -- Print to console with formatted output
    print("\n━━━━━━━━━━━ CLICK DETECTED ━━━━━━━━━━━")
    print("⏰ Time:", clickData.timestamp)
    print("📍 Position: X=" .. clickData.x .. ", Y=" .. clickData.y)
    
    if clickData.target3D then
        print("🎯 3D Target:", clickData.target3D:GetFullName())
        print("   Class:", clickData.target3D.ClassName)
        if clickData.target3D:IsA("BasePart") then
            print("   Position:", clickData.target3D.Position)
        end
    else
        print("🎯 3D Target: None")
    end
    
    if #clickData.uiElements > 0 then
        print("🖥️  UI Elements (" .. #clickData.uiElements .. "):")
        for i, element in ipairs(clickData.uiElements) do
            print("   " .. i .. ". " .. element:GetFullName())
            print("      Class: " .. element.ClassName)
            
            -- Show text if available
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                if element.Text and element.Text ~= "" then
                    print("      Text: \"" .. element.Text .. "\"")
                end
            end
            
            -- Show image if available
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                if element.Image and element.Image ~= "" then
                    print("      Image: " .. element.Image)
                end
            end
        end
    else
        print("🖥️  UI Elements: None")
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    
    -- Update log panel if exists
    if self.LogPanel and self.LogPanel.Visible then
        self:UpdateLogPanel()
    end
end

-- Track click
function ClickDebugger:TrackClick(input)
    local clickData = {
        timestamp = getTimestamp(),
        x = math.floor(input.Position.X),
        y = math.floor(input.Position.Y),
        target3D = Mouse.Target,
        uiElements = getUIElementsAtPosition(input.Position.X, input.Position.Y)
    }
    
    self:LogClick(clickData)
end

-- Create log panel UI
function ClickDebugger:CreateLogPanel()
    if self.LogPanel then
        self.LogPanel:Destroy()
    end
    
    if not self.LogGui then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ClickDebuggerLog"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 998
        
        local success = pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        
        if not success then
            screenGui.Parent = Player:WaitForChild("PlayerGui")
        end
        
        self.LogGui = screenGui
    end
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "LogPanel"
    frame.Parent = self.LogGui
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(255, 100, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = frame
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 1000
    
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
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local headerCover = Instance.new("Frame")
    headerCover.Parent = header
    headerCover.Position = UDim2.new(0, 0, 0.5, 0)
    headerCover.Size = UDim2.new(1, 0, 0.5, 0)
    headerCover.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    headerCover.BorderSizePixel = 0
    headerCover.ZIndex = 1000
    
    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "🐛 Click Debugger"
    title.TextColor3 = Color3.fromRGB(255, 100, 255)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 1000
    
    -- Clear button
    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "ClearButton"
    clearBtn.Parent = header
    clearBtn.AnchorPoint = Vector2.new(1, 0.5)
    clearBtn.Position = UDim2.new(1, -40, 0.5, 0)
    clearBtn.Size = UDim2.new(0, 28, 0, 22)
    clearBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    clearBtn.BorderSizePixel = 0
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Text = "🗑️"
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextSize = 14
    clearBtn.ZIndex = 1000
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 4)
    clearCorner.Parent = clearBtn
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = header
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 1000
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    -- Log content
    local logScroll = Instance.new("ScrollingFrame")
    logScroll.Name = "LogScroll"
    logScroll.Parent = frame
    logScroll.Position = UDim2.new(0, 0, 0, 35)
    logScroll.Size = UDim2.new(1, 0, 1, -35)
    logScroll.BackgroundTransparency = 1
    logScroll.BorderSizePixel = 0
    logScroll.ScrollBarThickness = 4
    logScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 255)
    logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logScroll.ZIndex = 1000
    
    local logPadding = Instance.new("UIPadding")
    logPadding.Parent = logScroll
    logPadding.PaddingTop = UDim.new(0, 5)
    logPadding.PaddingBottom = UDim.new(0, 5)
    logPadding.PaddingLeft = UDim.new(0, 5)
    logPadding.PaddingRight = UDim.new(0, 5)
    
    local logLayout = Instance.new("UIListLayout")
    logLayout.Parent = logScroll
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logLayout.Padding = UDim.new(0, 5)
    
    -- Button events
    clearBtn.MouseButton1Click:Connect(function()
        self.ClickHistory = {}
        self:UpdateLogPanel()
        print("[ClickDebugger] History cleared!")
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:HideLogPanel()
    end)
    
    self.LogPanel = frame
    self:UpdateLogPanel()
    
    return frame
end

-- Update log panel content
function ClickDebugger:UpdateLogPanel()
    if not self.LogPanel then return end
    
    local logScroll = self.LogPanel:FindFirstChild("LogScroll")
    if not logScroll then return end
    
    -- Clear existing logs
    for _, child in ipairs(logScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add click entries
    for i, clickData in ipairs(self.ClickHistory) do
        local entry = Instance.new("Frame")
        entry.Name = "Entry" .. i
        entry.Parent = logScroll
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        entry.BorderSizePixel = 0
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.ZIndex = 1000
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 4)
        entryCorner.Parent = entry
        
        local entryPadding = Instance.new("UIPadding")
        entryPadding.Parent = entry
        entryPadding.PaddingTop = UDim.new(0, 5)
        entryPadding.PaddingBottom = UDim.new(0, 5)
        entryPadding.PaddingLeft = UDim.new(0, 8)
        entryPadding.PaddingRight = UDim.new(0, 8)
        
        local entryLayout = Instance.new("UIListLayout")
        entryLayout.Parent = entry
        entryLayout.SortOrder = Enum.SortOrder.LayoutOrder
        entryLayout.Padding = UDim.new(0, 2)
        
        -- Time label
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = entry
        timeLabel.Size = UDim2.new(1, 0, 0, 14)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.Text = "⏰ " .. clickData.timestamp .. " | 📍 " .. clickData.x .. ", " .. clickData.y
        timeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        timeLabel.TextSize = 10
        timeLabel.TextXAlignment = Enum.TextXAlignment.Left
        timeLabel.ZIndex = 1000
        
        -- 3D target
        if clickData.target3D then
            local targetLabel = Instance.new("TextLabel")
            targetLabel.Parent = entry
            targetLabel.Size = UDim2.new(1, 0, 0, 0)
            targetLabel.BackgroundTransparency = 1
            targetLabel.Font = Enum.Font.Gotham
            targetLabel.Text = "🎯 " .. clickData.target3D.Name
            targetLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            targetLabel.TextSize = 9
            targetLabel.TextXAlignment = Enum.TextXAlignment.Left
            targetLabel.TextWrapped = true
            targetLabel.AutomaticSize = Enum.AutomaticSize.Y
            targetLabel.ZIndex = 1000
        end
        
        -- UI elements
        if #clickData.uiElements > 0 then
            for j, element in ipairs(clickData.uiElements) do
                if j <= 3 then -- Limit to 3 UI elements
                    local uiLabel = Instance.new("TextLabel")
                    uiLabel.Parent = entry
                    uiLabel.Size = UDim2.new(1, 0, 0, 0)
                    uiLabel.BackgroundTransparency = 1
                    uiLabel.Font = Enum.Font.Gotham
                    
                    local text = "🖥️ " .. element.Name
                    if element:IsA("TextLabel") or element:IsA("TextButton") then
                        if element.Text and element.Text ~= "" then
                            text = text .. " (\"" .. element.Text .. "\")"
                        end
                    end
                    
                    uiLabel.Text = text
                    uiLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
                    uiLabel.TextSize = 9
                    uiLabel.TextXAlignment = Enum.TextXAlignment.Left
                    uiLabel.TextWrapped = true
                    uiLabel.AutomaticSize = Enum.AutomaticSize.Y
                    uiLabel.ZIndex = 1000
                end
            end
            
            if #clickData.uiElements > 3 then
                local moreLabel = Instance.new("TextLabel")
                moreLabel.Parent = entry
                moreLabel.Size = UDim2.new(1, 0, 0, 12)
                moreLabel.BackgroundTransparency = 1
                moreLabel.Font = Enum.Font.GothamItalic
                moreLabel.Text = "   +" .. (#clickData.uiElements - 3) .. " more..."
                moreLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                moreLabel.TextSize = 8
                moreLabel.TextXAlignment = Enum.TextXAlignment.Left
                moreLabel.ZIndex = 1000
            end
        end
    end
end

-- Show/Hide log panel
function ClickDebugger:ShowLogPanel()
    if not self.LogPanel then
        self:CreateLogPanel()
    else
        self.LogPanel.Visible = true
    end
end

function ClickDebugger:HideLogPanel()
    if self.LogPanel then
        self.LogPanel.Visible = false
    end
end

function ClickDebugger:ToggleLogPanel()
    if self.LogPanel and self.LogPanel.Visible then
        self:HideLogPanel()
    else
        self:ShowLogPanel()
    end
end

-- Clear history
function ClickDebugger:ClearHistory()
    self.ClickHistory = {}
    if self.LogPanel then
        self:UpdateLogPanel()
    end
    print("[ClickDebugger] History cleared!")
end

-- Enable/Disable
function ClickDebugger:Toggle(state)
    self.Active = state
    
    if state then
        print("[ClickDebugger] Enabled - All clicks will be logged!")
        self:ShowLogPanel()
    else
        print("[ClickDebugger] Disabled")
        self:HideLogPanel()
    end
    
    return state
end

-- Initialize
function ClickDebugger:Init()
    print("[ClickDebugger] Module initialized v" .. self.Version)
    
    -- Setup click detection
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not self.Active then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            self:TrackClick(input)
        end
    end)
    
    return self
end

-- Unload
function ClickDebugger:Unload()
    if self.LogGui then
        self.LogGui:Destroy()
        self.LogGui = nil
    end
    self.Active = false
    print("[ClickDebugger] Module unloaded")
end

return ClickDebugger:Init()
