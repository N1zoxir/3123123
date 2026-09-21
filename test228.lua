local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedValue = 26, -- Оптимальная скорость (по умолчанию в игре 16)
    NoClip = false,
    Fly = false
}

-- UI Элементы
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Xeno_Modern_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -230)
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1.5

-- Шапка
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "  MM2 HUB | ULTIMATE"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Информационная строка (Статус Убийцы и Дистанция)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 10, 0, 43)
StatusLabel.Size = UDim2.new(1, -20, 0, 22)
StatusLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Убийца: Поиск... | Дистанция: -- m"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
StatusLabel.TextSize = 11
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 5)

-- Кнопки управления окном
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = ScreenGui
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
MinBtn.Position = UDim2.new(0, 15, 0, 15)
MinBtn.Size = UDim2.new(0, 45, 0, 45)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "HUB"
MinBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MinBtn.TextSize = 12
MinBtn.Visible = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 10)
local MinStroke = Instance.new("UIStroke")
MinStroke.Parent = MinBtn
MinStroke.Color = Color3.fromRGB(0, 170, 255)
MinStroke.Thickness = 1

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinBtn.Visible = true
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinBtn.Visible = false
end)

-- Контейнер со скроллом
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = MainFrame
ScrollContainer.Position = UDim2.new(0, 5, 0, 70)
ScrollContainer.Size = UDim2.new(1, -10, 1, -75)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 380)

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollContainer
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local function createCategory(name)
    local label = Instance.new("TextLabel")
    label.Parent = ScrollContainer
    label.Size = UDim2.new(0, 290, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "— " .. name .. " —"
    label.TextColor3 = Color3.fromRGB(120, 120, 140)
    label.TextSize = 11
end

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    btn.Size = UDim2.new(0, 290, 0, 36)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = btn
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn, stroke
end

-- Создание категорий
createCategory("ВИЗУАЛЫ & БОЙ")
local EspBtn, EspStroke = createBtn("ESP (Подсветка ролей): ВЫКЛ")
local AimbotBtn, AimbotStroke = createBtn("Аимбот на Убийцу: ВЫКЛ")

createCategory("ПЕРЕМЕЩЕНИЕ")
local SpeedBtn, SpeedStroke = createBtn("Спидхак (Плавный): ВЫКЛ")
local NoclipBtn, NoclipStroke = createBtn("NoClip (Сквозь стены): ВЫКЛ")
local FlyBtn, FlyStroke = createBtn("Полет (Fly): ВЫКЛ")

createCategory("ТЕЛЕПОРТЫ")
local TpMurdererBtn = createBtn("ТП к Убийце (Дистанция 5m)")
local AutoGunBtn = createBtn("Забрать Пистолет (АвтоTP)")

-- Поиск ролей
local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local containers = {plr.Character, plr:FindFirstChild("Backpack")}
    
    for _, parentObj in ipairs(containers) do
        if parentObj then
            for _, item in ipairs(parentObj:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if name:find("knife") or name:find("blade") or name:find("scythe") or name:find("slash") then
                        return "Murderer"
                    elseif name:find("gun") or name:find("revolver") or name:find("sheriff") then
                        return "Sheriff"
                    end
                end
            end
        end
    end
    return "Innocent"
end

local function toggleButton(btn, stroke, state, activeText, inactiveText)
    if state then
        btn.Text = activeText
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
        stroke.Color = Color3.fromRGB(0, 200, 120)
    else
        btn.Text = inactiveText
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        stroke.Color = Color3.fromRGB(45, 45, 55)
    end
end

EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    toggleButton(EspBtn, EspStroke, Config.ESP, "ESP (Подсветка ролей): ВКЛ", "ESP (Подсветка ролей): ВЫКЛ")
    
    if not Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    toggleButton(AimbotBtn, AimbotStroke, Config.Aimbot, "Аимбот на Убийцу: ВКЛ", "Аимбот на Убийцу: ВЫКЛ")
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    toggleButton(SpeedBtn, SpeedStroke, Config.SpeedHack, "Спидхак (Плавный): ВКЛ", "Спидхак (Плавный): ВЫКЛ")
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    toggleButton(NoclipBtn, NoclipStroke, Config.NoClip, "NoClip (Сквозь стены): ВКЛ", "NoClip (Сквозь стены): ВЫКЛ")
end)

FlyBtn.MouseButton1Click:Connect(function()
    Config.Fly = not Config.Fly
    toggleButton(FlyBtn, FlyStroke, Config.Fly, "Полет (Fly): ВКЛ", "Полет (Fly): ВЫКЛ")
end)

-- Телепорт к Убийце (5 метров позади него)
TpMurdererBtn.MouseButton1Click:Connect(function()
    local found = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local murdererHRP = p.Character.HumanoidRootPart
                LocalPlayer.Character.HumanoidRootPart.CFrame = murdererHRP.CFrame * CFrame.new(0, 0, 5)
                found = true
                TpMurdererBtn.Text = "ТП за спину " .. p.Name .. "!"
                break
            end
        end
    end
    if not found then
        TpMurdererBtn.Text = "Убийца не найден!"
    end
    task.wait(1.5)
    TpMurdererBtn.Text = "ТП к Убийце (Дистанция 5m)"
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
    if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        AutoGunBtn.Text = "Пистолет поднят!"
    else
        AutoGunBtn.Text = "Пистолета нет на карте!"
    end
    task.wait(1.5)
    AutoGunBtn.Text = "Забрать Пистолет (АвтоTP)"
end)

-- Расчет дистанции в реальном времени
task.spawn(function()
    while task.wait(0.2) do
        local murdererFound = false
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                murdererFound = true
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    StatusLabel.Text = string.format("Убийца: %s | Дистанция: %.1fm", p.Name, dist)
                    if dist <= 15 then
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                    else
                        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                    end
                end
                break
            end
        end
        if not murdererFound then
            StatusLabel.Text = "Убийца: Не найден | Дистанция: -- m"
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end
end)

-- Цикл ESP
task.spawn(function()
    while task.wait(0.3) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role = getRole(p)
                    local hl = p.Character:FindFirstChild("Highlight")
                    
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "Highlight"
                        hl.Parent = p.Character
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    
                    if role == "Murderer" then
                        hl.FillColor = Color3.fromRGB(255, 30, 30)
                        hl.Enabled = true
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(30, 140, 255)
                        hl.Enabled = true
                    else
                        hl.FillColor = Color3.fromRGB(30, 255, 100)
                        hl.Enabled = true
                    end
                end
            end
        end
    end
end)

-- Физика NoClip
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Физический Спидхак (без отбрасываний)
RunService.Heartbeat:Connect(function()
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            local currentY = hrp.AssemblyLinearVelocity.Y
            local moveVel = hum.MoveDirection * Config.SpeedValue
            hrp.AssemblyLinearVelocity = Vector3.new(moveVel.X, currentY, moveVel.Z)
        end
    end
end)

-- Аимбот и Полет
RunService.RenderStepped:Connect(function()
    -- Аимбот на Убийцу
    if Config.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end

    -- Полет (Fly)
    if Config.Fly and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and hum then
            hrp.AssemblyLinearVelocity = Vector3.zero
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (moveDir.Z * -1) + Camera.CFrame.RightVector * moveDir.X) * 1.2
            else
                hrp.CFrame = CFrame.new(hrp.CFrame.Position, hrp.CFrame.Position + Camera.CFrame.LookVector)
            end
        end
    end
end)
