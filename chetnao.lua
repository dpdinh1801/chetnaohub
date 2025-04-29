git init
git add BloxFruitCompleteKavoUIScript.lua
git commit -m "-- Script chạy trong Roblox Studio: GUI Kavo UI với Hop Server, Farming, Auto Farm Bone, Auto Farm EXP, Auto Quest, Bone to EXP
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local TweenService = game:GetService("TweenService")

-- DataStore để lưu Bone và EXP
local PlayerData = DataStoreService:GetDataStore("PlayerData")

-- Tải Kavo UI Library
local Kavo = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Blox Fruit Script", "DarkTheme")

-- Hàm hiển thị thông báo pop-up
local function showNotification(player, message)
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true

    local tween = TweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.2, 0)})
    tween:Play()
    wait(3)
    tween = TweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -100, 0.1, 0)})
    tween:Play()
    wait(1)
    screenGui:Destroy()
end

-- Hàm tạo quái Bone giả lập
local function spawnBoneEnemy()
    if #Workspace:GetChildrenOfClass("Model") >= 5 then return end
    local enemy = Instance.new("Model")
    enemy.Name = "BoneEnemy"
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 4, 2)
    part.Position = Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))
    part.BrickColor = BrickColor.new("White")
    part.Anchored = false
    part.CanCollide = true
    part.Parent = enemy

    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.Parent = enemy
    enemy.PrimaryPart = part
    enemy.Parent = Workspace

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.Parent = part

    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxassetid://243098098"
    particle.Rate = 0
    particle.Lifetime = NumberRange.new(1, 2)
    particle.Speed = NumberRange.new(5, 10)
    particle.Parent = part

    return enemy
end

-- Hàm tạo quái thường giả lập (cho Auto Farm EXP)
local function spawnNormalEnemy()
    if #Workspace:GetChildrenOfClass("Model") >= 5 then return end
    local enemy = Instance.new("Model")
    enemy.Name = "NormalEnemy"
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 4, 2)
    part.Position = Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))
    part.BrickColor = BrickColor.new("Really red")
    part.Anchored = false
    part.CanCollide = true
    part.Parent = enemy

    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 50
    humanoid.Health = 50
    humanoid.Parent = enemy
    enemy.PrimaryPart = part
    enemy.Parent = Workspace

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.Parent = part

    return enemy
end

-- Hàm tạo NPC nhiệm vụ giả lập
local function spawnQuestNPC()
    local npc = Instance.new("Model")
    npc.Name = "QuestNPC"
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 4, 2)
    part.Position = Vector3.new(0, 10, 0)
    part.BrickColor = BrickColor.new("Really green")
    part.Anchored = true
    part.CanCollide = true
    part.Parent = npc

    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 0
    humanoid.Health = 0
    humanoid.Parent = npc
    npc.PrimaryPart = part
    npc.Parent = Workspace

    return npc
end

-- Hàm di chuyển đến vị trí
local function moveToPosition(player, position)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

    local humanoid = character.Humanoid
    local path = PathfindingService:CreatePath()
    path:ComputeAsync(character.HumanoidRootPart.Position, position)
    local waypoints = path:GetWaypoints()

    for _, waypoint in pairs(waypoints) do
        humanoid:MoveTo(waypoint.Position)
        humanoid.MoveToFinished:Wait()
    end
    return true
end

-- Hàm farm Bone
local function farmBone(player, boneLabel)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

    local humanoid = character.Humanoid
    local rootPart = character.HumanoidRootPart
    local closestEnemy = nil
    local minDistance = math.huge

    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy.Name == "BoneEnemy" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (enemy.PrimaryPart.Position - rootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestEnemy = enemy
            end
        end
    end

    if closestEnemy then
        moveToPosition(player, closestEnemy.PrimaryPart.Position)
        closestEnemy.Humanoid.Health = 0
        local particle = closestEnemy.PrimaryPart:FindFirstChild("ParticleEmitter")
        if particle then particle:Emit(10) end
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9114487369"
        sound.Parent = closestEnemy.PrimaryPart
        sound:Play()
        closestEnemy:Destroy()
        spawnBoneEnemy()
        local boneCount = player:GetAttribute("BoneCount") or 0
        boneCount = boneCount + 1
        player:SetAttribute("BoneCount", boneCount)
        boneLabel.Text = "Bones: " .. boneCount
        showNotification(player, "Thu thập " .. boneCount .. " Bones!")
        return true
    end
    return false
end

-- Hàm farm EXP
local function farmEXP(player, expLabel)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

    local humanoid = character.Humanoid
    local rootPart = character.HumanoidRootPart
    local closestEnemy = nil
    local minDistance = math.huge

    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy.Name == "NormalEnemy" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (enemy.PrimaryPart.Position - rootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestEnemy = enemy
            end
        end
    end

    if closestEnemy then
        moveToPosition(player, closestEnemy.PrimaryPart.Position)
        closestEnemy.Humanoid.Health = 0
        closestEnemy:Destroy()
        spawnNormalEnemy()
        local exp = player:GetAttribute("EXP") or 0
        exp = exp + 50
        player:SetAttribute("EXP", exp)
        expLabel.Text = "EXP: " .. exp
        showNotification(player, "Thu thập 50 EXP! Tổng: " .. exp)
        return true
    end
    return false
end

-- Hàm Auto Quest
local function autoQuest(player, questLabel)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

    local npc = Workspace:FindFirstChild("QuestNPC")
    if not npc then npc = spawnQuestNPC() end
    moveToPosition(player, npc.PrimaryPart.Position)
    showNotification(player, "Nhận nhiệm vụ từ NPC!")
    questLabel.Text = "Quest: Tiêu diệt 3 quái"
    local kills = 0
    while kills < 3 do
        if farmEXP(player, {Text = questLabel.Text}) then
            kills = kills + 1
            questLabel.Text = "Quest: Tiêu diệt " .. (3 - kills) .. " quái"
        end
        wait(0.5)
    end
    moveToPosition(player, npc.PrimaryPart.Position)
    showNotification(player, "Hoàn thành nhiệm vụ! Nhận 100 EXP")
    local exp = player:GetAttribute("EXP") or 0
    exp = exp + 100
    player:SetAttribute("EXP", exp)
    questLabel.Text = "Quest: Hoàn thành"
    return true
end

-- Hàm lưu dữ liệu
local function savePlayerData(player)
    local success, err = pcall(function()
        PlayerData:SetAsync(player.UserId, {
            BoneCount = player:GetAttribute("BoneCount") or 0,
            EXP = player:GetAttribute("EXP") or 0
        })
    end)
    if not success then
        warn("Lỗi khi lưu dữ liệu cho " .. player.Name .. ": " .. err)
    end
end

-- Hàm tải dữ liệu
local function loadPlayerData(player)
    local success, data = pcall(function()
        return PlayerData:GetAsync(player.UserId)
    end)
    if success and data then
        player:SetAttribute("BoneCount", data.BoneCount or 0)
        player:SetAttribute("EXP", data.EXP or 0)
    end
end

-- Xử lý người chơi
Players.PlayerAdded:Connect(function(player)
    player:SetAttribute("BoneCount", 0)
    player:SetAttribute("EXP", 0)
    player:SetAttribute("LegendarySword", false)
    player:SetAttribute("TrialV4Complete", false)
    loadPlayerData(player)

    -- Tab Hop Server
    local HopServerTab = Window:NewTab("Hop Server")
    local HopServerSection = HopServerTab:NewSection("Server Hop Features")

    local hopFeatures = {
        "Katakuri V2",
        "Indra",
        "Mirage",
        "Legendary Sword",
        "Full Moon"
    }

    for _, feature in pairs(hopFeatures) do
        HopServerSection:NewToggle("Auto Hop " .. feature, "Tìm server với " .. feature, function(state)
            print(player.Name .. " toggled Auto Hop " .. feature .. (state and " ON" or " OFF"))
            if state then
                print("Đang tìm server với " .. feature .. "...")
                showNotification(player, "Đang tìm server với " .. feature .. "...")
            end
        end)
    end

    -- Tab Farming
    local FarmingTab = Window:NewTab("Farming")
    local FarmingSection = FarmingTab:NewSection("Farming Features")
    local BoneLabel = FarmingSection:NewLabel("Bones: " .. (player:GetAttribute("BoneCount") or 0))
    local EXPLabel = FarmingSection:NewLabel("EXP: " .. (player:GetAttribute("EXP") or 0))
    local QuestLabel = FarmingSection:NewLabel("Quest: None")

    FarmingSection:NewButton("Auto Kill Boss (Katakuri/Indra)", "Tấn công boss", function()
        print("Bắt đầu Auto Kill Boss...")
        local bossPos = Vector3.new(50, 10, 50)
        moveToPosition(player, bossPos)
        showNotification(player, "Đang tấn công boss Katakuri/Indra!")
        print("Đang tấn công boss Katakuri/Indra!")
    end)

    FarmingSection:NewButton("Auto Buy Legendary Sword", "Mua Legendary Sword", function()
        print("Đang mua Legendary Sword...")
        player:SetAttribute("LegendarySword", true)
        showNotification(player, "Đã mua Legendary Sword!")
        print("Đã mua Legendary Sword!")
    end)

    FarmingSection:NewButton("Auto Pull Lever", "Thực hiện kéo cần", function()
        print("Bắt đầu Auto Pull Lever...")
        local steps = {
            {pos = Vector3.new(0, 10, 0), msg = "Nhận nhiệm vụ kéo cần"},
            {pos = Vector3.new(100, 10, 100), msg = "Bay đến Mirage Island"},
            {pos = Vector3.new(100, 10, 100), msg = "Nhìn trăng"},
            {pos = Vector3.new(100, 10, 100), msg = "Bật tộc V3"},
            {pos = Vector3.new(150, 10, 150), msg = "Dịch chuyển đến bánh răng"}
        }
        for _, step in pairs(steps) do
            moveToPosition(player, step.pos)
            print(step.msg)
            showNotification(player, step.msg)
            wait(1)
        end
        print("Hoàn thành Auto Pull Lever!")
        showNotification(player, "Hoàn thành Auto Pull Lever!")
    end)

    FarmingSection:NewButton("Auto Trial V4", "Hoàn thành Trial V4", function()
        print("Bắt đầu Auto Trial V4...")
        print("Bật tộc V3 khi người chơi khác bật...")
        print("Hoàn thành trial...")
        local enemyPos = Vector3.new(200, 10, 200)
        moveToPosition(player, enemyPos)
        print("Đang kill player với skill...")
        player:SetAttribute("TrialV4Complete", true)
        print("Chọn gear và train...")
        print("Hoàn thành Auto Trial V4!")
        showNotification(player, "Hoàn thành Auto Trial V4!")
    end)

    FarmingSection:NewToggle("Auto Farm Bone", "Tự động farm Bone", function(state)
        if state then
            spawnBoneEnemy()
            while state and player.Character do
                farmBone(player, BoneLabel)
                savePlayerData(player)
                wait(0.5)
            end
        end
    end)

    FarmingSection:NewToggle("Auto Farm EXP", "Tự động farm EXP", function(state)
        if state then
            spawnNormalEnemy()
            while state and player.Character do
                farmEXP(player, EXPLabel)
                savePlayerData(player)
                wait(0.5)
            end
        end
    end)

    FarmingSection:NewButton("Auto Quest", "Tự động làm nhiệm vụ", function()
        if autoQuest(player, QuestLabel) then
            savePlayerData(player)
        end
    end)

    FarmingSection:NewButton("Bone to EXP (10 Bones = 100 EXP)", "Đổi Bone lấy EXP", function()
        local boneCount = player:GetAttribute("BoneCount") or 0
        if boneCount >= 10 then
            boneCount = boneCount - 10
            local exp = player:GetAttribute("EXP") or 0
            exp = exp + 100
            player:SetAttribute("BoneCount", boneCount)
            player:SetAttribute("EXP", exp)
            BoneLabel.Text = "Bones: " .. boneCount
            EXPLabel.Text = "EXP: " .. exp
            savePlayerData(player)
            showNotification(player, "Đã đổi 10 Bones lấy 100 EXP!")
        else
            showNotification(player, "Không đủ Bones! Cần 10 Bones.")
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

-- Tạo quái và NPC ban đầu
spawnBoneEnemy()
spawnNormalEnemy()
spawnQuestNPC()"
git remote add origin <URL-repository>
git push -u origin main
