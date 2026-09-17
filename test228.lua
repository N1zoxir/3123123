local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    SpeedMult = 0.4,
    NoClip = false,
    AutoGun = false
}

-- UI Элементы
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Xeno_Full_Fixed"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MM2 FULL | FIXED EDITION"
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
    btn.Size = UDim2.new(0, 280, 0, 38)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local EspBtn = createBtn("ESP (Все роли): ВЫКЛ")
local AimbotBtn = createBtn("Аимбот на Убийцу: ВЫКЛ")
local SkinBtn = createBtn("Выдать Godly Скины (Визуал)")
local SpeedBtn = createBtn("Спидхак (Bypass): ВЫКЛ")
local NoclipBtn = createBtn("NoClip (Сквозь стены): ВЫКЛ")
local AutoGunBtn = createBtn("Забрать Пистолет (АвтоTP)")
local TpLobbyBtn = createBtn("Телепорт в Лобби")

-- Определение ролей игроков
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

-- Переключатели
EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    EspBtn.Text = Config.ESP and "ESP (Все роли): ВКЛ" or "ESP (Все роли): ВЫКЛ"
    EspBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
    
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
    AimbotBtn.Text = Config.Aimbot and "Аимбот на Убийцу: ВКЛ" or "Аимбот на Убийцу: ВЫКЛ"
    AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(45, 45, 45)
end)

SkinBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("Tool") then
                    local n = v.Name:lower()
                    if n:find("knife") or n:find("gun") or n:find("blade") then
                        v:Clone().Parent = bp
                    end
                end
            end
        end
    end)
    SkinBtn.Text = "Скины добавлены!"
    task.wait(1.5)
    SkinBtn.Text = "Выдать Godly Скины (Визуал)"
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

TpLobbyBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-109, 138, 11)
    end
end)

-- Стабильный цикл ESP (работает каждые 0.3 секунды без лагов)
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
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.Enabled = true
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(0, 150, 255)
                        hl.Enabled = true
                    else
                        hl.FillColor = Color3.fromRGB(0, 255, 0)
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

-- Аимбот и Спидхак в кадре
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

    -- Обход Спидхака
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * Config.SpeedMult)
        end
    end
end)
