--[[
    GHAA SCRIPTER ROBLOX - Summit Title System (CLIENT SCRIPT)
    UI untuk menampilkan title dan level player
    Place this script in StarterGui or StarterPlayerScripts
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Wait for RemoteEvents
local SummitEvent = ReplicatedStorage:WaitForChild("SummitEvent")
local SummitRequest = ReplicatedStorage:WaitForChild("SummitRequest")

-- Title names dan colors (same as server)
local TITLE_NAMES = {
    [0] = "🏔️ DON'TOL",
    [1] = "🥉 PEMULA", 
    [2] = "🥈 POKOKNYA",
    [3] = "🥇 KEREN",
    [4] = "💎 LEGEND",
    [5] = "👑 MASTER",
    [6] = "🌟 PRO",
    [7] = "⚡ ELITE",
    [8] = "🔥 CHAMPION",
    [9] = "💫 GRANDMASTER",
    [10] = "🏆 ULTIMATE",
    [11] = "🎯 PERFECT",
    [12] = "🚀 SUPREME",
    [13] = "💎 DIAMOND",
    [14] = "👑 ROYAL",
    [15] = "🌟 CELESTIAL",
    [16] = "⚡ THUNDER",
    [17] = "🔥 INFERNO",
    [18] = "💫 COSMIC",
    [19] = "🏆 OLYMPIAN",
    [20] = "🎯 DIVINE"
}

local TITLE_COLORS = {
    [0] = Color3.fromRGB(128, 128, 128),
    [1] = Color3.fromRGB(205, 127, 50),
    [2] = Color3.fromRGB(192, 192, 192),
    [3] = Color3.fromRGB(255, 215, 0),
    [4] = Color3.fromRGB(0, 191, 255),
    [5] = Color3.fromRGB(138, 43, 226),
    [6] = Color3.fromRGB(255, 20, 147),
    [7] = Color3.fromRGB(0, 255, 127),
    [8] = Color3.fromRGB(255, 69, 0),
    [9] = Color3.fromRGB(255, 165, 0),
    [10] = Color3.fromRGB(75, 0, 130),
    [11] = Color3.fromRGB(255, 0, 255),
    [12] = Color3.fromRGB(0, 255, 255),
    [13] = Color3.fromRGB(255, 255, 0),
    [14] = Color3.fromRGB(128, 0, 128),
    [15] = Color3.fromRGB(255, 192, 203),
    [16] = Color3.fromRGB(0, 128, 0),
    [17] = Color3.fromRGB(255, 0, 0),
    [18] = Color3.fromRGB(0, 0, 255),
    [19] = Color3.fromRGB(255, 255, 255),
    [20] = Color3.fromRGB(255, 215, 0)
}

-- Player data
local playerData = {}
local currentPlayerLevel = 0
local currentPlayerTitle = "🏔️ DON'TOL"

-- Function to get title color
local function getTitleColor(level)
    return TITLE_COLORS[level] or Color3.fromRGB(255, 255, 255)
end

-- Function to create main UI
local function createMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SummitTitleUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 80)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
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
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🏔️ SUMMIT TITLE"
    title.TextColor3 = Color3.fromRGB(0, 212, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = innerFrame
    
    -- Current Title
    local currentTitle = Instance.new("TextLabel")
    currentTitle.Name = "CurrentTitle"
    currentTitle.Size = UDim2.new(1, -20, 0, 25)
    currentTitle.Position = UDim2.new(0, 10, 0, 35)
    currentTitle.BackgroundTransparency = 1
    currentTitle.Text = currentPlayerTitle
    currentTitle.TextColor3 = getTitleColor(currentPlayerLevel)
    currentTitle.TextScaled = true
    currentTitle.Font = Enum.Font.GothamBold
    currentTitle.Parent = innerFrame
    
    -- Level
    local levelText = Instance.new("TextLabel")
    levelText.Name = "Level"
    levelText.Size = UDim2.new(1, -20, 0, 20)
    levelText.Position = UDim2.new(0, 10, 0, 60)
    levelText.BackgroundTransparency = 1
    levelText.Text = "Level: " .. currentPlayerLevel
    levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelText.TextScaled = true
    levelText.Font = Enum.Font.Gotham
    levelText.Parent = innerFrame
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.Position = UDim2.new(1, -40, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 107, 107)
    toggleButton.Text = "−"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = innerFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleButton
    
    -- Minimized state
    local minimized = false
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 50, 0, 50)
            toggleButton.Text = "+"
            innerFrame.Visible = false
        else
            mainFrame.Size = UDim2.new(0, 300, 0, 80)
            toggleButton.Text = "−"
            innerFrame.Visible = true
        end
    end)
    
    -- Hover effects
    toggleButton.MouseEnter:Connect(function()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    toggleButton.MouseLeave:Connect(function()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 107, 107)}):Play()
    end)
    
    return screenGui, currentTitle, levelText
end

-- Function to update UI
local function updateUI(titleLabel, levelLabel, level, titleName)
    currentPlayerLevel = level
    currentPlayerTitle = titleName
    
    titleLabel.Text = titleName
    titleLabel.TextColor3 = getTitleColor(level)
    levelLabel.Text = "Level: " .. level
end

-- Function to create leaderboard
local function createLeaderboard()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SummitLeaderboard"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(1, -270, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
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
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🏆 LEADERBOARD"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = innerFrame
    
    -- Scroll Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.Parent = innerFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    toggleButton.Text = "−"
    toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleButton
    
    -- Minimized state
    local minimized = false
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 50, 0, 50)
            toggleButton.Text = "+"
            innerFrame.Visible = false
        else
            mainFrame.Size = UDim2.new(0, 250, 0, 300)
            toggleButton.Text = "−"
            innerFrame.Visible = true
        end
    end)
    
    return screenGui, scrollFrame
end

-- Function to update leaderboard
local function updateLeaderboard(scrollFrame, playerName, level, titleName)
    -- Clear existing entries
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add player entry
    local playerFrame = Instance.new("Frame")
    playerFrame.Name = "PlayerFrame"
    playerFrame.Size = UDim2.new(1, 0, 0, 40)
    playerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    playerFrame.BorderSizePixel = 0
    playerFrame.Parent = scrollFrame
    
    local playerCorner = Instance.new("UICorner")
    playerCorner.CornerRadius = UDim.new(0, 5)
    playerCorner.Parent = playerFrame
    
    local playerNameLabel = Instance.new("TextLabel")
    playerNameLabel.Name = "PlayerName"
    playerNameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    playerNameLabel.Position = UDim2.new(0, 5, 0, 0)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Text = playerName
    playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerNameLabel.TextScaled = true
    playerNameLabel.Font = Enum.Font.Gotham
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerNameLabel.Parent = playerFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.4, -5, 1, 0)
    titleLabel.Position = UDim2.new(0.6, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleName
    titleLabel.TextColor3 = getTitleColor(level)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Right
    titleLabel.Parent = playerFrame
end

-- Initialize UI
local mainUI, titleLabel, levelLabel = createMainUI()
local leaderboardUI, scrollFrame = createLeaderboard()

-- Request initial data
SummitRequest:FireServer("getdata")

-- Handle summit events
SummitEvent.OnClientEvent:Connect(function(playerName, level, titleName, eventType)
    if eventType == "levelup" then
        print("🎉 " .. playerName .. " reached level " .. level .. " - " .. titleName)
    elseif eventType == "finish" then
        print("🏁 " .. playerName .. " finished - " .. titleName)
    elseif eventType == "data" then
        updateUI(titleLabel, levelLabel, level, titleName)
        updateLeaderboard(scrollFrame, playerName, level, titleName)
    end
end)

print("🎨 GHAA SCRIPTER ROBLOX - Summit Client System Loaded!")
print("📱 UI System Ready!")