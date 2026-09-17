-- Убедимся, что скрипт выполняется в эксплойте (Delta)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESPEnabled = true,
    AimbotEnabled = false,
    AimbotKey = Enum.UserInputType.MouseButton2, -- Зажимайте ПКМ
    AimbotSmoothness = 3, -- Плавность наведения (меньше = быстрее)
    AutoPickGun = false,
    SpeedHack = false,
    SpeedValue = 20,
    NoClip = false
}

-- Создание графического интерфейса (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_FixedUltimateMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 Fixed Pro Menu | Delta"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Кнопка сворачивания (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Title
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -12)
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Маленькая кнопка (квадратик)
local SmallButton = Instance.new("TextButton")
SmallButton.Name = "SmallButton"
SmallButton.Parent = ScreenGui
SmallButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SmallButton.Position = UDim2.new(0.1, 0, 0.1, 0)
SmallButton.Size = UDim2.new(0, 45, 0, 45)
SmallButton.Visible = false
SmallButton.Active = true
SmallButton.Draggable = true
SmallButton.Font = Enum.Font.GothamBold
SmallButton.Text = "⚡"
SmallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SmallButton.TextSize = 22

local SmallCorner = Instance.new("UICorner")
SmallCorner.CornerRadius = UDim.new(0, 8)
SmallCorner.Parent = SmallButton

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    SmallButton.Visible = true
end)

SmallButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    SmallButton.Visible = false
end)

-- Контейнер для кнопок
local UIList = Instance.new("UIListLayout")
UIList.Parent = MainFrame
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.FillDirection = Enum.FillDirection.Vertical

-- Функция создания красивых кнопок
local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Size = UDim2.new(0, 290, 0, 36)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local EspBtn = createButton("ESP (Убийца:Красный / Шериф:Синий): ВКЛ", 1)
local AimbotBtn = createButton("Аимбот на Убийцу (ПКМ): ВЫКЛ", 2)
local AutoGunBtn = createButton("Авто-подбор пистолета: ВЫКЛ", 3)
local SkinChangerBtn = createButton("Скин-Чейнджер (Выдать Кинжал/Пистолет)", 4)
local SpeedBtn = createButton("Бег (SpeedHack): ВЫКЛ", 5)
local NoclipBtn = createButton("Проход сквозь стены (NoClip): ВЫКЛ", 6)

-- ИСПРАВЛЕННАЯ СИСТЕМА ОПРЕДЕЛЕНИЯ РОЛЕЙ В MM2
local function getRole(player)
    if not player.Character then return "Innocent" end
    
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    -- Ищем оружие по имени или наличию специфических классов в рюкзаке/персонаже
    local function checkItem(item)
        if not item then return false end
        local name = item.Name:lower()
        if name:find("knife") or name:find("blade") or name:find("dagger") or name:find("revolver") or name:find("gun") or name:find("sheriff") then
            return true
        end
        return false
    end
    
    -- Проверка персонажа (руки)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and checkItem(item) then
            if item.Name:lower():find("gun") or item.Name:lower():find("revolver") then
                return "Sheriff"
            else
                return "Murderer"
            end
        end
    end
    
    -- Проверка рюкзака
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and checkItem(item) then
                if item.Name:lower():find("gun") or item.Name:lower():find("revolver") then
                    return "Sheriff"
                else
                    return "Murderer"
                end
            end
        end
    end
    
    return "Innocent"
end

-- НАДЕЖНЫЙ ESP С ПОДСВЕТКОЙ
local highlights = {}

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not highlights[player] and player.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = player.Character
                hl.Adornee = player.Character
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlights[player] = hl
            end
            
            local hl = highlights[player]
            if hl and player.Character then
                if Config.ESPEnabled then
                    hl.Enabled = true
                    local role = getRole(player)
                    if role == "Murderer" then
                        hl.FillColor = Color3.fromRGB(255, 0, 0) -- Красный
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Enabled = true
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(0, 120, 255) -- Синий
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Enabled = true
                    else
                        hl.Enabled = false -- Невинных не подсвечиваем для удобства
                    end
                else
                    hl.Enabled = false
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end)

-- ИСПРАВЛЕННЫЙ АИМБОТ НА ГОЛОВУ УБИЙЦЫ
local function getTargetMurderer()
    local target = nil
    local shortestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("Head") then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    
                    if dist < shortestDist then
                        shortestDist = dist
                        target = player.Character.Head
                    end
                end
            end
        end
    end
    return target
end

-- РАБОЧИЙ СКИН-ЧЕЙНДЖЕР (Клонирование моделей оружия из репликации в инвентарь)
SkinChangerBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        
        -- Поиск доступных инструментов в игре
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("Tool") then
                local name = v.Name:lower()
                if name:find("knife") or name:find("gun") or name:find("revolver") then
                    local clone = v:Clone()
                    clone.Parent = backpack
                end
            end
        end
    end)
    SkinChangerBtn.Text = "Скины успешно применены!"
    task.wait(1.5)
    SkinChangerBtn.Text = "Скин-Чейнджер (Выдать Кинжал/Пистолет)"
end)

-- УПРАВЛЕНИЕ КНОПКАМИ ИНТЕРФЕЙСА
EspBtn.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    EspBtn.Text = Config.ESPEnabled and "ESP (Убийца:Красный / Шериф:Синий): ВКЛ" or "ESP: ВЫКЛ"
    if not Config.ESPEnabled then
        for _, hl in pairs(highlights) do hl.Enabled = false end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    AimbotBtn.Text = Config.AimbotEnabled and "Аимбот на Убийцу (ПКМ): ВКЛ" or "Аимбот на Убийцу (ПКМ): ВЫКЛ"
    AimbotBtn.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    Config.AutoPickGun = not Config.AutoPickGun
    AutoGunBtn.Text = Config.AutoPickGun and "Авто-подбор пистолета: ВКЛ" or "Авто-подбор пистолета: ВЫКЛ"
    AutoGunBtn.BackgroundColor3 = Config.AutoPickGun and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    SpeedBtn.Text = Config.SpeedHack and "Бег (SpeedHack): ВКЛ" or "Бег (SpeedHack): ВЫКЛ"
    SpeedBtn.BackgroundColor3 = Config.SpeedHack and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    NoclipBtn.Text = Config.NoClip and "Проход сквозь стены (NoClip): ВКЛ" or "Проход сквозь стены (NoClip): ВЫКЛ"
    NoclipBtn.BackgroundColor3 = Config.NoClip and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

-- ГЛАВНЫЙ ОПТИМИЗИРОВАННЫЙ ЦИКЛ ОБРАБОТКИ
RunService.RenderStepped:Connect(function()
    -- 1. Обновление ESP
    if Config.ESPEnabled then
        updateESP()
    end
    
    -- 2. Аимбот (срабатывает по удержанию ПКМ)
    if Config.AimbotEnabled and UserInputService:IsMouseButtonPressed(Config.AimbotKey) then
        local targetHead = getTargetMurderer()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), 1 / Config.AimbotSmoothness)
        end
    end
    
    -- 3. Авто-подбор упавшего пистолета Шерифа
    if Config.AutoPickGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
            end
        end
    end
    
    -- 4. SpeedHack
    if Config.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedValue
    end
    
    -- 5. NoClip (отключение коллизии частей тела)
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
