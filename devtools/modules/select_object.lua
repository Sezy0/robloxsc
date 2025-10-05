-- ============================================
-- Select Object Module
-- Tool for selecting and manipulating objects
-- ============================================

local SelectObject = {}
SelectObject.Version = "1.0.0"
SelectObject.Active = false
SelectObject.SelectedObject = nil
SelectObject.Highlight = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Create highlight for selected object
function SelectObject:CreateHighlight(object)
    if self.Highlight then
        self.Highlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = object
    
    self.Highlight = highlight
    return highlight
end

-- Select object under mouse
function SelectObject:SelectUnderMouse()
    local target = Mouse.Target
    
    if target then
        self.SelectedObject = target
        self:CreateHighlight(target)
        
        print("[SelectObject] Selected:", target:GetFullName())
        print("  Class:", target.ClassName)
        print("  Position:", target.Position)
        
        if target:IsA("BasePart") then
            print("  Size:", target.Size)
            print("  Transparency:", target.Transparency)
        end
        
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
    self.Active = false
    print("[SelectObject] Module unloaded")
end

return SelectObject:Init()
