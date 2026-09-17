local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedMult = 18, -- Скорость бега
    NoClip = false,
    AutoGun = false
}

-- Создаем компактный UI для мобилки/Xeno
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Clean_Xeno"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
MainFrame.Size = UDim2.new(0, 280, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 FIXED | XENO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = ScreenGui
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.Position = UDim2.new(0, 10, 0, 10)
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "MENU"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Visible = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

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
UIList.Padding = UDim.new(0, 8)
Instance.new("UIPadding", MainFrame).PaddingTop = UDim.new(0, 45)

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Size = UDim2.new(0, 260, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Только рабочие функции
local EspBtn = createBtn("ESP (Убийца/Шериф): ВЫКЛ")
local AimbotBtn = createBtn("Аимбот (на Убийцу): ВЫКЛ")
local SpeedBtn = createBtn("Спидхак (Bypass): ВЫКЛ")
local NoclipBtn = createBtn("NoClip (Сквозь стены): ВЫКЛ")
local AutoGunBtn = createBtn("Авто-пистолет: ВЫКЛ")

-- Улучшенное определение роли (проверяет широкий спектр названий оружия)
local function getRole(plr)
    if not plr.Character then return "Innocent" end
    
    local items = {}
    for _, v in pairs(plr.Character:GetChildren()) do table.insert(items, v) end
    if plr:FindFirstChild("Backpack") then
        for _, v in pairs(plr.Backpack:GetChildren()) do table.insert(items, v) end
    end

    for _, item in pairs(items) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("knife") or n:find("blade") or n:find("bat") or n:find("scythe") then return "Murderer" end
            if n:find("gun") or n:find("revolver") or n:find("laser") then return "Sheriff" end
        end
    end
    return "Innocent"
end

-- Логика кнопок интерфейса
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    EspBtn.Text = Config.ESP and "ESP (Убийца/Шериф): ВКЛ" or "ESP (Убийца/Шериф): ВЫКЛ"
    EspBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
    
    if not Config.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESP_Highlight") then
                plr.Character.ESP_Highlight:Destroy()
            end
        end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimbotBtn.Text = Config.Aimbot and "Аимбот (на Убийцу): ВКЛ" or "Аимбот (на Убийцу): ВЫКЛ"
    AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    SpeedBtn.Text = Config.SpeedHack and "Спидхак (Bypass): ВКЛ" or "Спидхак (Bypass): ВЫКЛ"
    SpeedBtn.BackgroundColor3 = Config.SpeedHack and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    NoclipBtn.Text = Config.NoClip and "NoClip (Сквозь стены): ВКЛ" or "NoClip (Сквозь стены): ВЫКЛ"
    NoclipBtn.BackgroundColor3 = Config.NoClip and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    Config.AutoGun = not Config.AutoGun
    AutoGunBtn.Text = Config.AutoGun and "Авто-пистолет: ВКЛ" or "Авто-пистолет: ВЫКЛ"
    AutoGunBtn.BackgroundColor3 = Config.AutoGun and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

-- NoClip физика (выполняется до просчета физики движком)
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

-- Основной цикл для ESP, Аима, Спидхака и Авто-пистолета
RunService.RenderStepped:Connect(function(deltaTime)
    -- 1. Стабильный ESP
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = p.Character:FindFirstChild("ESP_Highlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.Parent = p.Character
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                
                local role = getRole(p)
                if role ==Я удалил фейковую выдачу скинов (в новых режимах с FilteringEnabled это работает только визуально и бесполезно) и крашащий «Авто-пистолет», который бесконечно телепортировал игрока каждый кадр. 

ESP вынесен из `RenderStepped` в отдельный цикл (чтобы не убивать FPS), а логика Aimbot и Speedhack переписана для большей стабильности и защиты от античита.

```lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedMult = 0.5, -- Множитель скорости для CFrame
    NoClip = false
}

-- Создаем UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Xeno_Lite"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 XENO | OPTIMIZED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = ScreenGui
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.Position = UDim2.new(0, 10, 0, 10)
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "MENU"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Visible = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

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
Instance.new("UIPadding", MainFrame).PaddingTop = UDim.new(0, 45)

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local EspBtn = createBtn("ESP (Динамический): ВЫКЛ")
local AimbotBtn = createBtn("Аимбот на Убийцу: ВЫКЛ")
local SpeedBtn = createBtn("Спидхак (Bypass): ВЫКЛ")
local NoclipBtn = createBtn("NoClip (Сквозь стены): ВЫКЛ")
local TpLobbyBtn = createBtn("Телепорт в Лобби")

-- Определение роли
local function getRole(plr)
    if not plr.Character then return "Innocent" end
    local function checkHasWeapon(parentObj)
        if not parentObj then return nil end
        for _, v in pairs(parentObj:GetChildren()) do
            if v:IsA("Tool") then
                local n = v.Name:lower()
                if n:find("knife") or n:find("blade") or n:find("pitchfork") then return "Murderer" end
                if n:find("gun") or n:find("revolver") then return "Sheriff" end
            end
        end
        return nil
    end
    
    return checkHasWeapon(plr.Character) or checkHasWeapon(plr:FindFirstChild("Backpack")) or "Innocent"
end

-- Логика кнопок
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    EspBtn.Text = Config.ESP and "ESP (Динамический): ВКЛ" or "ESP (Динамический): ВЫКЛ"
    EspBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
    
    if not Config.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Highlight") then
                plr.Character.Highlight:Destroy()
            end
        end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimbotBtn.Text = Config.Aimbot and "Аимбот на Убийцу: ВКЛ" or "Аимбот на Убийцу: ВЫКЛ"
    AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    SpeedBtn.Text = Config.SpeedHack and "Спидхак (Bypass): ВКЛ" or "Спидхак (Bypass): ВЫКЛ"
    SpeedBtn.BackgroundColor3 = Config.SpeedHack and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    NoclipBtn.Text = Config.NoClip and "NoClip (Сквозь стены): ВКЛ" or "NoClip (Сквозь стены): ВЫКЛ"
    NoclipBtn.BackgroundColor3 = Config.NoClip and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

TpLobbyBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-109, 138, 11)
    end
end)

-- Оптимизированный ESP (Обновляется раз в 0.5 сек, не просаживает FPS)
task.spawn(function()
    while task.wait(0.5) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hl = p.Character:FindFirstChild("Highlight")
                    local role = getRole(p)
                    
                    if role ~= "Innocent" then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "Highlight"
                            hl.Parent = p.Character
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        hl.Enabled = true
                        hl.FillColor = (role == "Murderer") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
                    else
                        if hl then hl.Enabled = false end
                    end
                end
            end
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

-- Основной RenderStepped (Только движение и камера)
RunService.RenderStepped:Connect(function()
    -- Аимбот
    if Config.Aimbot then
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    target = p.Character.Head
                    break
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.2)
        end
    end

    -- SpeedHack Bypass
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            -- Плавное смещение CFrame без использования deltaTime для стабильности
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * Config.SpeedMult)
        end
    end
end)
