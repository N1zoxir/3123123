local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedValue = 28,
    NoClip = false,
    Fly = false,
    AutoFarm = false
}

-- UI Главный контейнер
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Кнопка открытия/закрытия для мобилок (плавающая)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
OpenBtn.Position = UDim2.new(0, 10, 0.15, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "HUB"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.TextSize = 13
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenBtn
OpenStroke.Color = Color3.fromRGB(0, 170, 255)
OpenStroke.Thickness = 1.5

-- Главное окно (центрированное и адаптивное)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.88, 0, 0.75, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainConstraint = Instance.new("UISizeConstraint")
MainConstraint.Parent = MainFrame
MainConstraint.MaxSize = Vector2.new(420, 320)
MainConstraint.MinSize = Vector2.new(280, 240)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5

-- Шапка
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 HUB | MOBILE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Position = UDim2.new(1, -30, 0.5, -11)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Панель категорий (Вкладки сверху)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.Position = UDim2.new(0, 5, 0, 40)
TabBar.Size = UDim2.new(1, -10, 0, 32)
TabBar.BackgroundTransparency = 1
TabBar.ScrollBarThickness = 0
TabBar.CanvasSize = UDim2.new(1.1, 0, 0, 0)

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)

-- Контейнер страниц
local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.Position = UDim2.new(0, 8, 0, 76)
PageContainer.Size = UDim2.new(1, -16, 1, -84)
PageContainer.BackgroundTransparency = 1

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
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
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    return page
end

local function createTabBtn(text, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
        targetPage.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabButtons, btn)
    table.insert(pages, targetPage)
    return btn
end

-- Создание страниц
local VisualsPage = createPage("Visuals")
local MovementPage = createPage("Movement")
local TeleportPage = createPage("Teleport")
local FarmPage = createPage("Farm")

-- Создание кнопок вверху
local Tab1 = createTabBtn("Визуалы", VisualsPage)
local Tab2 = createTabBtn("Движение", MovementPage)
local Tab3 = createTabBtn("Телепорт", TeleportPage)
local Tab4 = createTabBtn("Фарм", FarmPage)

-- По умолчанию открыта первая вкладка
VisualsPage.Visible = true
Tab1.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
Tab1.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Конструктор UI элементов
local function createToggleBtn(parent, text)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Size = UDim2.new(0.98, 0, 0, 36)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 11

    local stroke = Instance.new("UIStroke")
    stroke.Parent = btn
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn, stroke
end

local function toggleState(btn, stroke, state, textOn, textOff)
    if state then
        btn.Text = textOn
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
        stroke.Color = Color3.fromRGB(0, 200, 120)
    else
        btn.Text = textOff
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        stroke.Color = Color3.fromRGB(45, 45, 60)
    end
end

-- Вкладка: ВИЗУАЛЫ
local EspBtn, EspStroke = createToggleBtn(VisualsPage, "ESP Ролей: ВЫКЛ")
local AimbotBtn, AimbotStroke = createToggleBtn(VisualsPage, "Аимбот на Убийцу: ВЫКЛ")

-- Вкладка: ДВИЖЕНИЕ
local SpeedBtn, SpeedStroke = createToggleBtn(MovementPage, "Спидхак: ВЫКЛ")
local NoclipBtn, NoclipStroke = createToggleBtn(MovementPage, "NoClip: ВЫКЛ")
local FlyBtn, FlyStroke = createToggleBtn(MovementPage, "Полет (Fly): ВЫКЛ")

-- Вкладка: ТЕЛЕПОРТЫ
local TpMurdererBtn, _ = createToggleBtn(TeleportPage, "ТП за спину Убийце")
local AutoGunBtn, _ = createToggleBtn(TeleportPage, "Забрать Пистолет")

-- Вкладка: ФАРМ
local FarmBtn, FarmStroke = createToggleBtn(FarmPage, "Авто-сбор монет: ВЫКЛ")

-- Определение ролей
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

-- Логика переключателей
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    toggleState(EspBtn, EspStroke, Config.ESP, "ESP Ролей: ВКЛ", "ESP Ролей: ВЫКЛ")
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
    toggleState(FarmBtn, FarmStroke, Config.AutoFarm, "Авто-сбор монет: ВКЛ", "Авто-сбор монет: ВЫКЛ")
end)

TpMurdererBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                TpMurdererBtn.Text = "ТП выполнен!"
                task.wait(1.2)
                TpMurdererBtn.Text = "ТП за спину Убийце"
                return
            end
        end
    end
    TpMurdererBtn.Text = "Убийца не найден!"
    task.wait(1.2)
    TpMurdererBtn.Text = "ТП за спину Убийце"
end)

AutoGunBtn.MouseButton1Click:Connect(function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("Gun", true)
    if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 2, 0)
        AutoGunBtn.Text = "Пистолет взят!"
    else
        AutoGunBtn.Text = "Пистолета нет!"
    end
    task.wait(1.2)
    AutoGunBtn.Text = "Забрать Пистолет"
end)

-- Логика Авто-Фарма Монет
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local coinContainer = workspace:FindFirstChild("CoinContainer", true) or workspace:FindFirstChild("Coins", true)
            local targetCoin = nil
            
            if coinContainer then
                for _, child in pairs(coinContainer:GetChildren()) do
                    if child:IsA("BasePart") or child:IsA("Model") then
                        targetCoin = child
                        break
                    end
                end
            end
            
            if not targetCoin then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name == "Coin" or obj.Name == "CoinServer") and obj:IsA("BasePart") then
                        targetCoin = obj
                        break
                    end
                end
            end

            if targetCoin then
                local coinCF = targetCoin:IsA("BasePart") and targetCoin.CFrame or targetCoin.PrimaryPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = coinCF
                task.wait(0.2)
            end
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
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(30, 140, 255)
                    else
                        hl.FillColor = Color3.fromRGB(30, 255, 100)
                    end
                end
            end
        end
    end
end)

-- Исправленный плавающий Спидхак под мобилки (через RenderStepped & DeltaTime)
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
