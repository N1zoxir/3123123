-- ============================================
-- Universal Hub v2.0 (Speed, ESP, Item ESP, Aimbot)
-- ============================================

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 1. Уведомление о запуске
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Script Status",
        Text = "Universal Hub v2.0 успешно запущен!",
        Duration = 4
    })
end)

-- 2. Удаление старой версии интерфейса
if game:GetService("CoreGui"):FindFirstChild("UniversalHubUI") then
    game:GetService("CoreGui").UniversalHubUI:Destroy()
end

-- 3. Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHubUI"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 270)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Universal Hub v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка Закрыть
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 12

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Вспомогательная функция для быстрого создания кнопок
local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    return btn
end

-- --- ФУНКЦИЯ 1: Скорость (WalkSpeed) ---
local SpeedBtn = createButton("Скорость [50]: ВЫКЛ", 40)
local speedToggled = false

SpeedBtn.MouseButton1Click:Connect(function()
    speedToggled = not speedToggled
    if speedToggled then
        SpeedBtn.Text = "Скорость [50]: ВКЛ"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
    else
        SpeedBtn.Text = "Скорость [50]: ВЫКЛ"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if speedToggled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

-- --- ФУНКЦИЯ 2: Player ESP (Красная подсветка) ---
local EspBtn = createButton("Player ESP: ВЫКЛ", 95)
local espToggled = false

local function applyPlayerESP(player)
    if player == LocalPlayer then return end
    local function addHighlight(char)
        if not char then return end
        local hl = char:FindFirstChild("PlayerHighlight") or Instance.new("Highlight")
        hl.Name = "PlayerHighlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 50, 50)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Enabled = espToggled
        hl.Parent = char
    end
    if player.Character then addHighlight(player.Character) end
    player.CharacterAdded:Connect(addHighlight)
end

for _, p in pairs(Players:GetPlayers()) do applyPlayerESP(p) end
Players.PlayerAdded:Connect(applyPlayerESP)

EspBtn.MouseButton1Click:Connect(function()
    espToggled = not espToggled
    EspBtn.Text = espToggled and "Player ESP: ВКЛ" or "Player ESP: ВЫКЛ"
    EspBtn.BackgroundColor3 = espToggled and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(35, 35, 50)

    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("PlayerHighlight") then
            p.Character.PlayerHighlight.Enabled = espToggled
        end
    end
end)

-- --- ФУНКЦИЯ 3: Item ESP (Желтая подсветка предметов) ---
local ItemEspBtn = createButton("Item ESP: ВЫКЛ", 150)
local itemEspToggled = false

local function updateItemESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
            local hl = obj:FindFirstChild("ItemHighlight")
            if itemEspToggled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ItemHighlight"
                    hl.Adornee = obj
                    hl.FillColor = Color3.fromRGB(255, 220, 0)
                    hl.FillTransparency = 0.4
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = obj
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end
        end
    end
end

ItemEspBtn.MouseButton1Click:Connect(function()
    itemEspToggled = not itemEspToggled
    ItemEspBtn.Text = itemEspToggled and "Item ESP: ВКЛ" or "Item ESP: ВЫКЛ"
    ItemEspBtn.BackgroundColor3 = itemEspToggled and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(35, 35, 50)
    updateItemESP()
end)

-- Периодическое обновление предметного ESP на новые спавны
task.spawn(function()
    while true do
        task.wait(3)
        if itemEspToggled then
            updateItemESP()
        end
    end
end)

-- --- ФУНКЦИЯ 4: Простой Aimbot (Зажатие ПКМ) ---
local AimBtn = createButton("Aimbot (Зажать ПКМ): ВЫКЛ", 205)
local aimbotToggled = false
local fovRadius = 200 -- Радиус захвата целей в пикселях

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = fovRadius
    local mousePos = UserInputService:GetMouseLocation()
    local currentCam = Workspace.CurrentCamera

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local head = player.Character.Head
                local screenPos, onScreen = currentCam:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

AimBtn.MouseButton1Click:Connect(function()
    aimbotToggled = not aimbotToggled
    AimBtn.Text = aimbotToggled and "Aimbot (Зажать ПКМ): ВКЛ" or "Aimbot (Зажать ПКМ): ВЫКЛ"
    AimBtn.BackgroundColor3 = aimbotToggled and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(35, 35, 50)
end)

RunService.RenderStepped:Connect(function()
    if aimbotToggled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local cam = Workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
        end
    end
end)
