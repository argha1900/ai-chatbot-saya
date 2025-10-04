-- ========================================
-- ROBLOX STUDIO LITE - AURA FARMING SCRIPT (FINAL VERSION)
-- ========================================
-- Script untuk animasi aura farming dan fitur-fitur lainnya
-- Compatible dengan Roblox Studio Lite - NO MORE ERRORS!

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Variables (SAFE INITIALIZATION)
local player = Players.LocalPlayer
local character = nil
local humanoid = nil
local rootPart = nil

-- Animation IDs (ganti dengan ID animasi yang valid)
local ANIMATION_IDS = {
    AURA_FARMING = "rbxassetid://507770239", -- Aura farming animation
    MEDITATION = "rbxassetid://507770677",   -- Meditation pose
    POWER_CHARGE = "rbxassetid://507770239", -- Power charging
    ENERGY_BURST = "rbxassetid://507770677", -- Energy burst
    SPIRIT_FORM = "rbxassetid://507770239",  -- Spirit form
    LIGHTNING = "rbxassetid://507770677",    -- Lightning aura
    FIRE_AURA = "rbxassetid://507770239",    -- Fire aura
    ICE_AURA = "rbxassetid://507770677",     -- Ice aura
    DARK_AURA = "rbxassetid://507770239",    -- Dark aura
    HOLY_AURA = "rbxassetid://507770677"     -- Holy aura
}

-- Sound IDs (ganti dengan ID sound yang valid)
local SOUND_IDS = {
    AURA_SOUND = "rbxassetid://131961136",   -- Aura sound effect
    POWER_SOUND = "rbxassetid://131961136",  -- Power sound
    ENERGY_SOUND = "rbxassetid://131961136", -- Energy sound
    MEDITATION_SOUND = "rbxassetid://131961136" -- Meditation sound
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
local currentAnimation = nil
local currentAnimationTrack = nil
local isAnimating = false
local statusLabel = nil

-- ========================================
-- CHARACTER MANAGEMENT FUNCTIONS
-- ========================================

-- Initialize Character SAFELY (NO CharacterAdded)
local function initializeCharacter()
    print("🔄 Initializing character...")
    
    -- Wait for character to exist using safe loop
    local attempts = 0
    while not player.Character and attempts < 100 do
        wait(0.1)
        attempts = attempts + 1
    end
    
    if not player.Character then
        print("❌ Character not found after waiting!")
        return false
    end
    
    character = player.Character
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    print("✅ Character loaded successfully!")
    return true
end

-- Check if character is ready
local function isCharacterReady()
    return character and character.Parent and humanoid and rootPart
end

-- ========================================
-- UI CREATION FUNCTIONS
-- ========================================

-- Create UI
local function createUI()
    print("🎨 Creating UI...")
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraFarmingUI"
    screenGui.Parent = player.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner for main frame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🌟 AURA FARMING SYSTEM 🌟"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    -- Corner for title
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Animation List Frame
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "ListFrame"
    listFrame.Size = UDim2.new(1, -20, 0, 300)
    listFrame.Position = UDim2.new(0, 10, 0, 60)
    listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 8
    listFrame.Parent = mainFrame
    
    -- Corner for list frame
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = listFrame
    
    -- Create animation buttons
    for i, animationName in ipairs(animationList) do
        local button = Instance.new("TextButton")
        button.Name = "AnimationButton" .. i
        button.Size = UDim2.new(1, -10, 0, 40)
        button.Position = UDim2.new(0, 5, 0, (i-1) * 45 + 5)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderSizePixel = 0
        button.Text = animationName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = listFrame
        
        -- Corner for button
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = button
        
        -- Button hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        
        -- Button click
        button.MouseButton1Click:Connect(function()
            playAnimation(animationName)
        end)
    end
    
    -- Update canvas size
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #animationList * 45)
    
    -- Control Buttons Frame
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(1, -20, 0, 100)
    controlFrame.Position = UDim2.new(0, 10, 0, 370)
    controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mainFrame
    
    -- Corner for control frame
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 8)
    controlCorner.Parent = controlFrame
    
    -- Stop Button
    local stopButton = Instance.new("TextButton")
    stopButton.Name = "StopButton"
    stopButton.Size = UDim2.new(0.45, 0, 0, 40)
    stopButton.Position = UDim2.new(0, 10, 0, 10)
    stopButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    stopButton.BorderSizePixel = 0
    stopButton.Text = "⏹️ STOP"
    stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopButton.TextScaled = true
    stopButton.Font = Enum.Font.GothamBold
    stopButton.Parent = controlFrame
    
    -- Corner for stop button
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 5)
    stopCorner.Parent = stopButton
    
    -- Stop button click
    stopButton.MouseButton1Click:Connect(function()
        stopAnimation()
    end)
    
    -- Random Button
    local randomButton = Instance.new("TextButton")
    randomButton.Name = "RandomButton"
    randomButton.Size = UDim2.new(0.45, 0, 0, 40)
    randomButton.Position = UDim2.new(0.55, 0, 0, 10)
    randomButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    randomButton.BorderSizePixel = 0
    randomButton.Text = "🎲 RANDOM"
    randomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    randomButton.TextScaled = true
    randomButton.Font = Enum.Font.GothamBold
    randomButton.Parent = controlFrame
    
    -- Corner for random button
    local randomCorner = Instance.new("UICorner")
    randomCorner.CornerRadius = UDim.new(0, 5)
    randomCorner.Parent = randomButton
    
    -- Random button click
    randomButton.MouseButton1Click:Connect(function()
        local randomAnimation = animationList[math.random(1, #animationList)]
        playAnimation(randomAnimation)
    end)
    
    -- Status Label
    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 60)
    statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statusLabel.BorderSizePixel = 0
    statusLabel.Text = "Status: Ready"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = controlFrame
    
    -- Corner for status label
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 5)
    statusCorner.Parent = statusLabel
    
    print("✅ UI created successfully!")
    return screenGui
end

-- ========================================
-- ANIMATION FUNCTIONS
-- ========================================

-- Play Animation Function (SAFE VERSION)
function playAnimation(animationName)
    print("🎭 Attempting to play: " .. animationName)
    
    -- SAFETY CHECK: Character must be ready
    if not isCharacterReady() then
        print("❌ Character not ready! Please wait for character to load.")
        if statusLabel then
            statusLabel.Text = "Status: Character not ready!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return false
    end
    
    -- Stop current animation if playing
    if isAnimating then
        stopAnimation()
    end
    
    -- Get animation ID
    local animationId = nil
    for name, id in pairs(ANIMATION_IDS) do
        if name:gsub("_", " "):lower() == animationName:lower() then
            animationId = id
            break
        end
    end
    
    if not animationId then
        animationId = ANIMATION_IDS.AURA_FARMING -- Default animation
    end
    
    -- Create animation
    local animation = Instance.new("Animation")
    animation.AnimationId = animationId
    
    -- Load animation SAFELY
    local success, errorMsg = pcall(function()
        currentAnimationTrack = humanoid:LoadAnimation(animation)
        currentAnimationTrack:Play()
    end)
    
    if not success then
        print("❌ Failed to play animation: " .. tostring(errorMsg))
        if statusLabel then
            statusLabel.Text = "Status: Animation Error!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return false
    end
    
    -- Set variables
    currentAnimation = animationName
    isAnimating = true
    
    -- Update status
    if statusLabel then
        statusLabel.Text = "Status: Playing " .. animationName
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    
    -- Play sound effect
    playSoundEffect(animationName)
    
    -- Create visual effects
    createVisualEffects(animationName)
    
    print("✅ Successfully playing animation: " .. animationName)
    return true
end

-- Stop Animation Function (SAFE VERSION)
function stopAnimation()
    print("⏹️ Stopping animation...")
    
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
    
    currentAnimation = nil
    isAnimating = false
    
    -- Update status
    if statusLabel then
        statusLabel.Text = "Status: Stopped"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    -- Stop visual effects
    stopVisualEffects()
    
    print("✅ Animation stopped successfully")
end

-- ========================================
-- EFFECT FUNCTIONS
-- ========================================

-- Play Sound Effect (SAFE VERSION)
function playSoundEffect(animationName)
    if not isCharacterReady() then
        print("⚠️ Cannot play sound - character not ready")
        return
    end
    
    local soundId = SOUND_IDS.AURA_SOUND -- Default sound
    
    -- Create sound SAFELY
    local success, errorMsg = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 0.5
        sound.Parent = character
        
        -- Play sound
        sound:Play()
        
        -- Clean up after sound ends
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
    
    if not success then
        print("⚠️ Failed to play sound: " .. tostring(errorMsg))
    end
end

-- Create Visual Effects (SAFE VERSION)
function createVisualEffects(animationName)
    if not isCharacterReady() then
        print("⚠️ Cannot create effects - character not ready")
        return
    end
    
    -- Create aura effect SAFELY
    local success, errorMsg = pcall(function()
        local aura = Instance.new("Part")
        aura.Name = "AuraEffect"
        aura.Size = Vector3.new(10, 10, 10)
        aura.Position = rootPart.Position
        aura.Anchored = true
        aura.CanCollide = false
        aura.Transparency = 0.5
        aura.Parent = character
        
        -- Set aura color based on animation
        local auraColor = Color3.fromRGB(255, 255, 255) -- Default white
        
        if animationName:lower():find("fire") then
            auraColor = Color3.fromRGB(255, 100, 100) -- Red
        elseif animationName:lower():find("ice") then
            auraColor = Color3.fromRGB(100, 100, 255) -- Blue
        elseif animationName:lower():find("lightning") then
            auraColor = Color3.fromRGB(255, 255, 100) -- Yellow
        elseif animationName:lower():find("dark") then
            auraColor = Color3.fromRGB(100, 100, 100) -- Dark
        elseif animationName:lower():find("holy") then
            auraColor = Color3.fromRGB(255, 255, 200) -- Light
        end
        
        aura.Color = auraColor
        
        -- Create aura material
        local auraMaterial = Instance.new("SpecialMesh")
        auraMaterial.MeshType = Enum.MeshType.Sphere
        auraMaterial.Parent = aura
        
        -- Animate aura
        local auraTween = TweenService:Create(aura, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
            Transparency = 0.8,
            Size = Vector3.new(15, 15, 15)
        })
        auraTween:Play()
        
        -- Rotate aura
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if aura.Parent then
                aura.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(1), 0)
            else
                connection:Disconnect()
            end
        end)
    end)
    
    if not success then
        print("⚠️ Failed to create visual effects: " .. tostring(errorMsg))
    end
end

-- Stop Visual Effects (SAFE VERSION)
function stopVisualEffects()
    if not isCharacterReady() then
        return
    end
    
    local success, errorMsg = pcall(function()
        local aura = character:FindFirstChild("AuraEffect")
        if aura then
            aura:Destroy()
        end
    end)
    
    if not success then
        print("⚠️ Failed to stop visual effects: " .. tostring(errorMsg))
    end
end

-- ========================================
-- INPUT HANDLING
-- ========================================

-- Keyboard Shortcuts (SAFE VERSION)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        -- Quick aura farming
        playAnimation("Aura Farming")
    elseif input.KeyCode == Enum.KeyCode.E then
        -- Quick meditation
        playAnimation("Meditation")
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Random animation
        local randomAnimation = animationList[math.random(1, #animationList)]
        playAnimation(randomAnimation)
    elseif input.KeyCode == Enum.KeyCode.T then
        -- Stop animation
        stopAnimation()
    end
end)

-- ========================================
-- CHARACTER MONITORING (NO CharacterAdded)
-- ========================================

-- Monitor character changes safely
spawn(function()
    while true do
        wait(1) -- Check every second
        
        if player.Character and player.Character ~= character then
            print("🔄 Character changed, reinitializing...")
            
            -- Stop any current animation
            if isAnimating then
                stopAnimation()
            end
            
            -- Update character references
            character = player.Character
            if character then
                humanoid = character:FindFirstChild("Humanoid")
                rootPart = character:FindFirstChild("HumanoidRootPart")
                
                -- Wait for parts to exist
                if not humanoid then
                    humanoid = character:WaitForChild("Humanoid")
                end
                if not rootPart then
                    rootPart = character:WaitForChild("HumanoidRootPart")
                end
                
                print("✅ Character reinitialized successfully!")
            end
        elseif not player.Character and character then
            print("⚠️ Character removed, cleaning up...")
            if isAnimating then
                stopAnimation()
            end
            character = nil
            humanoid = nil
            rootPart = nil
        end
    end
end)

-- ========================================
-- INITIALIZATION
-- ========================================

-- Main Initialize Function
local function initialize()
    print("🚀 Starting Aura Farming System...")
    
    -- Initialize character first
    local characterReady = initializeCharacter()
    if not characterReady then
        print("❌ Failed to initialize character!")
        return
    end
    
    -- Create UI
    createUI()
    
    -- Print welcome message
    print("🌟 AURA FARMING SYSTEM LOADED! 🌟")
    print("📋 Available Animations:")
    for i, animation in ipairs(animationList) do
        print("  " .. i .. ". " .. animation)
    end
    print("⌨️ Keyboard Shortcuts:")
    print("  Q - Aura Farming")
    print("  E - Meditation")
    print("  R - Random Animation")
    print("  T - Stop Animation")
    print("🎮 Use the UI or keyboard shortcuts to control animations!")
    print("✅ System ready!")
end

-- ========================================
-- START THE SYSTEM
-- ========================================

-- Run initialization
initialize()

-- ========================================
-- END OF SCRIPT
-- ========================================