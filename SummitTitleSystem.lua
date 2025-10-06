--[[
    GHAA SCRIPTER ROBLOX - Summit Title System
    Sistem title summit dengan level progression
    Setiap finish = +1 level, harus respawn untuk naik level lagi
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local DataStoreService = game:GetService("DataStoreService")

-- Configuration
local SUMMIT_DATASTORE = "SummitTitles"
local FINISH_PART_NAME = "FinishLine" -- Nama part finish line
local RESPAWN_REQUIRED = true -- Harus respawn untuk naik level

-- Title names untuk setiap level
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

-- Colors untuk setiap level
local TITLE_COLORS = {
    [0] = Color3.fromRGB(128, 128, 128), -- Gray
    [1] = Color3.fromRGB(205, 127, 50), -- Bronze
    [2] = Color3.fromRGB(192, 192, 192), -- Silver
    [3] = Color3.fromRGB(255, 215, 0),   -- Gold
    [4] = Color3.fromRGB(0, 191, 255),  -- Blue
    [5] = Color3.fromRGB(138, 43, 226), -- Purple
    [6] = Color3.fromRGB(255, 20, 147), -- Pink
    [7] = Color3.fromRGB(0, 255, 127),  -- Green
    [8] = Color3.fromRGB(255, 69, 0),   -- Red
    [9] = Color3.fromRGB(255, 165, 0),  -- Orange
    [10] = Color3.fromRGB(75, 0, 130),   -- Indigo
    [11] = Color3.fromRGB(255, 0, 255), -- Magenta
    [12] = Color3.fromRGB(0, 255, 255), -- Cyan
    [13] = Color3.fromRGB(255, 255, 0), -- Yellow
    [14] = Color3.fromRGB(128, 0, 128), -- Purple
    [15] = Color3.fromRGB(255, 192, 203), -- Pink
    [16] = Color3.fromRGB(0, 128, 0),   -- Green
    [17] = Color3.fromRGB(255, 0, 0),   -- Red
    [18] = Color3.fromRGB(0, 0, 255),   -- Blue
    [19] = Color3.fromRGB(255, 255, 255), -- White
    [20] = Color3.fromRGB(255, 215, 0)  -- Gold
}

-- Create RemoteEvents
local SummitEvent = Instance.new("RemoteEvent")
SummitEvent.Name = "SummitEvent"
SummitEvent.Parent = ReplicatedStorage

local SummitRequest = Instance.new("RemoteEvent")
SummitRequest.Name = "SummitRequest"
SummitRequest.Parent = ReplicatedStorage

-- Create DataStore
local summitDataStore = DataStoreService:GetDataStore(SUMMIT_DATASTORE)

-- Player data tracking
local playerData = {}
local playerCanLevelUp = {}

-- Sound effects
local levelUpSound = Instance.new("Sound")
levelUpSound.Name = "LevelUpSound"
levelUpSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
levelUpSound.Volume = 0.7
levelUpSound.Parent = SoundService

local finishSound = Instance.new("Sound")
finishSound.Name = "FinishSound"
finishSound.SoundId = "rbxasset://sounds/bell.wav"
finishSound.Volume = 0.5
finishSound.Parent = SoundService

-- Function to get player summit level
local function getPlayerSummitLevel(player)
    return playerData[player.UserId] or 0
end

-- Function to set player summit level
local function setPlayerSummitLevel(player, level)
    playerData[player.UserId] = level
    -- Save to DataStore
    pcall(function()
        summitDataStore:SetAsync(player.UserId, level)
    end)
end

-- Function to get title name
local function getTitleName(level)
    return TITLE_NAMES[level] or "🏔️ UNKNOWN"
end

-- Function to get title color
local function getTitleColor(level)
    return TITLE_COLORS[level] or Color3.fromRGB(255, 255, 255)
end

-- Function to create level up notification
local function createLevelUpNotification(player, newLevel, titleName)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LevelUpNotification"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, getTitleColor(newLevel)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, getTitleColor(newLevel))
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
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🎉 LEVEL UP! 🎉"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = innerFrame
    
    -- New Title
    local newTitle = Instance.new("TextLabel")
    newTitle.Name = "NewTitle"
    newTitle.Size = UDim2.new(1, -20, 0, 30)
    newTitle.Position = UDim2.new(0, 10, 0, 50)
    newTitle.BackgroundTransparency = 1
    newTitle.Text = titleName
    newTitle.TextColor3 = getTitleColor(newLevel)
    newTitle.TextScaled = true
    newTitle.Font = Enum.Font.GothamBold
    newTitle.Parent = innerFrame
    
    -- Level
    local levelText = Instance.new("TextLabel")
    levelText.Name = "Level"
    levelText.Size = UDim2.new(1, -20, 0, 25)
    levelText.Position = UDim2.new(0, 10, 0, 80)
    levelText.BackgroundTransparency = 1
    levelText.Text = "Level: " .. newLevel
    levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelText.TextScaled = true
    levelText.Font = Enum.Font.Gotham
    levelText.Parent = innerFrame
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -20, 0, 25)
    message.Position = UDim2.new(0, 10, 0, 105)
    message.BackgroundTransparency = 1
    message.Text = RESPAWN_REQUIRED and "Respawn untuk naik level lagi!" or "Lanjutkan perjalanan!"
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.TextScaled = true
    message.Font = Enum.Font.Gotham
    message.Parent = innerFrame
    
    -- Animations
    local slideIn = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 0.2, 0)}
    )
    
    local slideOut = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -200, 0, -150)}
    )
    
    local pulse = TweenService:Create(
        mainFrame,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Size = UDim2.new(0, 410, 0, 155)}
    )
    
    -- Play sound
    levelUpSound:Play()
    
    -- Start animations
    slideIn:Play()
    pulse:Play()
    
    -- Auto close after 5 seconds
    local autoClose = coroutine.create(function()
        wait(5)
        slideOut:Play()
        slideOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    coroutine.resume(autoClose)
end

-- Function to create finish notification
local function createFinishNotification(player, currentLevel, titleName)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FinishNotification"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -175, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
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
    title.Text = "🏁 FINISH! 🏁"
    title.TextColor3 = Color3.fromRGB(0, 255, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = innerFrame
    
    -- Current Title
    local currentTitle = Instance.new("TextLabel")
    currentTitle.Name = "CurrentTitle"
    currentTitle.Size = UDim2.new(1, -20, 0, 25)
    currentTitle.Position = UDim2.new(0, 10, 0, 40)
    currentTitle.BackgroundTransparency = 1
    currentTitle.Text = titleName
    currentTitle.TextColor3 = getTitleColor(currentLevel)
    currentTitle.TextScaled = true
    currentTitle.Font = Enum.Font.GothamBold
    currentTitle.Parent = innerFrame
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -20, 0, 25)
    message.Position = UDim2.new(0, 10, 0, 65)
    message.BackgroundTransparency = 1
    message.Text = RESPAWN_REQUIRED and "Respawn untuk naik level!" or "Level up available!"
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.TextScaled = true
    message.Font = Enum.Font.Gotham
    message.Parent = innerFrame
    
    -- Animations
    local slideIn = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -175, 0.3, 0)}
    )
    
    local slideOut = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -175, 0, -120)}
    )
    
    -- Play sound
    finishSound:Play()
    
    -- Start animations
    slideIn:Play()
    
    -- Auto close after 3 seconds
    local autoClose = coroutine.create(function()
        wait(3)
        slideOut:Play()
        slideOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    coroutine.resume(autoClose)
end

-- Function to handle finish line touch
local function onFinishTouched(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if not player then return end
    
    local currentLevel = getPlayerSummitLevel(player)
    local titleName = getTitleName(currentLevel)
    
    -- Check if player can level up
    if playerCanLevelUp[player.UserId] then
        -- Level up
        local newLevel = currentLevel + 1
        setPlayerSummitLevel(player, newLevel)
        playerCanLevelUp[player.UserId] = false
        
        local newTitleName = getTitleName(newLevel)
        createLevelUpNotification(player, newLevel, newTitleName)
        
        -- Send to all clients
        SummitEvent:FireAllClients(player.Name, newLevel, newTitleName, "levelup")
        
        print("🎉 " .. player.Name .. " reached level " .. newLevel .. " - " .. newTitleName)
    else
        -- Just finish notification
        createFinishNotification(player, currentLevel, titleName)
        
        -- Send to all clients
        SummitEvent:FireAllClients(player.Name, currentLevel, titleName, "finish")
        
        print("🏁 " .. player.Name .. " finished - " .. titleName)
    end
end

-- Function to handle respawn
local function onPlayerRespawn(player)
    playerCanLevelUp[player.UserId] = true
    print("🔄 " .. player.Name .. " respawned - Can level up!")
end

-- Function to load player data
local function loadPlayerData(player)
    pcall(function()
        local data = summitDataStore:GetAsync(player.UserId)
        if data then
            playerData[player.UserId] = data
        else
            playerData[player.UserId] = 0
        end
        playerCanLevelUp[player.UserId] = true
        print("📊 Loaded data for " .. player.Name .. " - Level: " .. playerData[player.UserId])
    end)
end

-- Function to handle summit request
local function handleSummitRequest(player, requestType)
    if requestType == "getdata" then
        local level = getPlayerSummitLevel(player)
        local titleName = getTitleName(level)
        SummitEvent:FireClient(player, player.Name, level, titleName, "data")
    end
end

-- Connect events
SummitRequest.OnServerEvent:Connect(handleSummitRequest)

-- Find finish line part
local function findFinishLine()
    local finishLine = nil
    
    -- Search in workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == FINISH_PART_NAME and obj:IsA("BasePart") then
            finishLine = obj
            break
        end
    end
    
    if finishLine then
        finishLine.Touched:Connect(onFinishTouched)
        print("🏁 Finish line found: " .. finishLine.Name)
    else
        print("⚠️ Finish line not found! Please create a part named '" .. FINISH_PART_NAME .. "'")
    end
end

-- Player events
local function onPlayerAdded(player)
    loadPlayerData(player)
    
    -- Handle respawn
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            wait(1) -- Wait for respawn
            onPlayerRespawn(player)
        end)
    end)
end

local function onPlayerRemoving(player)
    playerData[player.UserId] = nil
    playerCanLevelUp[player.UserId] = nil
end

-- Initialize
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Load existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Find finish line
findFinishLine()

print("🚀 GHAA SCRIPTER ROBLOX - Summit Title System Loaded!")
print("🏔️ System: Finish line detection + Level progression")
print("📝 Titles: " .. #TITLE_NAMES .. " levels available")
print("🔄 Respawn required: " .. tostring(RESPAWN_REQUIRED))
print("🏁 Finish line name: " .. FINISH_PART_NAME)