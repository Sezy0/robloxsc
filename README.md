# 🛠️ Dev Tools by Sezy

Modular Roblox development tools with NextUI Mobile Compact integration.

## 🚀 Quick Start

### Method 1: Load with Full UI Example
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/example.lua"))()
```

### Method 2: Load Basic (No UI)
```lua
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/loader.lua"))()
```

## 📦 Features

- ✅ **Modular Architecture** - Load only what you need
- ✅ **NextUI Mobile Compact** - Beautiful mobile-optimized UI from [LIBui](https://github.com/Sezy0/LIBui)
- ✅ **Object Selection Tool** - Ctrl+Click to select and manipulate objects
- ✅ **Teleportation System** - Quick teleport utilities
- ✅ **ESP Module** - Extra Sensory Perception (placeholder)
- ✅ **Helper Utilities** - Common functions for development

## 🎯 Available Modules

### UI Manager
```lua
local UIManager = DevTools:GetModule("ui_manager")
local Window = UIManager:QuickSetup("My Tool")
UIManager:Notify("Title", "Message", 3)
```

### Select Object
```lua
local SelectObject = DevTools:GetModule("select_object")
SelectObject:Toggle(true)
SelectObject:DeleteSelected()
SelectObject:CloneSelected()
```

### Teleport
```lua
local Teleport = DevTools:GetModule("teleport")
Teleport:ToPosition(Vector3.new(0, 10, 0))
Teleport:ToPlayer("PlayerName")
```

## 📚 Documentation

See `devtools/README.md` for complete documentation.

## 🎨 NextUI Integration

Uses [NextUI Mobile Compact](https://github.com/Sezy0/LIBui) for UI:
- 📱 Mobile-optimized square layout
- 💻 Desktop compatible
- 🎨 Monochrome grayscale theme
- 🖱️ Draggable with minimize/restore
- 📍 iPhone-style home bar

## 👤 Author

**Sezy**
- GitHub: [@Sezy0](https://github.com/Sezy0)
- Repository: [robloxsc](https://github.com/Sezy0/robloxsc)
- UI Library: [LIBui](https://github.com/Sezy0/LIBui)

---

Made with ❤️ by Sezy
