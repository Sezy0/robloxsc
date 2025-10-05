-- Simple Test Script
print("=== STARTING TEST ===")

-- Test 1: Load init.lua
print("\n[TEST 1] Loading init.lua...")
local success1, DevTools = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Sezy0/robloxsc/main/devtools/init.lua"))()
end)

if not success1 then
    warn("[TEST 1 FAILED]", DevTools)
    return
end
print("[TEST 1 PASSED] Init loaded!")

-- Test 2: Load Utils
print("\n[TEST 2] Loading utils...")
local success2, result2 = pcall(function()
    return DevTools:LoadUtils()
end)

if not success2 then
    warn("[TEST 2 FAILED]", result2)
else
    print("[TEST 2 PASSED] Utils loaded!")
end

-- Test 3: Load select_object module
print("\n[TEST 3] Loading select_object...")
local success3, result3 = pcall(function()
    return DevTools:LoadModule("select_object")
end)

if not success3 then
    warn("[TEST 3 FAILED]", result3)
else
    print("[TEST 3 PASSED] select_object loaded!")
end

-- Test 4: Load ui_manager module
print("\n[TEST 4] Loading ui_manager...")
local success4, result4 = pcall(function()
    return DevTools:LoadModule("ui_manager")
end)

if not success4 then
    warn("[TEST 4 FAILED]", result4)
else
    print("[TEST 4 PASSED] ui_manager loaded!")
end

-- Test 5: Try to create UI
print("\n[TEST 5] Creating UI...")
local UIManager = DevTools:GetModule("ui_manager")

if not UIManager then
    warn("[TEST 5 FAILED] UIManager not found!")
    return
end

print("[TEST 5] UIManager found, authenticating...")
local success5, result5 = pcall(function()
    UIManager:Auth()
end)

if not success5 then
    warn("[TEST 5 FAILED]", result5)
    return
end

print("[TEST 5] Authenticated, waiting 0.5s...")
task.wait(0.5)

print("[TEST 5] Creating window...")
local success6, Window = pcall(function()
    return UIManager:CreateWindow({
        Title = "Test Window"
    })
end)

if not success6 then
    warn("[TEST 5 FAILED]", Window)
    return
end

if Window then
    print("[TEST 5 PASSED] Window created!")
    
    -- Create a test tab
    local Tab = Window:Tab("Test", "🧪")
    local Section = Tab:Section("Test Section")
    Section:Label("If you see this, it works!")
    Section:Button("Click Me", function()
        print("Button clicked!")
    end)
else
    warn("[TEST 5 FAILED] Window is nil!")
end

print("\n=== TEST COMPLETE ===")
