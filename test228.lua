local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedMult = 15, -- Дополнительная скорость к стандартной
    NoClip = false,
    AutoGun = false
}

-- Создаем UI (оптимизировано под мобильные экзекуторы вроде Xeno)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_XenoMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 XENO BYPASS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = ScreenGui
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinBtn.Position = UDim2.new(0, 10, 0, 10)
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "Меню"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14
MinBtn.Visible = false

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinBtn.Visible = true
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinBtn.Visible = false
end)

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainFrame
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.FillDirection = Enum.FillDirection.Vertical
Instance.new("UIPadding", MainFrame).PaddingTop = UDim.new(0, 45)

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local EspBtn = createBtn("ESP (Роли): ВЫКЛ")
local SpeedBtn = createBtn("Спидхак (Bypass): ВЫКЛ")
local NoclipBtn = createBtn("NoClip (Сквозь стены): ВЫКЛ")
local AutoGunBtn = createBtn("Авто-пистолет: ВЫКЛ")
local TpLobbyBtn = createBtn("Телепорт в Лобби")
local TpMapBtn = createBtn("Телепорт на Карту")

-- Надежное определение ролей в MM2
local function getRole(plr)
    if not plr.Character then return "Innocent" end
    local check = function(obj)
        for _, v in pairs(obj:GetChildren()) do
            if v:IsA("Tool") then
                local n = v.Name:lower()
                if n:find("knife") or n:find("blade") then return "Murderer" end
                if n:find("gun") or n:find("revolver") then return "Sheriff" end
            end
        end
    end
    local role = check(plr.Character) or (plr:FindFirstChild("Backpack") and check(plr.Backpack))
    return role or "Innocent"
end

-- ESP Логика
local espObjects = {}
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not espObjects[p] then
                local hl = Instance.new("Highlight")
                hl.Parent = p.Character
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                espObjects[p] = hl
            end
            local role = getRole(p)
            if Config.ESP then
                espObjects[p].Enabled = true
                if role == "Murderer" then
                    espObjects[p].FillColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then
                    espObjects[p].FillColor = Color3.fromRGB(0, 150, 255)
                else
                    espObjects[p].FillColor = Color3.fromRGB(0, 255, 0)
                end
            else
                espObjects[p].Enabled = false
            end
        end
    end
end

-- Кнопки
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    EspBtn.Text = Config.ESP and "ESP (Роли): ВКЛ" or "ESP (Роли): ВЫКЛ"
    EspBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    SpeedBtn.Text = Config.SpeedHack and "Спидхак (Bypass): ВКЛ" or "Спидхак (Bypass): ВЫКЛ"
    SpeedBtn.BackgroundColor3 = Config.SpeedHack and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    NoclipBtn.Text = Config.NoClip and "NoClip (Сквозь стены): ВКЛ" or "NoClip (Сквозь стены): ВЫКЛ"
    NoclipBtn.BackgroundColor3 = Config.NoClip and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    Config.AutoGun = not Config.AutoGun
    AutoGunBtn.Text = Config.AutoGun and "Авто-пистолет: ВКЛ" or "Авто-пистолет: ВЫКЛ"
    AutoGunBtn.BackgroundColor3 = Config.AutoGun and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
end)

TpLobbyBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-109, 138, 11) -- Примерные координаты лобби
    end
end)

TpMapBtn.MouseButton1Click:Connect(function()
    -- Ищем активную карту и телепортируемся на спавн
    local spawns = workspace:FindFirstChild("Spawns")
    if spawns and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local sp = spawns:GetChildren()[1]
        if sp then
            LocalPlayer.Character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- Обход NoClip через Stepped (чтобы не отбрасывало)
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Основной цикл
RunService.Heartbeat:Connect(function(deltaTime)
    if Config.ESP then updateESP() end
    
    -- Обход Спидхака через CFrame (Античит не может заблокировать физическое смещение)
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedMult * deltaTime))
        end
    end

    -- Авто-подбор пистолета
    if Config.AutoGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local gunDrop = workspace:FindFirstChild("GunDrop")
        if gunDrop then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        end
    end
end)
