local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Настройки
local Config = {
    ESP = false,
    CoinESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedValue = 28,
    NoClip = false,
    Fly = false,
    AutoFarm = false,
    FarmDelay = 0.3, -- Задержка фарма по умолчанию
    MaxCoins = 40,
    AutoGunLoop = false,
    AntiAFK = true,
    Fullbright = false
}

-- Вспомогательная функция анимаций (Tween)
local function animate(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Проверка количества монет у игрока
local function getCoinCount()
    local count = 0
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
        if mainGui and mainGui:FindFirstChild("Game") and mainGui.Game:FindFirstChild("CoinBag") then
            local label = mainGui.Game.CoinBag:FindFirstChild("Amount") or mainGui.Game.CoinBag.Container:FindFirstChild("Amount")
            if label and label:IsA("TextLabel") then
                local current = label.Text:match("(%d+)")
                if current then count = tonumber(current) end
            end
        end
    end)
    return count
end

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Ultimate_Mobile"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Плавная кнопка открытия (Floating Button)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
OpenBtn.Position = UDim2.new(0, 12, 0.2, 0)
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "HUB"
OpenBtn.TextColor3 = Color3.fromRGB(0, 180, 255)
OpenBtn.TextSize = 12
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenBtn
OpenStroke.Color = Color3.fromRGB(0, 180, 255)
OpenStroke.Thickness = 1.5

-- Главный контейнер
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.85, 0, 0.72, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainConstraint = Instance.new("UISizeConstraint")
MainConstraint.Parent = MainFrame
MainConstraint.MaxSize = Vector2.new(420, 310)
MainConstraint.MinSize = Vector2.new(290, 240)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(40, 40, 55)
MainStroke.Thickness = 1.5

-- Верхняя панель (Header)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 HUB v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Открытие / Закрытие с анимацией
CloseBtn.MouseButton1Click:Connect(function()
    animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
    task.wait(0.25)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0.85, 0, 0.72, 0)
end)

OpenBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Visible = true
        animate(MainFrame, {Size = UDim2.new(0.85, 0, 0.72, 0)}, 0.25)
    else
        animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
        task.wait(0.25)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0.85, 0, 0.72, 0)
    end
end)

-- Панель Категорий (Анимированная)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.Position = UDim2.new(0, 6, 0, 42)
TabBar.Size = UDim2.new(1, -12, 0, 32)
TabBar.BackgroundTransparency = 1
TabBar.ScrollBarThickness = 0
TabBar.CanvasSize = UDim2.new(1.15, 0, 0, 0)

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 6)

-- Контейнер страниц
local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.Position = UDim2.new(0, 8, 0, 78)
PageContainer.Size = UDim2.new(1, -16, 1, -84)
PageContainer.BackgroundTransparency = 1

local pages = {}
local tabButtons = {}

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Parent = PageContainer
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
    return page
end

local function createTabBtn(text, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.Size = UDim2.new(0, 78, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(150, 150, 170)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabButtons) do
            animate(b, {BackgroundColor3 = Color3.fromRGB(25, 25, 32), TextColor3 = Color3.fromRGB(150, 150, 170)}, 0.15)
        end
        targetPage.Visible = true
        animate(btn, {BackgroundColor3 = Color3.fromRGB(0, 140, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)

    table.insert(tabButtons, btn)
    table.insert(pages, targetPage)
    return btn
end

-- Создание Вкладок
local VisualsPage = createPage()
local MovementPage = createPage()
local FarmPage = createPage()
local TeleportPage = createPage()
local MiscPage = createPage()

local Tab1 = createTabBtn("Визуалы", VisualsPage)
local Tab2 = createTabBtn("Движение", MovementPage)
local Tab3 = createTabBtn("Фарм", FarmPage)
local Tab4 = createTabBtn("Телепорт", TeleportPage)
local Tab5 = createTabBtn("Разное", MiscPage)

VisualsPage.Visible = true
Tab1.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
Tab1.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Конструктор анимированных кнопок
local function createToggleBtn(parent, text)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.Size = UDim2.new(0.98, 0, 0, 34)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.TextSize = 11

    local stroke = Instance.new("UIStroke")
    stroke.Parent = btn
    stroke.Color = Color3.fromRGB(40, 40, 50)
    stroke.Thickness = 1

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Анимация при касании пальцем
    btn.MouseButton1Down:Connect(function()
        animate(btn, {Size = UDim2.new(0.95, 0, 0, 32)}, 0.1)
    end)
    btn.MouseButton1Up:Connect(function()
        animate(btn, {Size = UDim2.new(0.98, 0, 0, 34)}, 0.1)
    end)

    return btn, stroke
end

local function toggleState(btn, stroke, state, textOn, textOff)
    if state then
        btn.Text = textOn
        animate(btn, {BackgroundColor3 = Color3.fromRGB(0, 140, 80)}, 0.2)
        animate(stroke, {Color = Color3.fromRGB(0, 210, 120)}, 0.2)
    else
        btn.Text = textOff
        animate(btn, {BackgroundColor3 = Color3.fromRGB(26, 26, 34)}, 0.2)
        animate(stroke, {Color = Color3.fromRGB(40, 40, 50)}, 0.2)
    end
end

-- 1. ВИЗУАЛЫ
local EspBtn, EspStroke = createToggleBtn(VisualsPage, "ESP Ролей: ВЫКЛ")
local CoinEspBtn, CoinEspStroke = createToggleBtn(VisualsPage, "ESP Монет: ВЫКЛ")
local AimbotBtn, AimbotStroke = createToggleBtn(VisualsPage, "Аимбот на Убийцу: ВЫКЛ")

-- 2. ДВИЖЕНИЕ
local SpeedBtn, SpeedStroke = createToggleBtn(MovementPage, "Спидхак: ВЫКЛ")
local NoclipBtn, NoclipStroke = createToggleBtn(MovementPage, "NoClip: ВЫКЛ")
local FlyBtn, FlyStroke = createToggleBtn(MovementPage, "Полет (Fly): ВЫКЛ")

-- 3. ФАРМ (С настройками)
local CoinStatusLabel = Instance.new("TextLabel")
CoinStatusLabel.Parent = FarmPage
CoinStatusLabel.Size = UDim2.new(0.98, 0, 0, 24)
CoinStatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
CoinStatusLabel.Font = Enum.Font.GothamBold
CoinStatusLabel.Text = "Статус Мешка: 0 / 40"
CoinStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
CoinStatusLabel.TextSize = 11
Instance.new("UICorner", CoinStatusLabel).CornerRadius = UDim.new(0, 5)

local FarmBtn, FarmStroke = createToggleBtn(FarmPage, "Авто-Сбор Монет: ВЫКЛ")

local SpeedSettingBtn = Instance.new("TextButton")
SpeedSettingBtn.Parent = FarmPage
SpeedSettingBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
SpeedSettingBtn.Size = UDim2.new(0.98, 0, 0, 32)
SpeedSettingBtn.Font = Enum.Font.GothamMedium
SpeedSettingBtn.Text = "Задержка Фарма: Нормально (0.3s)"
SpeedSettingBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
SpeedSettingBtn.TextSize = 10
Instance.new("UICorner", SpeedSettingBtn).CornerRadius = UDim.new(0, 6)

SpeedSettingBtn.MouseButton1Click:Connect(function()
    if Config.FarmDelay == 0.3 then
        Config.FarmDelay = 0.1
        SpeedSettingBtn.Text = "Задержка Фарма: Быстро (0.1s)"
    elseif Config.FarmDelay == 0.1 then
        Config.FarmDelay = 0.5
        SpeedSettingBtn.Text = "Задержка Фарма: Медленно (0.5s)"
    else
        Config.FarmDelay = 0.3
        SpeedSettingBtn.Text = "Задержка Фарма: Нормально (0.3s)"
    end
end)

-- 4. ТЕЛЕПОРТЫ
local TpMurdererBtn, _ = createToggleBtn(TeleportPage, "ТП за спину Убийце")
local AutoGunBtn, _ = createToggleBtn(TeleportPage, "Забрать Пистолет")

-- 5. РАЗНОЕ
local AutoGunLoopBtn, AutoGunLoopStroke = createToggleBtn(MiscPage, "Авто-подбор пистолета (Петля): ВЫКЛ")
local FullbrightBtn, FullbrightStroke = createToggleBtn(MiscPage, "Макс. Яркость (Fullbright): ВЫКЛ")
local AntiAfkBtn, AntiAfkStroke = createToggleBtn(MiscPage, "Anti-AFK Защита: ВКЛ")
toggleState(AntiAfkBtn, AntiAfkStroke, true, "Anti-AFK Защита: ВКЛ", "Anti-AFK Защита: ВЫКЛ")

-- Определение Ролей
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

-- Логика кнопок
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    toggleState(EspBtn, EspStroke, Config.ESP, "ESP Ролей: ВКЛ", "ESP Ролей: ВЫКЛ")
    if not Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("RoleHighlight") then
                p.Character.RoleHighlight:Destroy()
            end
        end
    end
end)

CoinEspBtn.MouseButton1Click:Connect(function()
    Config.CoinESP = not Config.CoinESP
    toggleState(CoinEspBtn, CoinEspStroke, Config.CoinESP, "ESP Монет: ВКЛ", "ESP Монет: ВЫКЛ")
    if not Config.CoinESP then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("CoinHighlight") then
                obj.CoinHighlight:Destroy()
            end
        end
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    toggleState(AimbotBtn, AimbotStroke, Config.Aimbot, "Аимбот на Убийцу: ВКЛ", "Аимбот на Убийцу: ВЫКЛ")
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHack = not Config.SpeedHack
    toggleState(SpeedBtn, SpeedStroke, Config.SpeedHack, "Спидхак: ВКЛ", "Спидхак: ВЫКЛ")
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Config.NoClip = not Config.NoClip
    toggleState(NoclipBtn, NoclipStroke, Config.NoClip, "NoClip: ВКЛ", "NoClip: ВЫКЛ")
end)

FlyBtn.MouseButton1Click:Connect(function()
    Config.Fly = not Config.Fly
    toggleState(FlyBtn, FlyStroke, Config.Fly, "Полет (Fly): ВКЛ", "Полет (Fly): ВЫКЛ")
end)

FarmBtn.MouseButton1Click:Connect(function()
    Config.AutoFarm = not Config.AutoFarm
    toggleState(FarmBtn, FarmStroke, Config.AutoFarm, "Авто-Сбор Монет: ВКЛ", "Авто-Сбор Монет: ВЫКЛ")
end)

AutoGunLoopBtn.MouseButton1Click:Connect(function()
    Config.AutoGunLoop = not Config.AutoGunLoop
    toggleState(AutoGunLoopBtn, AutoGunLoopStroke, Config.AutoGunLoop, "Авто-подбор пистолета: ВКЛ", "Авто-подбор пистолета: ВЫКЛ")
end)

FullbrightBtn.MouseButton1Click:Connect(function()
    Config.Fullbright = not Config.Fullbright
    toggleState(FullbrightBtn, FullbrightStroke, Config.Fullbright, "Макс. Яркость: ВКЛ", "Макс. Яркость: ВЫКЛ")
    if Config.Fullbright then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
    end
end)

AntiAfkBtn.MouseButton1Click:Connect(function()
    Config.AntiAFK = not Config.AntiAFK
    toggleState(AntiAfkBtn, AntiAfkStroke, Config.AntiAFK, "Anti-AFK Защита: ВКЛ", "Anti-AFK Защита: ВЫКЛ")
end)

TpMurdererBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                TpMurdererBtn.Text = "ТП Выполнен!"
                task.wait(1)
                TpMurdererBtn.Text = "ТП за спину Убийце"
                return
            end
        end
    end
    TpMurdererBtn.Text = "Убийца не найден!"
    task.wait(1)
    TpMurdererBtn.Text = "ТП за спину Убийце"
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
    if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        AutoGunBtn.Text = "Пистолет поднят!"
    else
        AutoGunBtn.Text = "Пистолета нет!"
    end
    task.wait(1)
    AutoGunBtn.Text = "Забрать Пистолет"
end)

-- УМНЫЙ АВТОФАРМ МОНЕТ С ПРОВЕРКОЙ НА 40 МОНЕТ
task.spawn(function()
    while true do
        task.wait(Config.FarmDelay)
        local currentCoins = getCoinCount()
        CoinStatusLabel.Text = string.format("Статус Мешка: %d / %d", currentCoins, Config.MaxCoins)

        if currentCoins >= Config.MaxCoins and Config.AutoFarm then
            Config.AutoFarm = false
            toggleState(FarmBtn, FarmStroke, false, "Авто-Сбор Монет: ВКЛ", "Авто-Сбор Монет: ВЫКЛ (МЕШОК ПОЛОН!)")
            CoinStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 100)
        elseif Config.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            CoinStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
            local targetCoin = nil

            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name == "Coin" or obj.Name == "CoinServer") and obj:IsA("BasePart") then
                    targetCoin = obj
                    break
                end
            end

            if targetCoin then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCoin.CFrame
            end
        end
    end
end)

-- АВТО-ПОДБОР ПИСТОЛЕТА (Петля)
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoGunLoop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local gunDrop = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
            if gunDrop then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
end)

-- COIN ESP И ИГРОКИ ESP
task.spawn(function()
    while task.wait(0.4) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role = getRole(p)
                    local hl = p.Character:FindFirstChild("RoleHighlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "RoleHighlight"
                        hl.Parent = p.Character
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    if role == "Murderer" then
                        hl.FillColor = Color3.fromRGB(255, 40, 40)
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(40, 140, 255)
                    else
                        hl.FillColor = Color3.fromRGB(40, 255, 100)
                    end
                end
            end
        end

        if Config.CoinESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name == "Coin" or obj.Name == "CoinServer") and obj:IsA("BasePart") then
                    if not obj:FindFirstChild("CoinHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "CoinHighlight"
                        hl.Parent = obj
                        hl.FillColor = Color3.fromRGB(255, 220, 0)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
        end
    end
end)

-- ANTI-AFK СИСТЕМА
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- РЕНДЕР ДВИЖЕНИЯ И АИМБОТА
RunService.RenderStepped:Connect(function(dt)
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue * dt * 1.6))
        end
    end

    if Config.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end

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

-- NOCLIP
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
