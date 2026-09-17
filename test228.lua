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
    AimbotKey = Enum.UserInputType.MouseButton2, -- ПКМ для аима
    AimbotSmoothness = 4, -- Плавность наведения
    AutoPickGun = false
}

-- Создание графического интерфейса (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_AdvancedMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 Ultimate Menu | Delta"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Кнопка сворачивания (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Title
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -12)
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

-- Маленькая кнопка (когда свернуто)
local SmallButton = Instance.new("TextButton")
SmallButton.Name = "SmallButton"
SmallButton.Parent = ScreenGui
SmallButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SmallButton.Position = UDim2.new(0.1, 0, 0.1, 0)
SmallButton.Size = UDim2.new(0, 45, 0, 45)
SmallButton.Visible = false
SmallButton.Active = true
SmallButton.Draggable = true
SmallButton.Font = Enum.Font.GothamBold
SmallButton.Text = "🔪"
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
UIList.Padding = UDim.new(0, 8)

-- Функция создания кнопок в меню
local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Size = UDim2.new(0, 260, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local EspBtn = createButton("ESP (Убийца:Красный / Шериф:Синий): ВКЛ", 1)
local AimbotBtn = createButton("Нормальный Аимбот (на Убийцу): ВЫКЛ", 2)
local AutoGunBtn = createButton("Авто-подбор пистолета: ВЫКЛ", 3)
local SkinChangerBtn = createButton("Выдать Godly Скины (Скин-чейнджер)", 4)

-- Функция точного определения роли в MM2
local function getRole(player)
    if not player.Character then return "Innocent" end
    
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    -- Проверка на наличие ножа или пистолета (руки + инвентарь)
    local hasKnife = character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
    local hasGun = character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
    
    if hasKnife then
        return "Murderer"
    elseif hasGun then
        return "Sheriff"
    else
        return "Innocent"
    end
end

-- Логика ESP (Подсветка)
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
                        hl.FillColor = Color3.fromRGB(255, 0, 0) -- Красный для убийцы
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(0, 100, 255) -- Синий для шерифа
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    else
                        hl.Enabled = false -- Невинных не подсвечиваем для чистоты экрана
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

-- Поиск цели для Аимбота (Ближайший убийца)
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

-- Кнопки интерфейса
EspBtn.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    EspBtn.Text = Config.ESPEnabled and "ESP (Убийца:Красный / Шериф:Синий): ВКЛ" or "ESP: ВЫКЛ"
    if not Config.ESPEnabled then
        for _, hl in pairs(highlights) do hl.Enabled = false end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    AimbotBtn.Text = Config.AimbotEnabled and "Нормальный Аимбот (на Убийцу): ВКЛ" or "Нормальный Аимбот (на Убийцу): ВЫКЛ"
    AimbotBtn.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    Config.AutoPickGun = not Config.AutoPickGun
    AutoGunBtn.Text = Config.AutoPickGun and "Авто-подбор пистолета: ВКЛ" or "Авто-подбор пистолета: ВЫКЛ"
    AutoGunBtn.BackgroundColor3 = Config.AutoPickGun and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

-- Скин-чейнджер (Выдача визуального оружия из хранилища игры)
SkinChangerBtn.MouseButton1Click:Connect(function()
    pcall(function()
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("Tool") and (v.Name:lower():find("knife") or v.Name:lower():find("gun")) then
                local clone = v:Clone()
                clone.Parent = LocalPlayer.Backpack
            end
        end
    end)
    SkinChangerBtn.Text = "Скины выданы!"
    task.wait(1.5)
    SkinChangerBtn.Text = "Выдать Godly Скины (Скин-чейнджер)"
end)

-- Главный цикл обработки (RenderStepped) для оптимизированного отслеживания
RunService.RenderStepped:Connect(function()
    if Config.ESPEnabled then
        updateESP()
    end
    
    -- Аимбот (работает при зажатой ПКМ)
    if Config.AimbotEnabled and UserInputService:IsMouseButtonPressed(Config.AimbotKey) then
        local targetHead = getTargetMurderer()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), 1 / Config.AimbotSmoothness)
        end
    end
    
    -- Авто-подбор упавшего пистолета
    if Config.AutoPickGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, drop in pairs(workspace:GetChildren()) do
            if drop.Name == "GunDrop" and drop:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = drop.CFrame
            end
        end
    end
end)
