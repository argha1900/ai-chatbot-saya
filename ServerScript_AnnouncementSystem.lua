--[[
    GHAA SCRIPTER ROBLOX - Advanced Announcement System (SERVER SCRIPT)
    Command: !a (message)
    Admin Only: ghawan2
    Place this script in ServerScriptService
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Cooldown tracking
local cooldowns = {}

-- Function to check if player is admin
local function isAdmin(player)
    return player.Name == ADMIN_USERNAME
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
        local TweenService = game:GetService("TweenService")
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
        local TweenService = game:GetService("TweenService")
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

print("🚀 GHAA SCRIPTER ROBLOX - Server Announcement System Loaded!")
print("📝 Command: " .. COMMAND_PREFIX .. " (message)")
print("👑 Admin: " .. ADMIN_USERNAME)
print("⏱️ Cooldown: " .. ANNOUNCEMENT_COOLDOWN .. " seconds")