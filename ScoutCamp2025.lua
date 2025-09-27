--[[
    Tempat Kemah Pramuka Ekspedisi 2025 - Ghawan2
    Script untuk membuat area kemah pramuka yang realistis dan megah
    Ditempatkan di ServerScriptService
]]

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Konfigurasi warna dan material
local COLORS = {
    TENT = Color3.fromRGB(139, 69, 19), -- Coklat kemah
    TENT_ACCENT = Color3.fromRGB(160, 82, 45), -- Coklat terang
    FIRE = Color3.fromRGB(255, 100, 0), -- Orange api
    WOOD = Color3.fromRGB(101, 67, 33), -- Coklat kayu
    FLAG = Color3.fromRGB(255, 0, 0), -- Merah bendera
    GRASS = Color3.fromRGB(34, 139, 34) -- Hijau rumput
}

local MATERIALS = {
    TENT = Enum.Material.Fabric,
    WOOD = Enum.Material.Wood,
    FIRE = Enum.Material.Neon,
    GRASS = Enum.Material.Grass,
    ROCK = Enum.Material.Rock
}

-- Fungsi untuk membuat part dengan properti
local function createPart(name, size, position, color, material, transparency)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.Color = color
    part.Material = material
    part.Transparency = transparency or 0
    part.Anchored = true
    part.CanCollide = true
    part.Parent = workspace
    return part
end

-- Fungsi untuk membuat tenda utama
local function createMainTent()
    local tentGroup = Instance.new("Model")
    tentGroup.Name = "MainTent_Ghawan2"
    tentGroup.Parent = workspace
    
    -- Dasar tenda
    local tentBase = createPart("TentBase", Vector3.new(20, 1, 15), Vector3.new(0, 0.5, 0), COLORS.TENT, MATERIALS.TENT)
    tentBase.Parent = tentGroup
    
    -- Dinding tenda depan
    local frontWall = createPart("FrontWall", Vector3.new(20, 8, 1), Vector3.new(0, 4.5, 7.5), COLORS.TENT_ACCENT, MATERIALS.TENT)
    frontWall.Parent = tentGroup
    
    -- Dinding tenda belakang
    local backWall = createPart("BackWall", Vector3.new(20, 8, 1), Vector3.new(0, 4.5, -7.5), COLORS.TENT_ACCENT, MATERIALS.TENT)
    backWall.Parent = tentGroup
    
    -- Atap tenda (segitiga)
    local roof1 = createPart("Roof1", Vector3.new(20, 0.5, 8), Vector3.new(0, 8.5, 0), COLORS.TENT, MATERIALS.TENT)
    roof1.CFrame = roof1.CFrame * CFrame.Angles(math.rad(15), 0, 0)
    roof1.Parent = tentGroup
    
    local roof2 = createPart("Roof2", Vector3.new(20, 0.5, 8), Vector3.new(0, 8.5, 0), COLORS.TENT, MATERIALS.TENT)
    roof2.CFrame = roof2.CFrame * CFrame.Angles(math.rad(-15), 0, 0)
    roof2.Parent = tentGroup
    
    -- Tiang bendera di depan tenda
    local flagPole = createPart("FlagPole", Vector3.new(0.5, 12, 0.5), Vector3.new(0, 6, 10), Color3.fromRGB(139, 69, 19), MATERIALS.WOOD)
    flagPole.Parent = tentGroup
    
    -- Bendera
    local flag = createPart("Flag", Vector3.new(4, 2.5, 0.2), Vector3.new(2, 9, 10), COLORS.FLAG, MATERIALS.TENT)
    flag.Parent = tentGroup
    
    -- Logo "GHAWAN2" di bendera
    local logo = Instance.new("BillboardGui")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.Parent = flag
    
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "GHAWAN2"
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextScaled = true
    logoText.Font = Enum.Font.SourceSansBold
    logoText.Parent = logo
    
    return tentGroup
end

-- Fungsi untuk membuat area api unggun
local function createCampfire()
    local fireGroup = Instance.new("Model")
    fireGroup.Name = "Campfire_Ghawan2"
    fireGroup.Parent = workspace
    
    -- Batu-batu di sekeliling api
    for i = 1, 8 do
        local angle = (i - 1) * (math.pi * 2 / 8)
        local x = math.cos(angle) * 3
        local z = math.sin(angle) * 3
        
        local rock = createPart("Rock" .. i, Vector3.new(1.5, 1, 1.5), Vector3.new(x, 0.5, z), Color3.fromRGB(105, 105, 105), MATERIALS.ROCK)
        rock.Shape = Enum.PartType.Ball
        rock.Parent = fireGroup
    end
    
    -- Kayu bakar
    for i = 1, 6 do
        local angle = (i - 1) * (math.pi * 2 / 6)
        local x = math.cos(angle) * 1.5
        local z = math.sin(angle) * 1.5
        
        local log = createPart("Log" .. i, Vector3.new(2, 0.3, 0.3), Vector3.new(x, 0.2, z), COLORS.WOOD, MATERIALS.WOOD)
        log.CFrame = log.CFrame * CFrame.Angles(0, angle, 0)
        log.Parent = fireGroup
    end
    
    -- Api unggun (dengan efek)
    local fire = createPart("Fire", Vector3.new(2, 3, 2), Vector3.new(0, 1.5, 0), COLORS.FIRE, MATERIALS.FIRE, 0.3)
    fire.Shape = Enum.PartType.Cylinder
    fire.Parent = fireGroup
    
    -- Efek api
    local fireEffect = Instance.new("Fire")
    fireEffect.Size = 5
    fireEffect.Heat = 10
    fireEffect.Color = Color3.fromRGB(255, 100, 0)
    fireEffect.SecondaryColor = Color3.fromRGB(255, 200, 0)
    fireEffect.Parent = fire
    
    return fireGroup
end

-- Fungsi untuk membuat area aktivitas
local function createActivityArea()
    local activityGroup = Instance.new("Model")
    activityGroup.Name = "ActivityArea_Ghawan2"
    activityGroup.Parent = workspace
    
    -- Meja kayu
    local table = createPart("Table", Vector3.new(6, 0.5, 3), Vector3.new(15, 1.25, 0), COLORS.WOOD, MATERIALS.WOOD)
    table.Parent = activityGroup
    
    -- Kursi-kursi
    for i = 1, 4 do
        local angle = (i - 1) * (math.pi * 2 / 4)
        local x = 15 + math.cos(angle) * 4
        local z = math.sin(angle) * 4
        
        local chair = createPart("Chair" .. i, Vector3.new(1, 2, 1), Vector3.new(x, 1, z), COLORS.WOOD, MATERIALS.WOOD)
        chair.Parent = activityGroup
    end
    
    -- Papan informasi
    local infoBoard = createPart("InfoBoard", Vector3.new(0.2, 4, 6), Vector3.new(25, 2, 0), Color3.fromRGB(255, 255, 255), MATERIALS.WOOD)
    infoBoard.Parent = activityGroup
    
    -- Teks di papan
    local boardGui = Instance.new("BillboardGui")
    boardGui.Size = UDim2.new(1, 0, 1, 0)
    boardGui.Parent = infoBoard
    
    local boardText = Instance.new("TextLabel")
    boardText.Size = UDim2.new(1, 0, 1, 0)
    boardText.BackgroundTransparency = 1
    boardText.Text = "KEMAH PRAMUKA\nEKSPEDISI 2025\nGHAWAN2"
    boardText.TextColor3 = Color3.fromRGB(0, 0, 0)
    boardText.TextScaled = true
    boardText.Font = Enum.Font.SourceSansBold
    boardText.Parent = boardGui
    
    return activityGroup
end

-- Fungsi untuk membuat area latihan
local function createTrainingArea()
    local trainingGroup = Instance.new("Model")
    trainingGroup.Name = "TrainingArea_Ghawan2"
    trainingGroup.Parent = workspace
    
    -- Tiang panjat
    local climbingPole = createPart("ClimbingPole", Vector3.new(0.5, 8, 0.5), Vector3.new(-15, 4, 0), COLORS.WOOD, MATERIALS.WOOD)
    climbingPole.Parent = trainingGroup
    
    -- Tali panjat
    local rope = createPart("Rope", Vector3.new(0.2, 8, 0.2), Vector3.new(-15, 4, 0), Color3.fromRGB(139, 69, 19), MATERIALS.TENT)
    rope.Parent = trainingGroup
    
    -- Area obstacle course
    for i = 1, 5 do
        local obstacle = createPart("Obstacle" .. i, Vector3.new(2, 1, 0.5), Vector3.new(-20 + i * 2, 0.5, 5), COLORS.WOOD, MATERIALS.WOOD)
        obstacle.Parent = trainingGroup
    end
    
    return trainingGroup
end

-- Fungsi untuk membuat dekorasi lingkungan
local function createEnvironment()
    local envGroup = Instance.new("Model")
    envGroup.Name = "Environment_Ghawan2"
    envGroup.Parent = workspace
    
    -- Pohon-pohon di sekeliling
    for i = 1, 12 do
        local angle = (i - 1) * (math.pi * 2 / 12)
        local distance = 30 + math.random(5, 15)
        local x = math.cos(angle) * distance
        local z = math.sin(angle) * distance
        
        -- Batang pohon
        local trunk = createPart("TreeTrunk" .. i, Vector3.new(2, 8, 2), Vector3.new(x, 4, z), Color3.fromRGB(101, 67, 33), MATERIALS.WOOD)
        trunk.Parent = envGroup
        
        -- Daun pohon
        local leaves = createPart("TreeLeaves" .. i, Vector3.new(6, 6, 6), Vector3.new(x, 8, z), COLORS.GRASS, MATERIALS.GRASS)
        leaves.Shape = Enum.PartType.Ball
        leaves.Parent = envGroup
    end
    
    -- Rumput di lantai
    local grassFloor = createPart("GrassFloor", Vector3.new(100, 0.1, 100), Vector3.new(0, 0.05, 0), COLORS.GRASS, MATERIALS.GRASS)
    grassFloor.Parent = envGroup
    
    return envGroup
end

-- Fungsi untuk setup lighting
local function setupLighting()
    -- Matahari
    Lighting.TimeOfDay = "18:00:00" -- Sore hari
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(100, 100, 100)
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
    
    -- Fog
    Lighting.FogStart = 50
    Lighting.FogEnd = 200
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
end

-- Fungsi untuk membuat sound effects
local function createSoundEffects()
    local soundGroup = Instance.new("Model")
    soundGroup.Name = "SoundEffects_Ghawan2"
    soundGroup.Parent = workspace
    
    -- Suara alam
    local natureSound = Instance.new("Sound")
    natureSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    natureSound.Volume = 0.3
    natureSound.Looped = true
    natureSound.Parent = soundGroup
    
    -- Suara api
    local fireSound = Instance.new("Sound")
    fireSound.SoundId = "rbxasset://sounds/fire.wav"
    fireSound.Volume = 0.5
    fireSound.Looped = true
    fireSound.Parent = soundGroup
end

-- Fungsi utama untuk membuat seluruh area kemah
local function createScoutCamp()
    print("🏕️ Membuat Tempat Kemah Pramuka Ekspedisi 2025 - Ghawan2")
    
    -- Setup lighting terlebih dahulu
    setupLighting()
    
    -- Buat semua komponen kemah
    local mainTent = createMainTent()
    local campfire = createCampfire()
    local activityArea = createActivityArea()
    local trainingArea = createTrainingArea()
    local environment = createEnvironment()
    createSoundEffects()
    
    -- Pindahkan semua ke posisi yang tepat
    mainTent:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
    campfire:SetPrimaryPartCFrame(CFrame.new(0, 0, -20))
    activityArea:SetPrimaryPartCFrame(CFrame.new(15, 0, 0))
    trainingArea:SetPrimaryPartCFrame(CFrame.new(-15, 0, 0))
    
    print("✅ Tempat Kemah Pramuka berhasil dibuat!")
    print("📍 Lokasi: Pusat workspace")
    print("🏕️ Fitur: Tenda utama, api unggun, area aktivitas, area latihan")
    print("🌲 Dekorasi: Pohon, rumput, lighting realistis")
    print("🎵 Suara: Efek suara alam dan api")
end

-- Jalankan script
createScoutCamp()

-- Tambahkan fungsi untuk membersihkan area (opsional)
local function cleanupCamp()
    local campObjects = workspace:GetChildren()
    for _, obj in pairs(campObjects) do
        if obj.Name:find("Ghawan2") or obj.Name:find("Scout") then
            obj:Destroy()
        end
    end
    print("🧹 Area kemah dibersihkan")
end

-- Export fungsi untuk digunakan di tempat lain
_G.Ghawan2ScoutCamp = {
    CreateCamp = createScoutCamp,
    CleanupCamp = cleanupCamp
}