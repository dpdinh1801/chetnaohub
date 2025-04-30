git add .
git commit -m "-- Khởi tạo thư viện
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tạo Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Tạo tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Galaxy Hub - Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Tạo Frame chứa các tab (bên trái)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 120, 1, -40)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabFrame.Parent = MainFrame

-- Danh sách các tab
local Tabs = {
    "Tab farming", "Tab hopping", "Tab setting", "Tab status"
}

-- Tạo Frame chứa nội dung (bên phải)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 280, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.Parent = MainFrame

-- Tạo các Frame cho từng tab
local TabContents = {}
for _, tabName in ipairs(Tabs) do
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentFrame
    TabContents[tabName] = tabContent
end

-- Tạo các nút tab
for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Position = UDim2.new(0, 0, 0, (i-1)*30)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Parent = TabFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, button in pairs(TabFrame:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        TabContents[tabName].Visible = true
    end)
end

-- Biến trạng thái cho các tính năng
_G.Toggles = {
    AutoKillKatakuri = false,
    AutoKillIndra = false,
    AutoPullLever = false,
    AutoTrialV4 = false,
    AutoTrainV4 = false,
    AutoBuyLegendarySword = false,
    AutoHopKatakuri = false,
    AutoHopIndra = false,
    AutoHopMirage = false,
    AutoHopFullMoon = false,
    AutoHopLegendarySword = false,
    FastAttack = false,
    FPSBoost = false,
    TeleportMode = "Fly"
}

-- Hàm tạo nút bật/tắt
local function CreateToggleButton(parent, name, positionY, toggleKey)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 200, 0, 30)
    ToggleButton.Position = UDim2.new(0.5, -100, 0, positionY)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.Text = name .. ": TẮT"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Parent = parent

    ToggleButton.MouseButton1Click:Connect(function()
        _G.Toggles[toggleKey] = not _G.Toggles[toggleKey]
        ToggleButton.Text = name .. ": " .. (_G.Toggles[toggleKey] and "BẬT" or "TẮT")
        ToggleButton.BackgroundColor3 = _G.Toggles[toggleKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    end)
end

-- Tab Farming
CreateToggleButton(TabContents["Tab farming"], "Auto Kill Katakuri", 10, "AutoKillKatakuri")
CreateToggleButton(TabContents["Tab farming"], "Auto Kill Indra", 50, "AutoKillIndra")
CreateToggleButton(TabContents["Tab farming"], "Auto Pull Lever", 90, "AutoPullLever")
CreateToggleButton(TabContents["Tab farming"], "Auto Trial V4", 130, "AutoTrialV4")
CreateToggleButton(TabContents["Tab farming"], "Auto Train V4", 170, "AutoTrainV4")
CreateToggleButton(TabContents["Tab farming"], "Auto Buy Legendary Sword", 210, "AutoBuyLegendarySword")

-- Hiển thị tab đầu tiên mặc định
TabContents["Tab farming"].Visible = true
TabFrame:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(0, 120, 255)"
git push origin main