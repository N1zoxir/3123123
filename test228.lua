local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = { ESP = false, Aimbot = false }

-- Интерфейс
local Gui = Instance.new("ScreenGui")
Gui.Name = "MM2_Lite"
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = Gui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.5, -90, 0.5, -60)
Frame.Size = UDim2.new(0, 180, 0, 120)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, -25, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "MM2 Lite"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.Parent = Frame
Close.Position = UDim2.new(1, -22, 0, 4)
Close.Size = UDim2.new(0, 18, 0, 18)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.Text = "-"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = Gui
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "🔪"
OpenBtn.TextSize = 20
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

Close.MouseButton1Click:Connect(function()
    Frame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    OpenBtn.Visible = false
end)

local List = Instance.new("UIListLayout")
List.Parent = Frame
List.HorizontalAlignment = Enum.HorizontalAlignment.Center
List.Padding = UDim.new(0, 6)
Instance.new("UIPadding", Frame).PaddingTop = UDim.new(0, 38)

local function makeBtn(txt)
    local b = Instance.new("TextButton")
    b.Parent = Frame
    b.Size = UDim2.new(0, 160, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local EspBtn = makeBtn("ESP (Роли): ВЫКЛ")
local AimBtn = makeBtn("Аим на Убийцу: ВЫКЛ")

-- Проверка роли игрока
local function getRole(plr)
    if not plr.Character then return "Innocent" end
    for _, loc in pairs({plr.Character, plr:FindFirstChild("Backpack")}) do
        if loc then
            for _, item in pairs(loc:GetChildren()) do
                if item:IsA("Tool") then
                    local n = item.Name:lower()
                    if n:find("knife") or n:find("blade") or n:find("scythe") or n:find("slash") then return "Murderer" end
                    if n:find("gun") or n:find("revolver") or n:find("sheriff") then return "Sheriff" end
                end
            end
        end
    end
    return "Innocent"
end

EspBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    EspBtn.Text = Config.ESP and "ESP (Роли): ВКЛ" or "ESP (Роли): ВЫКЛ"
    EspBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
    if not Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MM2_HL") then
                p.Character.MM2_HL:Destroy()
            end
        end
    end
end)

AimBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimBtn.Text = Config.Aimbot and "Аим на Убийцу: ВКЛ" or "Аим на Убийцу: ВЫКЛ"
    AimBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
end)

-- Легкий цикл подсветки (не грузит систему)
task.spawn(function()
    while task.wait(0.3) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role = getRole(p)
                    local hl = p.Character:FindFirstChild("MM2_HL")
                    if role ~= "Innocent" then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "MM2_HL"
                            hl.Parent = p.Character
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        hl.FillColor = (role == "Murderer") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 120, 255)
                        hl.Enabled = true
                    elseif hl then
                        hl.Enabled = false
                    end
                end
            end
        end
    end
end)

-- Наводка аимбота
RunService.RenderStepped:Connect(function()
    if Config.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end
end)
