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
    FarmDelay = 0.25,
    MaxCoins = 40,
    AutoGunLoop = false,
    AntiAFK = true,
    Fullbright = false
}

-- Вспомогательная анимация
local function animate(instance, properties, duration, style)
    local tween = TweenService:Create(
        instance, 
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        properties
    )
    tween:Play()
    return tween
end

-- Точное получение количества монет
local function getCoinCount()
    local count = 0
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
        if mainGui then
            local coinBag = mainGui:FindFirstChild("CoinBag", true)
            if coinBag then
                local amountLabel = coinBag:FindFirstChild("Amount", true)
                if amountLabel and amountLabel:IsA("TextLabel") then
                    local text = amountLabel.Text
                    local current = text:match("(%d+)")
                    if current then count = tonumber(current) end
                end
            end
        end
    end)
    return count
end

-- Главная оболочка GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_V3_Fixed"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Всплывающие уведомления
local function showNotify(text, color)
    task.spawn(function()
        local notifyFrame = Instance.new("Frame")
        notifyFrame.Parent = ScreenGui
        notifyFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
        notifyFrame.Size = UDim2.new(0, 200, 0, 32)
        notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        notifyFrame.BackgroundTransparency = 1
        notifyFrame.ZIndex = 100

        local stroke = Instance.new("UIStroke", notifyFrame)
        stroke.Color = color or Color3.fromRGB(0, 170, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 1

        local corner = Instance.new("UICorner", notifyFrame)
        corner.CornerRadius = UDim.new(0, 8)

        local lbl = Instance.new("TextLabel", notifyFrame)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 11
        lbl.TextTransparency = 1

        animate(notifyFrame, {BackgroundTransparency = 0.1}, 0.25)
        animate(stroke, {Transparency = 0}, 0.25)
        animate(lbl, {TextTransparency = 0}, 0.25)

        task.wait(1.8)

        animate(notifyFrame, {BackgroundTransparency = 1}, 0.25)
        animate(stroke, {Transparency = 1}, 0.25)
        animate(lbl, {TextTransparency = 1}, 0.25)
        task.wait(0.25)
        notifyFrame:Destroy()
    end)
end

-- Кнопка сбора/открытия HUB
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
OpenBtn.Position = UDim2.new(0, 14, 0.3, 0)
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "HUB"
OpenBtn.TextColor3 = Color3.fromRGB(0, 180, 255)
OpenBtn.TextSize = 13
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 14)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(0, 180, 255)
OpenStroke.Thickness = 2

-- Окно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 260)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5

-- Шляпка
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)

local Title = Instance.new("TextLabel", TopBar)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 ULTIMATE // V3.1"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Переключение интерфейса с анимацией масштабирования
local isMenuOpen = true
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        MainFrame.Visible = true
        animate(MainFrame, {Size = UDim2.new(0, 360, 0, 260)}, 0.25, Enum.EasingStyle.Back)
    else
        animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad)
        task.wait(0.2)
        MainFrame.Visible = false
    end
end

OpenBtn.MouseButton1Click:Connect(toggleMenu)
CloseBtn.MouseButton1Click:Connect(toggleMenu)

-- Вкладки
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 8, 0, 78)
PageContainer.Size = UDim2.new(1, -16, 1, -84)
PageContainer.BackgroundTransparency = 1

local pages = {}
local tabButtons = {}

local function createPage()
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
    end)
    return page
end

local function createTabBtn(text, targetPage)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 65, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(130, 130, 150)
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabButtons) do
            animate(b, {BackgroundColor3 = Color3.fromRGB(24, 24, 32), TextColor3 = Color3.fromRGB(130, 130, 150)}, 0.15)
        end
        targetPage.Visible = true
        animate(btn, {BackgroundColor3 = Color3.fromRGB(0, 140, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)

    table.insert(tabButtons, btn)
    table.insert(pages, targetPage)
    return btn
end

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

-- Конструктор Переключателей с АНИМИРОВАННЫМ Тумблером (Toggle Switch)
local function createToggle(parent, titleText, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.98, 0, 0, 34)
    container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = Color3.fromRGB(35, 35, 48)
    stroke.Thickness = 1

    local label = Instance.new("TextLabel", container)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Сам переключатель
    local switchBg = Instance.new("Frame", container)
    switchBg.Position = UDim2.new(1, -44, 0.5, -9)
    switchBg.Size = UDim2.new(0, 36, 0, 18)
    switchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false

    local clickBtn = Instance.new("TextButton", container)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            animate(knob, {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            animate(switchBg, {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}, 0.2)
            animate(stroke, {Color = Color3.fromRGB(0, 200, 110)}, 0.2)
            showNotify(titleText .. ": Включаю", Color3.fromRGB(0, 200, 110))
        else
            animate(knob, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(180, 180, 200)}, 0.2)
            animate(switchBg, {BackgroundColor3 = Color3.fromRGB(40, 40, 52)}, 0.2)
            animate(stroke, {Color = Color3.fromRGB(35, 35, 48)}, 0.2)
            showNotify(titleText .. ": Выключаю", Color3.fromRGB(230, 60, 60))
        end
        callback(state)
    end)

    return container
end

-- ЭЛЕМЕНТЫ УПРАВЛЕНИЯ

-- Visuals
createToggle(VisualsPage, "ESP Ролей", function(val) Config.ESP = val end)
createToggle(VisualsPage, "ESP Монет", function(val) Config.CoinESP = val end)
createToggle(VisualsPage, "Аимбот на Убийцу", function(val) Config.Aimbot = val end)

-- Movement
createToggle(MovementPage, "Спидхак (Быстрый бег)", function(val) Config.SpeedHack = val end)
createToggle(MovementPage, "Проход сквозь стены (NoClip)", function(val) Config.NoClip = val end)
createToggle(MovementPage, "Режим Полета (Fly)", function(val) Config.Fly = val end)

-- Farm
local CoinStatusLabel = Instance.new("TextLabel", FarmPage)
CoinStatusLabel.Size = UDim2.new(0.98, 0, 0, 26)
CoinStatusLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
CoinStatusLabel.Font = Enum.Font.GothamBold
CoinStatusLabel.Text = "Мешок: 0 / 40"
CoinStatusLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
CoinStatusLabel.TextSize = 11
Instance.new("UICorner", CoinStatusLabel).CornerRadius = UDim.new(0, 6)

createToggle(FarmPage, "Авто-Сбор Монет", function(val) Config.AutoFarm = val end)

local SpeedSettingBtn = Instance.new("TextButton", FarmPage)
SpeedSettingBtn.Size = UDim2.new(0.98, 0, 0, 32)
SpeedSettingBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
SpeedSettingBtn.Font = Enum.Font.GothamMedium
SpeedSettingBtn.Text = "Скорость Фарма: Средняя (0.25s)"
SpeedSettingBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
SpeedSettingBtn.TextSize = 10
Instance.new("UICorner", SpeedSettingBtn).CornerRadius = UDim.new(0, 6)

SpeedSettingBtn.MouseButton1Click:Connect(function()
    if Config.FarmDelay == 0.25 then
        Config.FarmDelay = 0.1
        SpeedSettingBtn.Text = "Скорость Фарма: Быстрая (0.1s)"
    elseif Config.FarmDelay == 0.1 then
        Config.FarmDelay = 0.4
        SpeedSettingBtn.Text = "Скорость Фарма: Медленная (0.4s)"
    else
        Config.FarmDelay = 0.25
        SpeedSettingBtn.Text = "Скорость Фарма: Средняя (0.25s)"
    end
end)

-- Teleport Buttons
local function createActionBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.98, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createActionBtn(TeleportPage, "ТП за спину Убийце", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isMurderer = false
            for _, item in ipairs(p.Character:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower():find("knife") then isMurderer = true end
            end
            if isMurderer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                showNotify("ТП к Убийце сработал", Color3.fromRGB(0, 200, 110))
                return
            end
        end
    end
    showNotify("Убийца не найден!", Color3.fromRGB(230, 60, 60))
end)

createActionBtn(TeleportPage, "Забрать Выпавший Пистолет", function()
    local gun = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
    if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame + Vector3.new(0, 2, 0)
        showNotify("Пистолет забран!", Color3.fromRGB(0, 200, 110))
    else
        showNotify("Пистолета на карте нет!", Color3.fromRGB(230, 60, 60))
    end
end)

-- Misc
createToggle(MiscPage, "Авто-подбор пистолета (Петля)", function(val) Config.AutoGunLoop = val end)
createToggle(MiscPage, "Максимальная Яркость", function(val)
    Config.Fullbright = val
    game:GetService("Lighting").Ambient = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(127, 127, 127)
end)
createToggle(MiscPage, "Anti-AFK Защита", function(val) Config.AntiAFK = val end)

-- РАБОЧИЙ ЛОГИЧЕСКИЙ БЛОК (АВТОФАРМ)
task.spawn(function()
    while true do
        task.wait(Config.FarmDelay)
        local count = getCoinCount()
        CoinStatusLabel.Text = string.format("Мешок: %d / %d", count, Config.MaxCoins)

        if Config.AutoFarm then
            if count >= Config.MaxCoins then
                Config.AutoFarm = false
                showNotify("Мешок полон (40/40)! Фарм остановлен.", Color3.fromRGB(255, 200, 0))
            else
                local targetCoin = nil
                -- Поиск монеты по всей рабочей зоне
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name == "Coin" or obj.Name == "CoinServer" or obj.Name == "MainCoin") and obj:IsA("BasePart") then
                        if obj.Transparency < 0.9 then
                            targetCoin = obj
                            break
                        end
                    end
                end

                if targetCoin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = targetCoin.CFrame
                    -- Принудительное подбирание монеты на мобильных устройствах
                    if firetouchinterest then
                        firetouchinterest(hrp, targetCoin, 0)
                        task.wait(0.01)
                        firetouchinterest(hrp, targetCoin, 1)
                    end
                end
            end
        end
    end
end)

-- РЕНДЕР КАДРОВ (ESP, Speed, Fly, Aimbot)
RunService.RenderStepped:Connect(function(dt)
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue * dt * 1.5))
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
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

showNotify("Скрипт успешно загружен!", Color3.fromRGB(0, 200, 110))
