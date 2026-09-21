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
    SpeedValue = 26,
    NoClip = false,
    Fly = false,
    FlySpeed = 30,
    AutoFarm = false,
    FarmDelay = 0.3,
    MaxCoins = 40,
    AutoGunLoop = false,
    AntiAFK = true,
    Fullbright = false
}

-- Плавная анимация интерфейса
local function animate(instance, properties, duration)
    return TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
end

-- Точный подсчет монет
local function getCoinCount()
    local count = 0
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
        if mainGui then
            local coinBag = mainGui:FindFirstChild("CoinBag", true)
            if coinBag then
                local amountLabel = coinBag:FindFirstChild("Amount", true)
                if amountLabel and amountLabel:IsA("TextLabel") then
                    local current = amountLabel.Text:match("(%d+)")
                    if current then count = tonumber(current) end
                end
            end
        end
    end)
    return count
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Fix_Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Всплывающие уведомления
local function notify(text, color)
    task.spawn(function()
        local card = Instance.new("Frame", ScreenGui)
        card.Position = UDim2.new(0.5, -110, 0.08, 0)
        card.Size = UDim2.new(0, 220, 0, 32)
        card.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        card.BackgroundTransparency = 1
        card.ZIndex = 200
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", card)
        stroke.Color = color or Color3.fromRGB(0, 170, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 1

        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(240, 240, 255)
        label.TextSize = 11
        label.TextTransparency = 1

        animate(card, {BackgroundTransparency = 0.1}, 0.2)
        animate(stroke, {Transparency = 0}, 0.2)
        animate(label, {TextTransparency = 0}, 0.2)

        task.wait(1.5)

        animate(card, {BackgroundTransparency = 1}, 0.2)
        animate(stroke, {Transparency = 1}, 0.2)
        animate(label, {TextTransparency = 1}, 0.2)
        task.wait(0.2)
        card:Destroy()
    end)
end

-- Кнопка открытия HUB
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
OpenBtn.Position = UDim2.new(0, 12, 0.35, 0)
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "HUB"
OpenBtn.TextColor3 = Color3.fromRGB(0, 180, 255)
OpenBtn.TextSize = 12
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(0, 180, 255)
OpenStroke.Thickness = 1.5

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 340, 0, 270)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(35, 35, 48)
MainStroke.Thickness = 1.5

-- Хедер
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)

local Title = Instance.new("TextLabel", TopBar)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 ULTIMATE // FIXED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local isMenuOpen = true
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        MainFrame.Visible = true
        animate(MainFrame, {Size = UDim2.new(0, 340, 0, 270)}, 0.2)
    else
        animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        MainFrame.Visible = false
    end
end

OpenBtn.MouseButton1Click:Connect(toggleMenu)
CloseBtn.MouseButton1Click:Connect(toggleMenu)

-- Вкладки
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.Size = UDim2.new(1, -16, 0, 28)
TabBar.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 4)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 8, 0, 76)
PageContainer.Size = UDim2.new(1, -16, 1, -82)
PageContainer.BackgroundTransparency = 1

local pages, tabButtons = {}, {}

local function createPage()
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 5)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
    end)
    return page
end

local function createTabBtn(text, targetPage)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(130, 130, 150)
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabButtons) do
            animate(b, {BackgroundColor3 = Color3.fromRGB(22, 22, 30), TextColor3 = Color3.fromRGB(130, 130, 150)}, 0.15)
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

-- Конструктор переключателей (Toggle)
local function createToggle(parent, titleText, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.98, 0, 0, 32)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = Color3.fromRGB(32, 32, 44)
    stroke.Thickness = 1

    local label = Instance.new("TextLabel", container)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(210, 210, 225)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switchBg = Instance.new("Frame", container)
    switchBg.Position = UDim2.new(1, -40, 0.5, -8)
    switchBg.Size = UDim2.new(0, 32, 0, 16)
    switchBg.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.Size = UDim2.new(0, 12, 0, 12)
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
            animate(knob, {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
            animate(switchBg, {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}, 0.15)
            animate(stroke, {Color = Color3.fromRGB(0, 200, 110)}, 0.15)
            notify(titleText .. ": ВКЛ", Color3.fromRGB(0, 200, 110))
        else
            animate(knob, {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(180, 180, 200)}, 0.15)
            animate(switchBg, {BackgroundColor3 = Color3.fromRGB(38, 38, 50)}, 0.15)
            animate(stroke, {Color = Color3.fromRGB(32, 32, 44)}, 0.15)
            notify(titleText .. ": ВЫКЛ", Color3.fromRGB(230, 60, 60))
        end
        callback(state)
    end)
    return container
end

-- Вкладка: Визуалы
createToggle(VisualsPage, "ESP Ролей", function(val)
    Config.ESP = val
    if not val then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("RoleHighlight") then
                p.Character.RoleHighlight:Destroy()
            end
        end
    end
end)

createToggle(VisualsPage, "ESP Монет", function(val)
    Config.CoinESP = val
    if not val then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("CoinHighlight") then
                obj.CoinHighlight:Destroy()
            end
        end
    end
end)

createToggle(VisualsPage, "Аимбот на Убийцу", function(val) Config.Aimbot = val end)

-- Вкладка: Движение
createToggle(MovementPage, "Спидхак", function(val) Config.SpeedHack = val end)
createToggle(MovementPage, "NoClip (Сквозь стены)", function(val) Config.NoClip = val end)
createToggle(MovementPage, "Исправленный Fly", function(val) Config.Fly = val end)

-- Вкладка: Фарм
local CoinStatusLabel = Instance.new("TextLabel", FarmPage)
CoinStatusLabel.Size = UDim2.new(0.98, 0, 0, 26)
CoinStatusLabel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
CoinStatusLabel.Font = Enum.Font.GothamBold
CoinStatusLabel.Text = "Статус Мешка: 0 / 40"
CoinStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
CoinStatusLabel.TextSize = 11
Instance.new("UICorner", CoinStatusLabel).CornerRadius = UDim.new(0, 5)

createToggle(FarmPage, "Безопасный Авто-Фарм", function(val) Config.AutoFarm = val end)

local SpeedSettingBtn = Instance.new("TextButton", FarmPage)
SpeedSettingBtn.Size = UDim2.new(0.98, 0, 0, 30)
SpeedSettingBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
SpeedSettingBtn.Font = Enum.Font.GothamMedium
SpeedSettingBtn.Text = "Задержка: Безопасная (0.3s)"
SpeedSettingBtn.TextColor3 = Color3.fromRGB(190, 190, 210)
SpeedSettingBtn.TextSize = 10
Instance.new("UICorner", SpeedSettingBtn).CornerRadius = UDim.new(0, 5)

SpeedSettingBtn.MouseButton1Click:Connect(function()
    if Config.FarmDelay == 0.3 then
        Config.FarmDelay = 0.5
        SpeedSettingBtn.Text = "Задержка: Очень безопасная (0.5s)"
    elseif Config.FarmDelay == 0.5 then
        Config.FarmDelay = 0.2
        SpeedSettingBtn.Text = "Задержка: Быстрая (0.2s - Риск)"
    else
        Config.FarmDelay = 0.3
        SpeedSettingBtn.Text = "Задержка: Безопасная (0.3s)"
    end
end)

-- Вкладка: Телепорт
local function createActionBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.98, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
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
                notify("ТП Выполнен", Color3.fromRGB(0, 200, 110))
                return
            end
        end
    end
    notify("Убийца не найден", Color3.fromRGB(230, 60, 60))
end)

createActionBtn(TeleportPage, "Забрать Пистолет", function()
    local gun = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
    if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame + Vector3.new(0, 2, 0)
        notify("Пистолет забран", Color3.fromRGB(0, 200, 110))
    else
        notify("Пистолет не найден", Color3.fromRGB(230, 60, 60))
    end
end)

-- Вкладка: Разное
createToggle(MiscPage, "Авто-подбор пистолета", function(val) Config.AutoGunLoop = val end)
createToggle(MiscPage, "Максимальная Яркость", function(val)
    Config.Fullbright = val
    game:GetService("Lighting").Ambient = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(127, 127, 127)
end)
createToggle(MiscPage, "Anti-AFK Защита", function(val) Config.AntiAFK = val end)

-- ЛОГИКА БЕЗОПАСНОГО АВТОФАРМА (Плавный ТП вместо прыжка, защита от кика)
task.spawn(function()
    while true do
        task.wait(Config.FarmDelay)
        local count = getCoinCount()
        CoinStatusLabel.Text = string.format("Статус Мешка: %d / %d", count, Config.MaxCoins)

        if Config.AutoFarm then
            if count >= Config.MaxCoins then
                Config.AutoFarm = false
                notify("Мешок полон (40/40)!", Color3.fromRGB(255, 200, 0))
            else
                local targetCoin = nil
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
                    local dist = (hrp.Position - targetCoin.Position).Magnitude
                    
                    -- Плавное перемещение (Tween), чтобы античит не кикал за телепорт
                    local moveTime = math.clamp(dist / 38, 0.1, 0.8)
                    local tween = TweenService:Create(hrp, TweenInfo.new(moveTime, Enum.EasingStyle.Linear), {CFrame = targetCoin.CFrame})
                    tween:Play()
                    tween.Completed:Wait()

                    if firetouchinterest and targetCoin and targetCoin.Parent then
                        firetouchinterest(hrp, targetCoin, 0)
                        task.wait(0.01)
                        firetouchinterest(hrp, targetCoin, 1)
                    end
                end
            end
        end
    end
end)

-- ОБНОВЛЕНИЕ ESP РОЛЕЙ И МОНЕТ
task.spawn(function()
    while task.wait(0.3) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role = "Innocent"
                    local containers = {p.Character, p:FindFirstChild("Backpack")}
                    for _, container in ipairs(containers) do
                        if container then
                            for _, item in ipairs(container:GetChildren()) do
                                if item:IsA("Tool") then
                                    local name = item.Name:lower()
                                    if name:find("knife") or name:find("blade") or name:find("scythe") or name:find("slash") then
                                        role = "Murderer"
                                    elseif name:find("gun") or name:find("revolver") or name:find("sheriff") or name:find("hero") then
                                        role = "Sheriff"
                                    end
                                end
                            end
                        end
                    end

                    local hl = p.Character:FindFirstChild("RoleHighlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "RoleHighlight"
                        hl.Parent = p.Character
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end

                    if role == "Murderer" then
                        hl.FillColor = Color3.fromRGB(255, 30, 30)
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(30, 140, 255)
                    else
                        hl.FillColor = Color3.fromRGB(30, 220, 100)
                    end
                end
            end
        end

        if Config.CoinESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name == "Coin" or obj.Name == "CoinServer" or obj.Name == "MainCoin") and obj:IsA("BasePart") then
                    if not obj:FindFirstChild("CoinHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "CoinHighlight"
                        hl.Parent = obj
                        hl.FillColor = Color3.fromRGB(255, 215, 0)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
        end
    end
end)

-- ИСПРАВЛЕННЫЙ FLY (БЕЗ ИНВЕРСИИ) И SPEEDHACK
RunService.RenderStepped:Connect(function(dt)
    if Config.Fly and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and hum then
            hrp.AssemblyLinearVelocity = Vector3.zero
            local moveVector = hum.MoveDirection
            if moveVector.Magnitude > 0 then
                local camCF = Camera.CFrame
                local forward = camCF.LookVector
                local right = camCF.RightVector

                local flatForward = Vector3.new(forward.X, 0, forward.Z).Unit
                local flatRight = Vector3.new(right.X, 0, right.Z).Unit

                local forwardDot = moveVector:Dot(flatForward)
                local rightDot = moveVector:Dot(flatRight)

                local finalDir = (forward * forwardDot + right * rightDot)
                if finalDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (finalDir.Unit * (Config.FlySpeed * dt * 1.2))
                end
            end
        end
    end

    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue * dt * 1.4))
        end
    end

    if Config.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local isMurderer = false
                for _, item in ipairs(p.Character:GetChildren()) do
                    if item:IsA("Tool") and item.Name:lower():find("knife") then isMurderer = true end
                end
                if isMurderer then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                    break
                end
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

notify("Все функции успешно исправлены!", Color3.fromRGB(0, 200, 110))
