-- 라이브러리 로드 (이미지 디자인과 가장 유사한 Kavo 스타일 변형)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("안티 허브 | Anti hub", "DarkTheme")

-- 서비스 및 변수 설정
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    -- Aimbot
    Aimbot = false,
    RightClickOnly = true,
    Smoothness = 0.5,
    -- Rage & Anti-Aim
    RageBot = false,
    AntiAim = false,
    AAMode = "Spin",
    -- Silent Aim
    SilentAim = false,
    Wallbang = false,
    BulletSpeed = 1,
    FOV = 150,
    ShowFOV = false
}

-- FOV 원 설정
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8

-- [Combat 탭 생성]
local Combat = Window:NewTab("Combat")

-- 1. Aimbot 섹션
local AimbotSection = Combat:NewSection("Aimbot")
AimbotSection:NewToggle("에임봇 켜기", "대상을 자동으로 추적합니다.", function(v)
    Settings.Aimbot = v
end)

AimbotSection:NewToggle("우클릭 전용 작동", "마우스 우클릭 시에만 작동합니다.", function(v)
    Settings.RightClickOnly = v
end)

AimbotSection:NewSlider("에임 부드러움", "값이 높을수록 천천히 움직입니다.", 1, 10, function(v)
    Settings.Smoothness = v / 10
end)

-- 2. Rage & Anti-Aim 섹션
local RageSection = Combat:NewSection("Rage & Anti-Aim")
RageSection:NewToggle("레이지봇 (자동발사)", "적을 즉시 사격합니다.", function(v)
    Settings.RageBot = v
end)

RageSection:NewToggle("안티 에임 Enabled", "적의 조준을 방해합니다.", function(v)
    Settings.AntiAim = v
end)

RageSection:NewDropdown("안티 에임 모드", "모드를 선택하세요.", {"Spin", "Jitter", "Back"}, function(v)
    Settings.AAMode = v
end)

-- 3. Silent Aim 섹션 (이미지 오른쪽 상단 부분)
local SilentSection = Combat:NewSection("Silent Aim")
SilentSection:NewToggle("사일런트 에임 (유도탄)", "총알이 휘어 적에게 맞습니다.", function(v)
    Settings.SilentAim = v
end)

SilentSection:NewToggle("매직 불릿 (Wallbang)", "벽을 뚫고 적을 맞춥니다.", function(v)
    Settings.Wallbang = v
end)

SilentSection:NewSlider("총알 속도", "총알의 속도를 조절합니다.", 1, 10, function(v)
    Settings.BulletSpeed = v
end)

SilentSection:NewSlider("FOV 범위", "에임봇이 작동할 범위를 정합니다.", 1, 1000, function(v)
    Settings.FOV = v
end)

SilentSection:NewToggle("FOV 원 표시", "화면에 작동 범위를 표시합니다.", function(v)
    Settings.ShowFOV = v
end)

-- [기타 탭들]
local Visuals = Window:NewTab("Visuals")
local Misc = Window:NewTab("Misc")
local UISettings = Window:NewTab("UI Settings")

-- 메인 기능 로직
RunService.RenderStepped:Connect(function()
    -- FOV 업데이트
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    -- 에임봇 로직
    if Settings.Aimbot then
        local isPressed = not Settings.RightClickOnly or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if isPressed then
            -- (이전 답변의 getTarget 함수를 여기에 포함하여 사용하세요)
            -- Camera.CFrame:Lerp(...) 등 실행
        end
    end

    -- 안티 에임 (Spin)
    if Settings.AntiAim and Settings.AAMode == "Spin" then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)

-- 월뱅 (Raycast Hooking)
if Settings.Wallbang then
    -- 게임의 총알 계산 방식을 가로채는 코드 적용 (이전 답변 참조)
end
