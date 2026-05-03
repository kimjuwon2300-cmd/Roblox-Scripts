local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NeTo HUB | Rivals", "DarkTheme")

local Settings = {
    Aimbot = false,
    RightClickOnly = false,
    Smoothness = 0.5,
    FOV = 150,
    ShowFOV = false
}

local Combat = Window:NewTab("Combat")

local AimSection = Combat:NewSection("Aimbot")
AimSection:NewToggle("에임봇 켜기", "Toggle to enable aimbot", function(value)
    Settings.Aimbot = value
end)
AimSection:NewToggle("우클릭 전용 작동", "Require right click to aim", function(value)
    Settings.RightClickOnly = value
end)
AimSection:NewSlider("에임 부드러움", "0.5 / 1", 10, 1, function(value)
    Settings.Smoothness = value / 10
end)

local SilentSection = Combat:NewSection("Silent Aim")
SilentSection:NewSlider("FOV 범위", "150 / 1000", 1000, 1, function(value)
    Settings.FOV = value
end)
SilentSection:NewToggle("FOV 원 표시", "Show visual FOV circle", function(value)
    Settings.ShowFOV = value
end)

local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Transparency = 1
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 122, 255)

local function GetClosestTarget()
    local target, minDist = nil, Settings.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
            local head = player.Character and player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

local function MoveMouse(dx, dy)
    if mousemoverel then
        mousemoverel(dx, dy)
        return
    end
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:MoveMouseSmooth(UIS:GetMouseLocation().X + dx, UIS:GetMouseLocation().Y + dy)
    end)
end

RunService.RenderStepped:Connect(function()
    if Settings.ShowFOV then
        FOVCircle.Visible = true
        FOVCircle.Radius = Settings.FOV
        FOVCircle.Position = UIS:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end

    if not Settings.Aimbot then
        return
    end
    if Settings.RightClickOnly and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end

    local targetHead = GetClosestTarget()
    if not targetHead then
        return
    end

    local headPos = Camera:WorldToViewportPoint(targetHead.Position)
    local mousePos = UIS:GetMouseLocation()
    local dx = (headPos.X - mousePos.X) * Settings.Smoothness
    local dy = (headPos.Y - mousePos.Y) * Settings.Smoothness
    MoveMouse(dx, dy)
end)
