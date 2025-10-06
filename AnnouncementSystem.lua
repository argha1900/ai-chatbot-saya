--[[
    GHAA SCRIPTER ROBLOX - Advanced Announcement System
    Command: !a (message)
    Admin Only: ghawan2
    Features: Beautiful UI, Sound Effects, Animations
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")

-- Configuration
local ADMIN_USERNAME = "ghawan2"
local COMMAND_PREFIX = "!a"
local ANNOUNCEMENT_COOLDOWN = 5 -- seconds

-- Create RemoteEvents
local AnnouncementEvent = Instance.new("RemoteEvent")
AnnouncementEvent.Name = "AnnouncementEvent"
AnnouncementEvent.Parent = ReplicatedStorage

local AnnouncementRequest = Instance.new("RemoteEvent")
AnnouncementRequest.Name = "AnnouncementRequest"
AnnouncementRequest.Parent = ReplicatedStorage

-- Create Sound Effects
local NotificationSound = Instance.new("Sound")
NotificationSound.Name = "NotificationSound"
NotificationSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
NotificationSound.Volume = 0.5
NotificationSound.Parent = SoundService

-- Cooldown tracking
local cooldowns = {}

-- Function to check if player is admin
local function isAdmin(player)
    return player.Name == ADMIN_USERNAME
end

-- Function to create announcement GUI
local function createAnnouncementGUI(message, playerName)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnnouncementGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -300, 0, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 153, 204)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 107, 107))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Inner Frame
    local innerFrame = Instance.new("Frame")
    innerFrame.Name = "InnerFrame"
    innerFrame.Size = UDim2.new(1, -10, 1, -10)
    innerFrame.Position = UDim2.new(0, 5, 0, 5)
    innerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    innerFrame.BorderSizePixel = 0
    innerFrame.Parent = mainFrame
    
    -- Corner Radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 10)
    innerCorner.Parent = innerFrame
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    icon.Parent = innerFrame
    
    -- Icon Gradient
    local iconGradient = Instance.new("UIGradient")
    iconGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 107, 107))
    }
    iconGradient.Parent = icon
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 0, 30)
    title.Position = UDim2.new(0, 80, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "📢 ANNOUNCEMENT"
    title.TextColor3 = Color3.fromRGB(0, 212, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = innerFrame
    
    -- Admin Name
    local adminName = Instance.new("TextLabel")
    adminName.Name = "AdminName"
    adminName.Size = UDim2.new(1, -80, 0, 20)
    adminName.Position = UDim2.new(0, 80, 0, 50)
    adminName.BackgroundTransparency = 1
    adminName.Text = "By: " .. playerName
    adminName.TextColor3 = Color3.fromRGB(255, 255, 255)
    adminName.TextScaled = true
    adminName.Font = Enum.Font.Gotham
    adminName.Parent = innerFrame
    
    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -40, 1, -100)
    messageLabel.Position = UDim2.new(0, 20, 0, 80)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = innerFrame
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 107, 107)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = innerFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Animations
    local slideIn = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -300, 0.1, 0)}
    )
    
    local slideOut = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -300, 0, -200)}
    )
    
    local pulse = TweenService:Create(
        mainFrame,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Size = UDim2.new(0, 610, 0, 205)}
    )
    
    -- Play sound
    NotificationSound:Play()
    
    -- Start animations
    slideIn:Play()
    pulse:Play()
    
    -- Auto close after 8 seconds
    local autoClose = coroutine.create(function()
        wait(8)
        slideOut:Play()
        slideOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    coroutine.resume(autoClose)
    
    -- Manual close
    closeButton.MouseButton1Click:Connect(function()
        slideOut:Play()
        slideOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    -- Hover effects
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 107, 107)}):Play()
    end)
end

-- Function to handle announcement request
local function handleAnnouncementRequest(player, message)
    -- Check if player is admin
    if not isAdmin(player) then
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ErrorGUI"
        errorGui.Parent = player.PlayerGui
        
        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 300, 0, 100)
        errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        errorFrame.BackgroundColor3 = Color3.fromRGB(255, 107, 107)
        errorFrame.BorderSizePixel = 0
        errorFrame.Parent = errorGui
        
        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 10)
        errorCorner.Parent = errorFrame
        
        local errorText = Instance.new("TextLabel")
        errorText.Size = UDim2.new(1, -20, 1, -20)
        errorText.Position = UDim2.new(0, 10, 0, 10)
        errorText.BackgroundTransparency = 1
        errorText.Text = "❌ Access Denied!\nOnly " .. ADMIN_USERNAME .. " can use this command!"
        errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorText.TextScaled = true
        errorText.Font = Enum.Font.GothamBold
        errorText.TextWrapped = true
        errorText.Parent = errorFrame
        
        -- Animate error message
        local slideIn = TweenService:Create(
            errorFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Position = UDim2.new(0.5, -150, 0.5, -50)}
        )
        slideIn:Play()
        
        -- Auto destroy after 3 seconds
        game:GetService("Debris"):AddItem(errorGui, 3)
        return
    end
    
    -- Check cooldown
    local currentTime = tick()
    if cooldowns[player.UserId] and (currentTime - cooldowns[player.UserId]) < ANNOUNCEMENT_COOLDOWN then
        local remainingTime = math.ceil(ANNOUNCEMENT_COOLDOWN - (currentTime - cooldowns[player.UserId]))
        
        local cooldownGui = Instance.new("ScreenGui")
        cooldownGui.Name = "CooldownGUI"
        cooldownGui.Parent = player.PlayerGui
        
        local cooldownFrame = Instance.new("Frame")
        cooldownFrame.Size = UDim2.new(0, 250, 0, 80)
        cooldownFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
        cooldownFrame.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
        cooldownFrame.BorderSizePixel = 0
        cooldownFrame.Parent = cooldownGui
        
        local cooldownCorner = Instance.new("UICorner")
        cooldownCorner.CornerRadius = UDim.new(0, 10)
        cooldownCorner.Parent = cooldownFrame
        
        local cooldownText = Instance.new("TextLabel")
        cooldownText.Size = UDim2.new(1, -20, 1, -20)
        cooldownText.Position = UDim2.new(0, 10, 0, 10)
        cooldownText.BackgroundTransparency = 1
        cooldownText.Text = "⏰ Cooldown: " .. remainingTime .. "s"
        cooldownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        cooldownText.TextScaled = true
        cooldownText.Font = Enum.Font.GothamBold
        cooldownText.Parent = cooldownFrame
        
        -- Animate cooldown message
        local slideIn = TweenService:Create(
            cooldownFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back),
            {Position = UDim2.new(0.5, -125, 0.5, -40)}
        )
        slideIn:Play()
        
        -- Auto destroy after 2 seconds
        game:GetService("Debris"):AddItem(cooldownGui, 2)
        return
    end
    
    -- Set cooldown
    cooldowns[player.UserId] = currentTime
    
    -- Validate message
    if not message or message == "" then
        return
    end
    
    -- Send announcement to all players
    AnnouncementEvent:FireAllClients(message, player.Name)
    
    -- Log the announcement
    print("📢 Announcement by " .. player.Name .. ": " .. message)
end

-- Connect events
AnnouncementRequest.OnServerEvent:Connect(handleAnnouncementRequest)

AnnouncementEvent.OnClientEvent:Connect(function(message, playerName)
    createAnnouncementGUI(message, playerName)
end)

-- Chat command handler
local function onPlayerAdded(player)
    player.Chatted:Connect(function(message)
        if string.sub(message:lower(), 1, #COMMAND_PREFIX + 1) == COMMAND_PREFIX .. " " then
            local announcementMessage = string.sub(message, #COMMAND_PREFIX + 2)
            AnnouncementRequest:FireServer(announcementMessage)
        end
    end)
end

-- Connect to existing and new players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Clean up cooldowns when players leave
Players.PlayerRemoving:Connect(function(player)
    cooldowns[player.UserId] = nil
end)

print("🚀 GHAA SCRIPTER ROBLOX - Advanced Announcement System Loaded!")
print("📝 Command: " .. COMMAND_PREFIX .. " (message)")
print("👑 Admin: " .. ADMIN_USERNAME)
print("⏱️ Cooldown: " .. ANNOUNCEMENT_COOLDOWN .. " seconds")