-- ============================================
-- Select Object Module
-- Tool for selecting and manipulating objects
-- ============================================

local SelectObject = {}
SelectObject.Version = "2.0.0"
SelectObject.Active = false
SelectObject.SelectedObject = nil
SelectObject.Highlight = nil
SelectObject.InfoGui = nil
SelectObject.InfoFrame = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Create info GUI
function SelectObject:CreateInfoGui()
    if self.InfoGui then
        self.InfoGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SelectObjectInfo"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        screenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    self.InfoGui = screenGui
    return screenGui
end

-- Create highlight for selected object
function SelectObject:CreateHighlight(object)
    if self.Highlight then
        self.Highlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.FillColor = Color3.fromRGB(0, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = object
    
    self.Highlight = highlight
    return highlight
end

-- Create property info panel
function SelectObject:CreateInfoPanel(object)
    if not self.InfoGui then
        self:CreateInfoGui()
    end
    
    if self.InfoFrame then
        self.InfoFrame:Destroy()
    end
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "InfoPanel"
    frame.Parent = self.InfoGui
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -10, 0, 10)
    frame.Size = UDim2.new(0, 350, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.Y
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(255, 255, 0)
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
    
    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "📦 Selected Object"
    title.TextColor3 = Color3.fromRGB(255, 255, 0)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Copy button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Name = "CopyButton"
    copyBtn.Parent = header
    copyBtn.AnchorPoint = Vector2.new(1, 0.5)
    copyBtn.Position = UDim2.new(1, -38, 0.5, 0)
    copyBtn.Size = UDim2.new(0, 28, 0, 22)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    copyBtn.BorderSizePixel = 0
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Text = "📋"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 14
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 4)
    copyCorner.Parent = copyBtn
    
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
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
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
    
    -- Get all properties
    local function addProperty(key, value)
        local propFrame = Instance.new("Frame")
        propFrame.Parent = content
        propFrame.Size = UDim2.new(1, 0, 0, 0)
        propFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        propFrame.BorderSizePixel = 0
        propFrame.AutomaticSize = Enum.AutomaticSize.Y
        
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
        keyLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        keyLabel.TextSize = 11
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        
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
    end
    
    -- Add basic properties
    addProperty("Name", object.Name)
    addProperty("ClassName", object.ClassName)
    addProperty("FullName", object:GetFullName())
    addProperty("Parent", object.Parent and object.Parent:GetFullName() or "nil")
    
    -- Add type-specific properties
    if object:IsA("BasePart") then
        addProperty("Position", object.Position)
        addProperty("Size", object.Size)
        addProperty("Rotation", object.Rotation)
        addProperty("Orientation", object.Orientation)
        addProperty("Anchored", object.Anchored)
        addProperty("CanCollide", object.CanCollide)
        addProperty("Transparency", object.Transparency)
        addProperty("Color", object.Color)
        addProperty("Material", object.Material)
        addProperty("CastShadow", object.CastShadow)
    end
    
    if object:IsA("Model") then
        addProperty("PrimaryPart", object.PrimaryPart and object.PrimaryPart.Name or "nil")
    end
    
    -- Button events
    copyBtn.MouseButton1Click:Connect(function()
        local propsText = "=== Object Properties ===\n"
        propsText = propsText .. "Name: " .. object.Name .. "\n"
        propsText = propsText .. "ClassName: " .. object.ClassName .. "\n"
        propsText = propsText .. "FullName: " .. object:GetFullName() .. "\n"
        propsText = propsText .. "Parent: " .. (object.Parent and object.Parent:GetFullName() or "nil") .. "\n"
        
        if object:IsA("BasePart") then
            propsText = propsText .. "\n[BasePart Properties]\n"
            propsText = propsText .. "Position: " .. tostring(object.Position) .. "\n"
            propsText = propsText .. "Size: " .. tostring(object.Size) .. "\n"
            propsText = propsText .. "Rotation: " .. tostring(object.Rotation) .. "\n"
            propsText = propsText .. "Anchored: " .. tostring(object.Anchored) .. "\n"
            propsText = propsText .. "CanCollide: " .. tostring(object.CanCollide) .. "\n"
            propsText = propsText .. "Transparency: " .. tostring(object.Transparency) .. "\n"
        end
        
        setclipboard(propsText)
        print("[SelectObject] Properties copied to clipboard!")
        
        -- Visual feedback
        copyBtn.Text = "✓"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(1)
        copyBtn.Text = "📋"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:ClearSelection()
    end)
    
    self.InfoFrame = frame
    return frame
end

-- Select object under mouse
function SelectObject:SelectUnderMouse()
    local target = Mouse.Target
    
    if target then
        self.SelectedObject = target
        self:CreateHighlight(target)
        self:CreateInfoPanel(target)
        
        print("[SelectObject] Selected:", target:GetFullName())
        print("  Class:", target.ClassName)
        
        return target
    else
        print("[SelectObject] No object under mouse")
        return nil
    end
end

-- Get selected object
function SelectObject:GetSelected()
    return self.SelectedObject
end

-- Clear selection
function SelectObject:ClearSelection()
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
    end
    if self.InfoFrame then
        self.InfoFrame:Destroy()
        self.InfoFrame = nil
    end
    self.SelectedObject = nil
    print("[SelectObject] Selection cleared")
end

-- Delete selected object
function SelectObject:DeleteSelected()
    if self.SelectedObject then
        local name = self.SelectedObject:GetFullName()
        self.SelectedObject:Destroy()
        self:ClearSelection()
        print("[SelectObject] Deleted:", name)
        return true
    else
        warn("[SelectObject] No object selected")
        return false
    end
end

-- Clone selected object
function SelectObject:CloneSelected()
    if self.SelectedObject then
        local clone = self.SelectedObject:Clone()
        clone.Parent = self.SelectedObject.Parent
        print("[SelectObject] Cloned:", self.SelectedObject:GetFullName())
        return clone
    else
        warn("[SelectObject] No object selected")
        return nil
    end
end

-- Get properties of selected object
function SelectObject:GetProperties()
    if not self.SelectedObject then
        warn("[SelectObject] No object selected")
        return nil
    end
    
    local props = {
        Name = self.SelectedObject.Name,
        ClassName = self.SelectedObject.ClassName,
        Parent = self.SelectedObject.Parent and self.SelectedObject.Parent:GetFullName() or "nil",
    }
    
    -- Add part-specific properties
    if self.SelectedObject:IsA("BasePart") then
        props.Position = self.SelectedObject.Position
        props.Size = self.SelectedObject.Size
        props.Rotation = self.SelectedObject.Rotation
        props.Anchored = self.SelectedObject.Anchored
        props.CanCollide = self.SelectedObject.CanCollide
        props.Transparency = self.SelectedObject.Transparency
    end
    
    return props
end

-- Enable/Disable module
function SelectObject:Toggle(state)
    self.Active = state
    
    if not state then
        self:ClearSelection()
    end
    
    print("[SelectObject] " .. (state and "Enabled" or "Disabled"))
    return state
end

-- Initialize module
function SelectObject:Init()
    self:CreateInfoGui()
    print("[SelectObject] Module initialized v" .. self.Version)
    
    -- Setup mouse click detection
    Mouse.Button1Down:Connect(function()
        if self.Active and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            self:SelectUnderMouse()
        end
    end)
    
    return self
end

-- Unload module
function SelectObject:Unload()
    self:ClearSelection()
    if self.InfoGui then
        self.InfoGui:Destroy()
        self.InfoGui = nil
    end
    self.Active = false
    print("[SelectObject] Module unloaded")
end

return SelectObject:Init()
