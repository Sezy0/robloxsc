-- ============================================
-- ESP Module
-- Extra Sensory Perception for players/objects
-- ============================================

local ESP = {}
ESP.Version = "1.0.0"
ESP.Enabled = false
ESP.Connections = {}

function ESP:Init()
    print("[ESP] Initialized")
    return self
end

function ESP:Toggle(state)
    self.Enabled = state
    
    if state then
        print("[ESP] Enabled")
        -- TODO: Implement ESP logic
    else
        print("[ESP] Disabled")
        self:Clear()
    end
end

function ESP:Clear()
    -- Clear all ESP connections
    for _, conn in pairs(self.Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    self.Connections = {}
end

function ESP:Unload()
    print("[ESP] Unloaded")
    self:Clear()
end

return ESP:Init()
