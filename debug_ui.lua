-- Debug UI Visibility
print("=== UI DEBUG ===")

-- Find the ScreenGui
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Check CoreGui
local CoreGui = game:GetService("CoreGui")
local screenGui = CoreGui:FindFirstChild("NextUIMobile")

if screenGui then
    print("✓ ScreenGui found in CoreGui!")
    print("  Enabled:", screenGui.Enabled)
    print("  ZIndexBehavior:", screenGui.ZIndexBehavior)
    
    -- Find MainFrame
    local mainFrame = screenGui:FindFirstChild("MainFrame")
    if mainFrame then
        print("✓ MainFrame found!")
        print("  Visible:", mainFrame.Visible)
        print("  Position:", mainFrame.Position)
        print("  Size:", mainFrame.Size)
        print("  AnchorPoint:", mainFrame.AnchorPoint)
        
        -- Force show it
        mainFrame.Visible = true
        print("  → Set Visible to true")
        
        -- Check if it's off-screen
        local Camera = workspace.CurrentCamera
        local ViewportSize = Camera.ViewportSize
        print("\nViewport Size:", ViewportSize)
        
        -- Calculate actual pixel position
        local absPos = mainFrame.AbsolutePosition
        local absSize = mainFrame.AbsoluteSize
        print("Absolute Position:", absPos)
        print("Absolute Size:", absSize)
        
        -- Check if window is in viewport
        if absPos.X < 0 or absPos.Y < 0 or 
           absPos.X + absSize.X > ViewportSize.X or 
           absPos.Y + absSize.Y > ViewportSize.Y then
            print("⚠️  Window is OFF SCREEN!")
            print("  Repositioning to center...")
            
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            print("  ✓ Repositioned to center")
        else
            print("✓ Window is IN viewport")
        end
        
    else
        print("✗ MainFrame NOT found!")
        print("Children in ScreenGui:")
        for _, child in ipairs(screenGui:GetChildren()) do
            print("  -", child.Name, child.ClassName)
        end
    end
else
    print("✗ ScreenGui NOT found in CoreGui!")
    
    -- Check PlayerGui
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screenGuiPlayer = PlayerGui:FindFirstChild("NextUIMobile")
    
    if screenGuiPlayer then
        print("✓ Found in PlayerGui instead!")
        print("  Enabled:", screenGuiPlayer.Enabled)
    else
        print("✗ Also NOT in PlayerGui!")
    end
end

print("\n=== DEBUG COMPLETE ===")
