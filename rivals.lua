-- [[ UI 라이브러리 로드 ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NeTo HUB | Rivals", "DarkTheme")

-- [[ 변수 및 설정 ]]
local Settings = {
    Aimbot = false,
    RightClickOnly = false,
    Smoothness = 0.5,
    SilentAim = false,
    Wallbang = false,
    BulletSpeed = 1,
    FOV = 150,
    ShowFOV = false,
    CurrentSkin = "None"
}

-- [[ Combat 탭: 이미지의 구성을 그대로 재현 ]]
local Combat = Window:NewTab("Combat")

-- 1. Aimbot 섹션 (첫 번째 이미지 스타일)
local AimSection = Combat:NewSection("Aimbot")
AimSection:NewToggle("에임봇 켜기", "대상을 자동으로 추적합니다.", function(v)
    Settings.Aimbot = v
end)

AimSection:NewToggle("우클릭 전용 작동", "마우스 우클릭 시에만 작동합니다.", function(v)
    Settings.RightClickOnly = v
end)

AimSection:NewSlider("에임 부드러움", "값이 높을수록 천천히 조준합니다.", 1, 10, function(v)
    Settings.Smoothness = v / 10
end)

-- 2. Rage & Anti-Aim 섹션
local RageSection = Combat:NewSection("Rage & Anti-Aim")
RageSection:NewToggle("레이지봇 (자동발사)", "범위 내 적을 즉시 사격합니다.", function(v)
    Settings.RageBot = v
end)

RageSection:NewToggle("안티 에임 Enabled", "본인의 히트박스를 비정상적으로 움직입니다.", function(v)
    Settings.AntiAim = v
end)

RageSection:NewDropdown("안티 에임 모드", "", {"Spin", "Jitter", "Back"}, function(v)
    Settings.AAMode = v
end)

-- 3. Silent Aim 섹션 (두 번째 이미지 우측 스타일)
local SilentSection = Combat:NewSection("Silent Aim")
SilentSection:NewToggle("사일런트 에임 (유도탄)", "조준하지 않아도 총알이 적을 향합니다.", function(v)
    Settings.SilentAim = v
end)

SilentSection:NewToggle("매직 불릿 (Wallbang)", "벽 뒤의 적을 타격할 수 있습니다.", function(v)
    Settings.Wallbang = v
end)

SilentSection:NewSlider("총알 속도", "", 1, 10, function(v)
    Settings.BulletSpeed = v
end)

SilentSection:NewSlider("FOV 범위", "", 1, 1000, function(v)
    Settings.FOV = v
end)

SilentSection:NewToggle("FOV 원 표시", "화면에 작동 범위를 그립니다.", function(v)
    Settings.ShowFOV = v
end)

-- [[ Skins 탭: 커스텀 스킨 체인저 ]]
local Skins = Window:NewTab("Skins")
local SkinSec = Skins:NewSection("Weapon Skin Changer")

local function ApplySkin(skinName)
    local vm = workspace.CurrentCamera:FindFirstChild("ViewModel")
    if not vm then return end
    for _, p in pairs(vm:GetDescendants()) do
        if p:IsA("MeshPart") or p:IsA("BasePart") then
            if skinName == "Gold" then
                p.Material = Enum.Material.Metal
                p.Color = Color3.fromRGB(255, 215, 0)
            elseif skinName == "Diamond" then
                p.Material = Enum.Material.Glass
                p.Color = Color3.fromRGB(185, 242, 255)
            end
        end
    end
end

SkinSec:NewDropdown("스킨 선택", "클라이언트 사이드 전용", {"Gold", "Diamond", "Galaxy", "Ruby"}, function(v)
    Settings.CurrentSkin = v
    ApplySkin(v)
end)

-- [[ 기타 탭 ]]
local Visuals = Window:NewTab("Visuals")
local Misc = Window:NewTab("Misc")
local UISet = Window:NewTab("UI Settings")

-- [[ 로직 실행 루프 ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 85, 255)

game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()
    
    if Settings.AntiAim and Settings.AAMode == "Spin" then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0) end
    end
end)
