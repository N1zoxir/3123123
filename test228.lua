-- Убедимся, что скрипт выполняется в эксплойте (например, Delta)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки функции ESP и Аимбота
local Config = {
    ESPEnabled = true,
    AimbotEnabled = true,
    AimbotKey = Enum.UserInputType.MouseButton2, -- Правая кнопка мыши для аима
    AimbotSmoothness = 5 -- Плавность наводки (чем меньше, тем быстрее)
}

-- Создание графического интерфейса (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Menu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 Menu | Delta Optimized"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка ESP
local EspBtn = Instance.new("TextButton")
EspBtn.Parent = MainFrame
EspBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
EspBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
EspBtn.Size = UDim2.new(0, 200, 0, 35)
EspBtn.Font = Enum.Font.GothamBold
EspBtn.Text = "ESP: ВКЛ"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.TextSize = 14

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = EspBtn

-- Кнопка Аимбота
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Parent = MainFrame
AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
AimbotBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
AimbotBtn.Size = UDim2.new(0, 200, 0, 35)
AimbotBtn.Font = Enum.Font.GothamBold
AimbotBtn.Text = "Аимбот на убийцу: ВКЛ"
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.TextSize = 14

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = AimbotBtn

-- Функция определения роли игрока в MM2
local function getRole(player)
    if not player.Character then return "Innocent" end
    
    -- Проверка на наличие оружия в руках или рюкзаке
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
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

-- Логика ESP (подсветка Highlight)
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
                        hl.FillColor = Color3.fromRGB(0, 0, 255) -- Синий для шерифа
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    else
                        hl.FillColor = Color3.fromRGB(0, 255, 0) -- Зеленый для остальных (или можно скрыть)
                        hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                        hl.Enabled = false -- Невинных не подсвечиваем, чтобы не засорять экран
                    end
                else
                    hl.Enabled = false
                end
            end
        end
    end
end

-- Очистка подсветки при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end)

-- Поиск ближайшего убийцы для Аимбота
local function getTargetMurderer()
    local target = nil
    local shortestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = getRole(player)
            if role == "Murderer" and player.Character and player.Character:FindFirstChild("Head") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
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

-- Обработка кнопок интерфейса
EspBtn.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    if Config.ESPEnabled then
        EspBtn.Text = "ESP: ВКЛ"
        EspBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        EspBtn.Text = "ESP: ВЫКЛ"
        EspBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        for _, hl in pairs(highlights) do
            hl.Enabled = false
        end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    if Config.AimbotEnabled then
        AimbotBtn.Text = "Аимбот на убийцу: ВКЛ"
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        AimbotBtn.Text = "Аимбот на убийцу: ВЫКЛ"
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)

-- Оптимизированный главный цикл (выполняется плавно на каждый кадр)
RunService.RenderStepped:Connect(function()
    if Config.ESPEnabled then
        updateESP()
    end
    
    if Config.AimbotEnabled and UserInputService:IsMouseButtonPressed(Config.AimbotKey) then
        local targetHead = getTargetMurderer()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), 1 / Config.AimbotSmoothness)
        end
    end
end)
