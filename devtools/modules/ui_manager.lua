-- ============================================
-- UI Manager Module
-- Uses NextUI Mobile Compact from LIBui
-- ============================================

local UIManager = {}
UIManager.Version = "1.0.0"
UIManager.NextUI = nil
UIManager.Window = nil
UIManager.Authenticated = false

-- NextUI GitHub URL
local NEXTUI_URL = "https://raw.githubusercontent.com/Sezy0/LIBui/main/nextjs_mobile_compact/init.lua"

function UIManager:Init()
    print("[UIManager] Initializing...")
    
    -- Load NextUI Mobile Compact
    local success, result = pcall(function()
        return loadstring(game:HttpGet(NEXTUI_URL))()
    end)
    
    if success and result then
        self.NextUI = result
        print("[UIManager] ✓ NextUI Mobile Compact loaded!")
        return self
    else
        warn("[UIManager] ✗ Failed to load NextUI")
        warn("    Error: " .. tostring(result))
        return nil
    end
end

-- Authenticate (bypass by default for dev tools)
function UIManager:Auth(config)
    config = config or {}
    config.UseKeySystem = config.UseKeySystem or false
    
    if not self.NextUI then
        warn("[UIManager] NextUI not loaded!")
        return false
    end
    
    if not config.UseKeySystem then
        -- Bypass authentication
        self.NextUI:Auth({
            UseKeySystem = false,
            OnSuccess = function()
                self.Authenticated = true
                print("[UIManager] ✓ Authenticated!")
            end
        })
        return true
    else
        -- Use key system
        self.NextUI:Auth(config)
        return true
    end
end

-- Create main window
function UIManager:CreateWindow(config)
    if not self.Authenticated then
        warn("[UIManager] Please authenticate first!")
        return nil
    end
    
    config = config or {}
    config.Title = config.Title or "Dev Tools by Sezy"
    
    self.Window = self.NextUI:Window(config)
    print("[UIManager] ✓ Window created!")
    
    return self.Window
end

-- Quick setup (auth + window)
function UIManager:QuickSetup(windowTitle)
    self:Auth()
    
    -- Wait a bit for auth to complete
    task.wait(0.1)
    
    return self:CreateWindow({
        Title = windowTitle or "Dev Tools by Sezy"
    })
end

-- Send notification
function UIManager:Notify(title, message, duration)
    if self.NextUI then
        self.NextUI:Notification(title, message, duration)
    else
        warn("[UIManager] NextUI not loaded, cannot send notification")
    end
end

function UIManager:Unload()
    print("[UIManager] Unloaded")
    self.Window = nil
    self.NextUI = nil
    self.Authenticated = false
end

return UIManager:Init()
