-- ========================================================
--         ULTIMATE HUB 2026 EDITION (MM2 & GENERAL)
--         Style: Cyberpunk / Glassmorphism UI 2026
-- ========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Переменные настроек
local Settings = {
    AutoCoin = false,
    CoinDelay = 2,
    AutoGun = false,
    Shaders = false,
    ESP = false,
    Noclip = false,
    Speed = 16
}

-- [1] СОЗДАНИЕ СОВРЕМЕННОГО ИНТЕРФЕЙСА (2026 DESIGN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHub2026"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(110, 86, 207)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ULTIMATE HUB | 2026 NEXT-GEN"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Контейнер для кнопок (Скролл)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 86, 207)
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Scroll

-- Функция для создания переключателей (Toggles)
local function CreateToggle(name, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(35, 30, 60) or Color3.fromRGB(22, 22, 32)
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.Parent = Scroll
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = defaultState and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(45, 45, 60)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 45, 1, 0)
    Status.Position = UDim2.new(1, -50, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = defaultState and "ON" or "OFF"
    Status.TextColor3 = defaultState and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(180, 70, 70)
    Status.TextSize = 13
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Button

    local state = defaultState
    Button.MouseButton1Click:Connect(function()
        state = not state
        Status.Text = state and "ON" or "OFF"
        Status.TextColor3 = state and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(180, 70, 70)
        
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(35, 30, 60) or Color3.fromRGB(22, 22, 32)
        }):Play()
        
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {
            Color = state and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(45, 45, 60)
        }):Play()

        callback(state)
    end)
end

-- Функция для обычных кнопок
local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(230, 230, 250)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamMedium
    Button.Parent = Scroll

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(60, 60, 80)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 80)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 40)}):Play()
        callback()
    end)
end

-- ========================================================
--                     ФУНКЦИОНАЛ С КРИПТА
-- ========================================================

-- [2] БЕЗОПАСНЫЙ СБОР МОНЕТ (Раз в 2 секунды от кика)
CreateToggle("🪙 Безопасный фарм монет (2 сек)", Settings.AutoCoin, function(state)
    Settings.AutoCoin = state
    if state then
        task.spawn(function()
            while Settings.AutoCoin do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Поиск монет на карте
                    local coinsContainer = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("CoinContainer") or workspace
                    for _, v in pairs(coinsContainer:GetDescendants()) do
                        if v.Name == "Coin" or v.Name == "CoinServer" or v.Name == "CoinDrop" then
                            if v:IsA("BasePart") then
                                root.CFrame = v.CFrame + Vector3.new(0, 1.5, 0)
                                task.wait(Settings.CoinDelay) -- Задержка 2 сек, чтобы сервер не кикал
                                break
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- [3] ТЕЛЕПОРТ К УБИЙЦЕ (За 5 метров)
CreateButton("🎯 ТП к Убийце (За 5м)", function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Проверка на нож у игрока
            local hasKnife = player.Character:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
            if hasKnife and player.Character:FindFirstChild("HumanoidRootPart") then
                local murdererRoot = player.Character.HumanoidRootPart
                -- Телепортируем за 5 метров до него
                root.CFrame = murdererRoot.CFrame * CFrame.new(0, 0, 5)
                break
            end
        end
    end
end)

-- [4] АВТО-ТЕЛЕПОРТ К ВЫПАВШЕМУ ПИСТОЛЕТУ
CreateToggle("🔫 Авто-ТП к Пистолету", Settings.AutoGun, function(state)
    Settings.AutoGun = state
    if state then
        task.spawn(function()
            while Settings.AutoGun do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
                    if gunDrop and gunDrop:IsA("BasePart") then
                        root.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- [5] ФИКС И УЛУЧШЕНИЕ ШЕЙДЕРОВ / ОСВЕЩЕНИЯ
CreateToggle("✨ RTX Шейдеры 2026 / Fullbright", Settings.Shaders, function(state)
    Settings.Shaders = state
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false

        local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
        bloom.Intensity = 0.4
        bloom.Size = 24
        bloom.Threshold = 0.8

        local color = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
        color.Brightness = 0.05
        color.Contrast = 0.15
        color.Saturation = 0.2
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then bloom:Destroy() end
        local color = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if color then color:Destroy() end
    end
end)

-- [6] НОВАЯ ФУНКЦИЯ: PLAYER ESP (Подсветка ролей)
CreateToggle("👁️ ESP Ролей (Мардер, Шериф)", Settings.ESP, function(state)
    Settings.ESP = state
    if state then
        task.spawn(function()
            while Settings.ESP do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        local highlight = char:FindFirstChild("RoleHighlight") or Instance.new("Highlight", char)
                        highlight.Name = "RoleHighlight"
                        
                        local hasKnife = char:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))
                        local hasGun = char:FindFirstChild("Gun") or (player.Backpack and player.Backpack:FindFirstChild("Gun"))

                        if hasKnife then
                            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Убийца (Красный)
                        elseif hasGun then
                            highlight.FillColor = Color3.fromRGB(0, 100, 255) -- Шериф (Синий)
                        else
                            highlight.FillColor = Color3.fromRGB(0, 255, 100) -- Мирный (Зеленый)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("RoleHighlight") then
                player.Character.RoleHighlight:Destroy()
            end
        end
    end
end)

-- [7] НОВАЯ ФУНКЦИЯ: NOCLIP (Хождение сквозь стены)
CreateToggle("👻 Noclip (Сквозь стены)", Settings.Noclip, function(state)
    Settings.Noclip = state
end)

RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- [8] НОВАЯ ФУНКЦИЯ: БЫСТРЫЙ БЕГ (Speed Boost)
CreateButton("⚡ Скорость х2 (32 WalkSpeed)", function()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 32
    end
end)

print("✅ Ultimate Hub 2026 успешно загружен!")
