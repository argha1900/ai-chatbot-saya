-- ========================================
-- ROBLOX STUDIO LITE - AURA FARMING SCRIPT (SIMPLE VERSION)
-- ========================================
-- Script simple yang langsung jalan tanpa ribet!

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local player = Players.LocalPlayer

-- Animation IDs
local ANIMATION_IDS = {
    AURA_FARMING = "rbxassetid://507770239",
    MEDITATION = "rbxassetid://507770677",
    POWER_CHARGE = "rbxassetid://507770239",
    ENERGY_BURST = "rbxassetid://507770677",
    SPIRIT_FORM = "rbxassetid://507770239",
    LIGHTNING = "rbxassetid://507770677",
    FIRE_AURA = "rbxassetid://507770239",
    ICE_AURA = "rbxassetid://507770677",
    DARK_AURA = "rbxassetid://507770239",
    HOLY_AURA = "rbxassetid://507770677"
}

-- Animation List
local animationList = {
    "Aura Farming",
    "Meditation",
    "Power Charge", 
    "Energy Burst",
    "Spirit Form",
    "Lightning Aura",
    "Fire Aura",
    "Ice Aura",
    "Dark Aura",
    "Holy Aura"
}

-- Current animation
local currentAnimationTrack = nil
local isAnimating = false

-- ========================================
-- SIMPLE FUNCTIONS
-- ========================================

-- Play Animation
function playAnimation(animationName)
    print("🎭 Playing: " .. animationName)
    
    -- Get character
    local character = player.Character
    if not character then
        print("❌ No character!")
        return
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        print("❌ No humanoid!")
        return
    end
    
    -- Stop current animation
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
    end
    
    -- Get animation ID
    local animationId = ANIMATION_IDS.AURA_FARMING -- Default
    
    for name, id in pairs(ANIMATION_IDS) do
        if name:gsub("_", " "):lower() == animationName:lower() then
            animationId = id
            break
        end
    end
    
    -- Create and play animation
    local animation = Instance.new("Animation")
    animation.AnimationId = animationId
    
    currentAnimationTrack = humanoid:LoadAnimation(animation)
    currentAnimationTrack:Play()
    
    isAnimating = true
    print("✅ Animation playing!")
end

-- Stop Animation
function stopAnimation()
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
    isAnimating = false
    print("⏹️ Animation stopped!")
end

-- ========================================
-- SIMPLE UI
-- ========================================

-- Create Simple UI
local function createUI()
    -- Wait for PlayerGui
    repeat wait() until player.PlayerGui
    
    -- Remove old UI
    if player.PlayerGui:FindFirstChild("AuraFarmingUI") then
        player.PlayerGui.AuraFarmingUI:Destroy()
    end
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraFarmingUI"
    screenGui.Parent = player.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "🌟 AURA FARMING 🌟"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Title corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Create buttons
    for i, animationName in ipairs(animationList) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = UDim2.new(0, 10, 0, 50 + (i-1) * 35)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderSizePixel = 0
        button.Text = animationName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = mainFrame
        
        -- Button corner
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = button
        
        -- Click event
        button.MouseButton1Click:Connect(function()
            playAnimation(animationName)
        end)
    end
    
    -- Stop button
    local stopButton = Instance.new("TextButton")
    stopButton.Size = UDim2.new(1, -20, 0, 40)
    stopButton.Position = UDim2.new(0, 10, 0, 350)
    stopButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    stopButton.BorderSizePixel = 0
    stopButton.Text = "⏹️ STOP ANIMATION"
    stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopButton.TextScaled = true
    stopButton.Font = Enum.Font.GothamBold
    stopButton.Parent = mainFrame
    
    -- Stop button corner
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 5)
    stopCorner.Parent = stopButton
    
    -- Stop click event
    stopButton.MouseButton1Click:Connect(function()
        stopAnimation()
    end)
    
    print("✅ UI Created!")
end

-- ========================================
-- KEYBOARD SHORTCUTS
-- ========================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        playAnimation("Aura Farming")
    elseif input.KeyCode == Enum.KeyCode.E then
        playAnimation("Meditation")
    elseif input.KeyCode == Enum.KeyCode.R then
        local randomAnimation = animationList[math.random(1, #animationList)]
        playAnimation(randomAnimation)
    elseif input.KeyCode == Enum.KeyCode.T then
        stopAnimation()
    end
end)

-- ========================================
-- START
-- ========================================

-- Create UI
createUI()

-- Print info
print("🌟 AURA FARMING SYSTEM LOADED! 🌟")
print("⌨️ Keyboard Shortcuts:")
print("  Q - Aura Farming")
print("  E - Meditation")
print("  R - Random Animation")
print("  T - Stop Animation")
print("✅ Ready to use!")

-- ========================================
-- END
-- ========================================