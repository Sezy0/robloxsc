-- ============================================
-- Dev Tools by Sezy - Loader
-- Quick loader for modular dev tools
-- GitHub: https://github.com/Sezy0/robloxsc
-- ============================================

print("Loading Dev Tools by Sezy...")

-- Load main init file
local DevTools = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/init.lua"))()

-- Initialize all modules
DevTools:Init()

-- Example usage:
local SelectObject = DevTools:GetModule("select_object")

if SelectObject then
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  Dev Tools Ready!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("\nAvailable Modules:")
    for name, module in pairs(DevTools.Modules) do
        print("  •", name, "- v" .. (module.Version or "1.0.0"))
    end
    
    print("\nQuick Start:")
    print("  • SelectObject:Toggle(true)  - Enable object selection")
    print("  • Ctrl + Click - Select object under mouse")
    print("  • SelectObject:DeleteSelected() - Delete selected")
    print("  • SelectObject:CloneSelected() - Clone selected")
    print("\nAccess modules with:")
    print("  local module = DevTools:GetModule('module_name')")
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
end

-- Return DevTools for scripting
return DevTools
