# 🛠️ Dev Tools by Sezy

Modular Roblox development tools for efficient scripting and debugging.

## 📦 Features

- **Modular Architecture** - Each tool is a separate module
- **Easy to Maintain** - Update individual features without breaking others
- **GitHub Integration** - Load directly from GitHub
- **Extensible** - Easy to add new modules

## 🚀 Quick Start

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/loader.lua"))()
```

## 📁 Project Structure

```
robloxsc/
├── init.lua              # Main entry point & module loader
├── loader.lua            # Quick loader script
├── modules/              # Individual tool modules
│   ├── select_object.lua # Object selection tool
│   ├── esp.lua          # ESP module
│   ├── teleport.lua     # Teleportation tool
│   └── ui_manager.lua   # UI management
├── utils/                # Helper functions
│   └── helpers.lua      # Common utilities
└── config/               # Configuration files
```

## 🎯 Available Modules

### Select Object
Interactive object selection and manipulation tool.

```lua
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/init.lua"))()
DevTools:Init()

local SelectObject = DevTools:GetModule("select_object")

-- Enable selection mode
SelectObject:Toggle(true)

-- Hold Ctrl + Click to select object
-- Then use these methods:

SelectObject:GetSelected()         -- Get currently selected object
SelectObject:DeleteSelected()      -- Delete selected object
SelectObject:CloneSelected()       -- Clone selected object
SelectObject:GetProperties()       -- Get object properties
SelectObject:ClearSelection()      -- Clear selection
```

## 📚 Documentation

### DevTools API

```lua
-- Initialize
DevTools:Init()

-- Load specific module
local module = DevTools:LoadModule("module_name")

-- Get loaded module
local module = DevTools:GetModule("module_name")

-- Unload all modules
DevTools:Unload()
```

### Utils/Helpers API

```lua
local Helpers = DevTools.Utils

-- Distance calculation
Helpers:GetDistance(pos1, pos2)

-- Player utilities
Helpers:GetCharacter(player)
Helpers:GetRootPart(player)
Helpers:GetPlayersInRange(position, range)

-- Tweening
Helpers:Tween(object, properties, duration)

-- Number formatting
Helpers:FormatNumber(1000000)  -- "1,000,000"
Helpers:Round(3.14159, 2)      -- 3.14

-- Object utilities
Helpers:GetDescendantsOfClass(parent, className)
Helpers:WaitForChild(parent, childName, timeout)
```

## 🔧 Development

### Adding New Modules

1. Create new file in `modules/` folder
2. Follow this template:

```lua
local MyModule = {}
MyModule.Version = "1.0.0"

function MyModule:Init()
    print("[MyModule] Initialized")
    return self
end

function MyModule:Unload()
    print("[MyModule] Unloaded")
end

return MyModule:Init()
```

3. Add module name to `init.lua` modulesToLoad array
4. Push to GitHub

### Module Guidelines

- ✅ Use `self:` for methods
- ✅ Include `:Init()` and `:Unload()` functions
- ✅ Add `Version` property
- ✅ Use `DevTools.Utils` for common functions
- ✅ Print initialization status
- ✅ Handle errors gracefully

## 📝 Examples

### Basic Usage

```lua
-- Load and initialize
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/loader.lua"))()

-- Access modules
local SelectObject = DevTools:GetModule("select_object")
SelectObject:Toggle(true)
```

### Custom Module Loading

```lua
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/init.lua"))()
DevTools:Init()

-- Load additional custom module
local CustomModule = DevTools:LoadModule("custom_module")
```

## 🔄 Updates

This project is actively maintained. Each module can be updated independently without breaking existing functionality.

## 📄 License

MIT License - Feel free to use and modify!

## 👤 Author

**Sezy**
- GitHub: [@Sezy0](https://github.com/Sezy0)

## 🤝 Contributing

Contributions welcome! Feel free to:
1. Fork the repository
2. Create your feature branch
3. Add your module
4. Submit a pull request

---

Made with ❤️ by Sezy
