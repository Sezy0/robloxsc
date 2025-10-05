-- ============================================
-- UI Inspector Module
-- Inspect and interact with UI elements
-- ============================================

local UIInspector = {}
UIInspector.Version = "1.0.0"
UIInspector.Active = false
UIInspector.SelectedElement = nil
UIInspector.Highlight = nil
UIInspector.InfoGui = nil
UIInspector.InfoPanel = nil
UIInspector.BlockerFrame = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Create click blocker overlay
function UIInspector:CreateBlocker()
    if self.BlockerFrame then
        self.BlockerFrame:Destroy()
    end
    
    if not self.InfoGui then
        return
    end
    
    local blocker = Instance.new("Frame")
    blocker.Name = "ClickBlocker"
    blocker.Parent = self.InfoGui
    blocker.Position = UDim2.new(0, 0, 0, 0)
    blocker.Size = UDim2.new(1, 0, 1, 0)
    blocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blocker.BackgroundTransparency = 0.5
    blocker.BorderSizePixel = 0
    blocker.ZIndex = 500
    blocker.Active = true
    
    -- Add hint text
    local hint = Instance.new("TextLabel")
    hint.Parent = blocker
    hint.AnchorPoint = Vector2.new(0.5, 0.5)
    hint.Position = UDim2.new(0.5, 0, 0.5, 0)
    hint.Size = UDim2.new(0, 400, 0, 100)
    hint.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    hint.BackgroundTransparency = 0.3
    hint.BorderSizePixel = 0
    hint.Font = Enum.Font.GothamBold
    hint.Text = "🔍 UI INSPECTOR MODE\n\nAlt + Click to inspect UI elements\nClick here to cancel"
    hint.TextColor3 = Color3.fromRGB(0, 255, 255)
    hint.TextSize = 14
    hint.TextWrapped = true
    hint.ZIndex = 501
    
    local hintCorner = Instance.new("UICorner")
    hintCorner.CornerRadius = UDim.new(0, 10)
    hintCorner.Parent = hint
    
    -- Click blocker to close inspector mode
    blocker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            -- Check if not holding Alt
            if not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                self:Toggle(false)
            end
        end
    end)
    
    self.BlockerFrame = blocker
    return blocker
end

-- Remove blocker
function UIInspector:RemoveBlocker()
    if self.BlockerFrame then
        self.BlockerFrame:Destroy()
        self.BlockerFrame = nil
    end
end

-- Create info GUI container
function UIInspector:CreateInfoGui()
    if self.InfoGui then
        self.InfoGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UIInspectorInfo"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        screenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    self.InfoGui = screenGui
    return screenGui
end

-- Create highlight for selected UI element
function UIInspector:CreateHighlight(element)
    if self.Highlight then
        self.Highlight:Destroy()
    end
    
    if not element:IsA("GuiObject") then
        return
    end
    
    local highlight = Instance.new("Frame")
    highlight.Name = "UIHighlight"
    highlight.Parent = self.InfoGui
    highlight.BackgroundTransparency = 0.7
    highlight.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    highlight.BorderSizePixel = 2
    highlight.BorderColor3 = Color3.fromRGB(255, 255, 0)
    highlight.ZIndex = 600
    highlight.Active = false
    
    -- Update position/size in real-time
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not element or not element.Parent then
            if connection then connection:Disconnect() end
            if highlight then highlight:Destroy() end
            return
        end
        
        highlight.Position = UDim2.new(0, element.AbsolutePosition.X, 0, element.AbsolutePosition.Y)
        highlight.Size = UDim2.new(0, element.AbsoluteSize.X, 0, element.AbsoluteSize.Y)
    end)
    
    self.Highlight = highlight
    return highlight
end

-- Get UI element under mouse
function UIInspector:GetElementUnderMouse()
    local guis = Player.PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
    
    -- Also check CoreGui if accessible
    local success, coreGuis = pcall(function()
        return game:GetService("CoreGui"):GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
    end)
    
    if success and coreGuis then
        for _, gui in ipairs(coreGuis) do
            table.insert(guis, gui)
        end
    end
    
    -- Filter out our own GUIs
    for i = #guis, 1, -1 do
        local gui = guis[i]
        if gui:IsDescendantOf(self.InfoGui) or 
           (gui.Parent and (gui.Parent.Name == "UIInspectorInfo" or gui.Parent.Name == "SelectObjectInfo")) then
            table.remove(guis, i)
        end
    end
    
    return guis[1] -- Return topmost element
end

-- Create info panel for selected element
function UIInspector:CreateInfoPanel(element)
    if not self.InfoGui then
        self:CreateInfoGui()
    end
    
    if self.InfoPanel then
        self.InfoPanel:Destroy()
    end
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "UIInfoPanel"
    frame.Parent = self.InfoGui
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -10, 0, 10)
    frame.Size = UDim2.new(0, 350, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.ZIndex = 1500
    frame.Active = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- Header (draggable)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = frame
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 1500
    
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
    title.Size = UDim2.new(1, -110, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "🔍 UI Inspector"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 1000
    
    -- Action buttons
    local autoClickBtn = Instance.new("TextButton")
    autoClickBtn.Name = "AutoClick"
    autoClickBtn.Parent = header
    autoClickBtn.AnchorPoint = Vector2.new(1, 0.5)
    autoClickBtn.Position = UDim2.new(1, -42, 0.5, 0)
    autoClickBtn.Size = UDim2.new(0, 32, 0, 22)
    autoClickBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    autoClickBtn.BorderSizePixel = 0
    autoClickBtn.Font = Enum.Font.GothamBold
    autoClickBtn.Text = "▶"
    autoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoClickBtn.TextSize = 14
    autoClickBtn.ZIndex = 1000
    
    local autoClickCorner = Instance.new("UICorner")
    autoClickCorner.CornerRadius = UDim.new(0, 4)
    autoClickCorner.Parent = autoClickBtn
    
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
    
    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Parent = frame
    content.Position = UDim2.new(0, 0, 0, 35)
    content.Size = UDim2.new(1, 0, 0, 400)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ZIndex = 1000
    
    local padding = Instance.new("UIPadding")
    padding.Parent = content
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    -- Helper function to add property
    local function addProperty(key, value)
        local propFrame = Instance.new("Frame")
        propFrame.Parent = content
        propFrame.Size = UDim2.new(1, 0, 0, 0)
        propFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        propFrame.BorderSizePixel = 0
        propFrame.AutomaticSize = Enum.AutomaticSize.Y
        propFrame.ZIndex = 1000
        
        local propCorner = Instance.new("UICorner")
        propCorner.CornerRadius = UDim.new(0, 4)
        propCorner.Parent = propFrame
        
        local propPadding = Instance.new("UIPadding")
        propPadding.Parent = propFrame
        propPadding.PaddingTop = UDim.new(0, 5)
        propPadding.PaddingBottom = UDim.new(0, 5)
        propPadding.PaddingLeft = UDim.new(0, 8)
        propPadding.PaddingRight = UDim.new(0, 8)
        
        local propLayout = Instance.new("UIListLayout")
        propLayout.Parent = propFrame
        propLayout.SortOrder = Enum.SortOrder.LayoutOrder
        propLayout.Padding = UDim.new(0, 2)
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = propFrame
        keyLabel.Size = UDim2.new(1, 0, 0, 16)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.Text = key
        keyLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        keyLabel.TextSize = 11
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.ZIndex = 1000
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = propFrame
        valueLabel.Size = UDim2.new(1, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Text = tostring(value)
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.TextSize = 10
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextWrapped = true
        valueLabel.AutomaticSize = Enum.AutomaticSize.Y
        valueLabel.ZIndex = 1000
    end
    
    -- Add properties
    addProperty("Name", element.Name)
    addProperty("ClassName", element.ClassName)
    addProperty("FullName", element:GetFullName())
    
    -- UI-specific properties
    if element:IsA("GuiObject") then
        addProperty("Visible", element.Visible)
        addProperty("Position", element.Position)
        addProperty("Size", element.Size)
        addProperty("AbsolutePosition", element.AbsolutePosition)
        addProperty("AbsoluteSize", element.AbsoluteSize)
        addProperty("ZIndex", element.ZIndex)
    end
    
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        addProperty("Text", element.Text)
        addProperty("TextColor3", element.TextColor3)
        addProperty("TextSize", element.TextSize)
    end
    
    if element:IsA("ImageLabel") or element:IsA("ImageButton") then
        addProperty("Image", element.Image)
        addProperty("ImageColor3", element.ImageColor3)
    end
    
    if element:IsA("Frame") then
        addProperty("BackgroundColor3", element.BackgroundColor3)
        addProperty("BackgroundTransparency", element.BackgroundTransparency)
    end
    
    -- Auto-click button functionality
    autoClickBtn.MouseButton1Click:Connect(function()
        if element:IsA("GuiButton") then
            -- Simulate click
            for _, connection in pairs(getconnections(element.MouseButton1Click)) do
                connection:Fire()
            end
            print("[UIInspector] Auto-clicked:", element:GetFullName())
            autoClickBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            task.wait(0.2)
            autoClickBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        else
            warn("[UIInspector] Element is not clickable!")
        end
    end)
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        self:ClearSelection()
    end)
    
    self.InfoPanel = frame
    return frame
end

-- Select UI element under mouse
function UIInspector:SelectUnderMouse()
    local element = self:GetElementUnderMouse()
    
    if element then
        self.SelectedElement = element
        self:CreateHighlight(element)
        self:CreateInfoPanel(element)
        
        print("[UIInspector] Selected:", element:GetFullName())
        print("  Class:", element.ClassName)
        
        return element
    else
        print("[UIInspector] No UI element under mouse")
        return nil
    end
end

-- Clear selection
function UIInspector:ClearSelection()
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
    end
    if self.InfoPanel then
        self.InfoPanel:Destroy()
        self.InfoPanel = nil
    end
    self.SelectedElement = nil
    print("[UIInspector] Selection cleared")
end

-- Get selected element
function UIInspector:GetSelected()
    return self.SelectedElement
end

-- Auto-click selected element
function UIInspector:ClickSelected()
    if self.SelectedElement and self.SelectedElement:IsA("GuiButton") then
        for _, connection in pairs(getconnections(self.SelectedElement.MouseButton1Click)) do
            connection:Fire()
        end
        print("[UIInspector] Clicked:", self.SelectedElement:GetFullName())
        return true
    else
        warn("[UIInspector] No clickable element selected!")
        return false
    end
end

-- Enable/Disable module
function UIInspector:Toggle(state)
    self.Active = state
    
    if state then
        -- Enable: Create blocker
        self:CreateBlocker()
        print("[UIInspector] Enabled - Alt+Click to inspect, Click blocker to cancel")
    else
        -- Disable: Remove blocker and clear selection
        self:RemoveBlocker()
        self:ClearSelection()
        print("[UIInspector] Disabled")
    end
    
    return state
end

-- Initialize module
function UIInspector:Init()
    print("[UIInspector] Module initialized v" .. self.Version)
    
    self:CreateInfoGui()
    
    -- Setup mouse click detection
    Mouse.Button1Down:Connect(function()
        if self.Active and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
            self:SelectUnderMouse()
        end
    end)
    
    return self
end

-- Unload module
function UIInspector:Unload()
    self:RemoveBlocker()
    self:ClearSelection()
    if self.InfoGui then
        self.InfoGui:Destroy()
        self.InfoGui = nil
    end
    self.Active = false
    print("[UIInspector] Module unloaded")
end

return UIInspector:Init()
