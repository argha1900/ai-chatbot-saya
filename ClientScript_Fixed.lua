--[[
    GHAA SCRIPTER ROBLOX - Advanced Announcement System (CLIENT SCRIPT - FIXED)
    This script handles the UI creation for announcements
    Place this script in StarterGui or StarterPlayerScripts
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- Wait for RemoteEvents to be created
local AnnouncementEvent = ReplicatedStorage:WaitForChild("AnnouncementEvent")
local AnnouncementRequest = ReplicatedStorage:WaitForChild("AnnouncementRequest")

-- Create Sound Effects
local NotificationSound = Instance.new("Sound")
NotificationSound.Name = "NotificationSound"
NotificationSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
NotificationSound.Volume = 0.5
NotificationSound.Parent = SoundService

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

-- Connect to announcement event
AnnouncementEvent.OnClientEvent:Connect(function(message, playerName)
    createAnnouncementGUI(message, playerName)
end)

print("🎨 GHAA SCRIPTER ROBLOX - Client Announcement System Loaded!")
print("📱 UI System Ready!")