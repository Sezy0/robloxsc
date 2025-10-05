-- ============================================
-- Commands Module
-- Chat-based command system with prefix
-- ============================================

local Commands = {}
Commands.Version = "1.0.0"
Commands.Prefix = "."
Commands.CommandList = {}
Commands.DevTools = nil

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

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
