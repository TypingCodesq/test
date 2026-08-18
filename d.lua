if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Wait = (task and task.wait) or wait
local Spawn = (task and task.spawn) or spawn

local ICON_ID = 134441968486950

pcall(function()
    local a = CoreGui:FindFirstChild("XScript")
    if a then a:Destroy() end
    local b = CoreGui:FindFirstChild("XScript_ESP_Holder")
    if b then b:Destroy() end
    local c = CoreGui:FindFirstChild("XScript_FlyPad")
    if c then c:Destroy() end
end)

local THEME = {
    Bg = Color3.fromRGB(9, 10, 16),
    Panel = Color3.fromRGB(16, 18, 30),
    PanelLight = Color3.fromRGB(24, 27, 44),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentDark = Color3.fromRGB(58, 68, 170),
    Stroke = Color3.fromRGB(70, 86, 200),
    Text = Color3.fromRGB(178, 188, 235),
    TextDim = Color3.fromRGB(126, 136, 190),
    Knob = Color3.fromRGB(147, 160, 255)
}

local Config = {
    ESP = { Enabled = false, Murderer = true, Sheriff = true, Innocent = false, Distance = true },
    Combat = { SilentAim = false, KillAll = false },
    Move = { Fly = false, FlySpeed = 60, Noclip = false, Speed = false, SpeedValue = 32, InfJump = false },
    Farm = { Coins = false, Weapons = false },
    Visuals = { FullBright = false }
}

local FlyInputs = { F = false, B = false, L = false, R = false, U = false, D = false }

local warned = {}
local function once(key, err)
    if not warned[key] then
        warned[key] = true
        warn("[X-SCRIPT] " .. key .. ": " .. tostring(err))
    end
end

local function FindByClass(parent, className)
    if not parent then return nil end
    local ok, list = pcall(function() return parent:GetChildren() end)
    if not ok then return nil end
    for _, child in ipairs(list) do
        if child:IsA(className) then return child end
    end
    return nil
end

local function GetCharacter() return LocalPlayer.Character end
local function GetRoot()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function GetHumanoid()
    return FindByClass(GetCharacter(), "Humanoid")
end

local function GetRole(player)
    local boxes = {}
    local char = player.Character
    if char then table.insert(boxes, char) end
    local bp = player:FindFirstChild("Backpack")
    if bp then table.insert(boxes, bp) end
    for _, box in ipairs(boxes) do
        for _, item in ipairs(box:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("knife") then return "Murderer" end
                if n == "gun" or n == "revolver" then return "Sheriff" end
            end
        end
    end
    return "Innocent"
end

local ESPHolder = Instance.new("ScreenGui")
ESPHolder.Name = "XScript_ESP_Holder"
ESPHolder.ResetOnSpawn = false
ESPHolder.Parent = CoreGui

local ESPCache = {}
local RoleColors = {
    Murderer = Color3.fromRGB(255, 60, 60),
    Sheriff = Color3.fromRGB(60, 150, 255),
    Innocent = Color3.fromRGB(120, 255, 120)
}

local function CreateESP(player)
    local cache = { Highlight = nil, Billboard = nil, Label = nil }

    pcall(function()
        local hl = Instance.new("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.Enabled = false
        hl.Parent = ESPHolder
        cache.Highlight = hl
    end)

    pcall(function()
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 130, 0, 40)
        bb.ExtentsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 600
        bb.Enabled = false
        bb.Parent = ESPHolder
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.Parent = bb
        cache.Billboard = bb
        cache.Label = label
    end)

    ESPCache[player] = cache
    return cache
end

local function RemoveESP(player)
    local c = ESPCache[player]
    if c then
        pcall(function() c.Highlight:Destroy() end)
        pcall(function() c.Billboard:Destroy() end)
        ESPCache[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

local function UpdateESP()
    if not ESPHolder.Parent then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local c = ESPCache[player]
            if not c then c = CreateESP(player) end
            local char = player.Character
            local hum = FindByClass(char, "Humanoid")
            local head = char and char:FindFirstChild("Head")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local alive = Config.ESP.Enabled and char and head and root and hum and hum.Health > 0
            if alive then
                local role = GetRole(player)
                local show = false
                if role == "Murderer" and Config.ESP.Murderer then show = true end
                if role == "Sheriff" and Config.ESP.Sheriff then show = true end
                if role == "Innocent" and Config.ESP.Innocent then show = true end
                local color = RoleColors[role] or Color3.new(1, 1, 1)
                if c.Highlight then
                    c.Highlight.Adornee = char
                    c.Highlight.FillColor = color
                    c.Highlight.OutlineColor = color
                    c.Highlight.Enabled = show
                end
                if c.Billboard then
                    c.Billboard.Adornee = head
                    c.Billboard.Enabled = show
                    if show and c.Label then
                        local text = role
                        if Config.ESP.Distance then
                            local myRoot = GetRoot()
                            if myRoot then
                                text = text .. " [" .. tostring(math.floor((root.Position - myRoot.Position).Magnitude)) .. "]"
                            end
                        end
                        c.Label.Text = text
                        c.Label.TextColor3 = color
                    end
                end
            else
                if c.Highlight then c.Highlight.Enabled = false end
                if c.Billboard then c.Billboard.Enabled = false end
            end
        end
    end
end

local function FlyKey(flag, key)
    return FlyInputs[flag] or UserInputService:IsKeyDown(key)
end

local function HandleFly()
    local root = GetRoot()
    if not root then return end
    if Config.Move.Fly then
        local att = root:FindFirstChild("XS_FlyAtt")
        if not att then
            att = Instance.new("Attachment")
            att.Name = "XS_FlyAtt"
            att.Parent = root
        end
        local lv = root:FindFirstChild("XS_FlyLV")
        if not lv then
            pcall(function()
                lv = Instance.new("LinearVelocity")
                lv.Name = "XS_FlyLV"
                lv.Attachment0 = att
                lv.MaxForce = 100000
                lv.RelativeTo = Enum.ActuatorRelativeTo.World
                lv.Parent = root
            end)
        end
        if lv then
            local dir = Vector3.new(0, 0, 0)
            local cf = Camera.CFrame
            if FlyKey("F", Enum.KeyCode.W) then dir = dir + cf.LookVector end
            if FlyKey("B", Enum.KeyCode.S) then dir = dir - cf.LookVector end
            if FlyKey("L", Enum.KeyCode.A) then dir = dir - cf.RightVector end
            if FlyKey("R", Enum.KeyCode.D) then dir = dir + cf.RightVector end
            if FlyKey("U", Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if FlyKey("D", Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            pcall(function() lv.VectorVelocity = dir * Config.Move.FlySpeed end)
        end
    else
        local att = root:FindFirstChild("XS_FlyAtt")
        local lv = root:FindFirstChild("XS_FlyLV")
        if att then att:Destroy() end
        if lv then lv:Destroy() end
    end
end

local noclipSaved = {}
local function HandleNoclip()
    local char = GetCharacter()
    if not char then return end
    if Config.Move.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if noclipSaved[part] == nil then
                    noclipSaved[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    else
        if next(noclipSaved) then
            for part, val in pairs(noclipSaved) do
                pcall(function()
                    if part.Parent then part.CanCollide = val end
                end)
            end
            noclipSaved = {}
        end
    end
end

local speedWasOn = false
local function HandleSpeed()
    local hum = GetHumanoid()
    if not hum then return end
    if Config.Move.Speed then
        hum.WalkSpeed = Config.Move.SpeedValue
        speedWasOn = true
    elseif speedWasOn then
        hum.WalkSpeed = 16
        speedWasOn = false
    end
end

UserInputService.JumpRequest:Connect(function()
    if Config.Move.InfJump then
        local hum = GetHumanoid()
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    end
end)

local function AimDir(origin, targetPos)
    local d = targetPos - origin
    if d.Magnitude < 0.01 then return d end
    return d.Unit * math.min(d.Magnitude + 1, 999)
end

local AimTarget = nil

local function RefreshAim()
    if not Config.Combat.SilentAim then
        AimTarget = nil
        return
    end
    local char = GetCharacter()
    local hasGun = false
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n == "gun" or n == "revolver" then
                    hasGun = true
                    break
                end
            end
        end
    end
    if not hasGun then
        AimTarget = nil
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Murderer" then
            local ch = p.Character
            local body = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Head"))
            if body then
                AimTarget = body
                return
            end
        end
    end
    AimTarget = nil
end

local mtHooked = false
local oldIndex = nil

local function InstallMouseHook()
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return false end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        if not mt or type(mt.__index) ~= "function" then error("no mt") end
        oldIndex = mt.__index
        setreadonly(mt, false)
        local hook = function(self, key)
            if key == "Hit" or key == "Target" then
                if self == Mouse then
                    local t = AimTarget
                    if t and t.Parent then
                        if key == "Hit" then
                            return t.CFrame
                        else
                            return t
                        end
                    end
                end
            end
            return oldIndex(self, key)
        end
        if type(newcclosure) == "function" then
            mt.__index = newcclosure(hook)
        else
            mt.__index = hook
        end
        setreadonly(mt, true)
        mtHooked = true
    end)
    return ok and mtHooked
end

local function RemoveMouseHook()
    if not mtHooked then return end
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__index = oldIndex
        setreadonly(mt, true)
    end)
    mtHooked = false
end

local ncInstalled = false
local oldNamecall = nil

local function InstallNamecallHook()
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return false end
    local ok = pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if Config.Combat.SilentAim and self == workspace then
                local t = AimTarget
                if t and t.Parent then
                    local m = getnamecallmethod()
                    if m == "Raycast" then
                        local args = { ... }
                        if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                            args[2] = AimDir(args[1], t.Position)
                            return oldNamecall(self, unpack(args))
                        end
                    elseif m == "FindPartOnRay" or m == "FindPartOnRayWithIgnoreList" or m == "FindPartOnRayWithWhitelist" then
                        local args = { ... }
                        if typeof(args[1]) == "Ray" then
                            local o = args[1].Origin
                            args[1] = Ray.new(o, AimDir(o, t.Position))
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
        ncInstalled = true
    end)
    return ok and ncInstalled
end

local function RemoveNamecallHook()
    if not ncInstalled then return end
    if type(restorefunction) == "function" then
        pcall(function() restorefunction(game, "__namecall") end)
    end
    ncInstalled = false
end

local rayHooksInstalled = false
local oldFns = {}

local function InstallRayHooks()
    if type(hookfunction) ~= "function" then return false end
    local ok = pcall(function()
        local targets = { "Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList" }
        for _, name in ipairs(targets) do
            local fn = workspace[name]
            if type(fn) == "function" then
                oldFns[name] = hookfunction(fn, function(...)
                    if Config.Combat.SilentAim then
                        local t = AimTarget
                        if t and t.Parent then
                            local args = { ... }
                            if name == "Raycast" then
                                if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                                    args[2] = AimDir(args[1], t.Position)
                                    return oldFns[name](unpack(args))
                                end
                            else
                                if typeof(args[1]) == "Ray" then
                                    local o = args[1].Origin
                                    args[1] = Ray.new(o, AimDir(o, t.Position))
                                    return oldFns[name](unpack(args))
                                end
                            end
                        end
                    end
                    return oldFns[name](...)
                end)
            end
        end
        rayHooksInstalled = true
    end)
    return ok and rayHooksInstalled
end

local function RemoveRayHooks()
    if not rayHooksInstalled then return end
    if type(restorefunction) == "function" then
        pcall(function()
            for name, _ in pairs(oldFns) do
                restorefunction(workspace[name])
            end
        end)
    end
    oldFns = {}
    rayHooksInstalled = false
end

local function SetSilentAim(on)
    if on then
        local a = InstallMouseHook()
        local b = InstallNamecallHook()
        local c = InstallRayHooks()
        return a or b or c
    else
        RemoveMouseHook()
        RemoveNamecallHook()
        RemoveRayHooks()
        AimTarget = nil
        return true
    end
end

local function KillAllTick()
    local root = GetRoot()
    local char = GetCharacter()
    if not root or not char then return end
    local knife = nil
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find("knife") then
            knife = t
        end
    end
    if not knife then return end
    local origin = root.CFrame
    for _, player in ipairs(Players:GetPlayers()) do
        if not Config.Combat.KillAll then break end
        if player ~= LocalPlayer and player.Character then
            local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local theirHum = FindByClass(player.Character, "Humanoid")
            if theirRoot and theirHum and theirHum.Health > 0 then
                pcall(function() root.CFrame = theirRoot.CFrame * CFrame.new(0, 0, 2) end)
                pcall(function() knife:Activate() end)
                Wait(0.01)
            end
        end
    end
    pcall(function() root.CFrame = origin end)
end

local FARM_NAMES = { "coin" }
local WEAPON_NAMES = { "gun", "revolver", "pistol" }

local function MatchesNames(n, list)
    for _, word in ipairs(list) do
        if n:find(word) then return true end
    end
    return false
end

local function IsInsidePlayer(obj)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and obj:IsDescendantOf(char) then return true end
        local bp = player:FindFirstChild("Backpack")
        if bp and obj:IsDescendantOf(bp) then return true end
    end
    return false
end

local function GetItemPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return FindByClass(obj, "BasePart") end
    if obj:IsA("Tool") then return obj:FindFirstChild("Handle") end
    return nil
end

local coinLock = false

local function CoinSweep()
    local root = GetRoot()
    local hum = GetHumanoid()
    if not root or not hum or hum.Health <= 0 then return end
    local taken = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not Config.Farm.Coins then return end
        if taken >= 2 then return end
        local n = obj.Name:lower()
        if MatchesNames(n, FARM_NAMES) and not IsInsidePlayer(obj) then
            local part = GetItemPart(obj)
            if part then
                pcall(function() root.CFrame = CFrame.new(part.Position + Vector3.new(0, 1, 0)) end)
                taken = taken + 1
                Wait(0.06)
            end
        end
    end
end

local function PickupWeapon(part)
    local root = GetRoot()
    if not root then return end
    local origin = root.CFrame
    pcall(function() root.CFrame = part.CFrame end)
    Wait(0.2)
    pcall(function() root.CFrame = origin end)
end

local function WeaponSweep()
    local root = GetRoot()
    local hum = GetHumanoid()
    if not root or not hum or hum.Health <= 0 then return end
    local gd = workspace:FindFirstChild("GunDrop", true)
    if gd and not IsInsidePlayer(gd) then
        local part = GetItemPart(gd) or gd
        PickupWeapon(part)
        return
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not Config.Farm.Weapons then return end
        local n = obj.Name:lower()
        if MatchesNames(n, WEAPON_NAMES) and not IsInsidePlayer(obj) then
            local part = GetItemPart(obj)
            if part then
                PickupWeapon(part)
                return
            end
        end
    end
end

local function FarmTick()
    if Config.Farm.Coins and not coinLock then
        coinLock = true
        pcall(CoinSweep)
        Spawn(function()
            Wait(2.3)
            coinLock = false
        end)
    end
end

local LightBackup = nil
local function SetFullBright(on)
    if on then
        if not LightBackup then
            LightBackup = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }
        end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
    else
        if LightBackup then
            Lighting.Brightness = LightBackup.Brightness
            Lighting.ClockTime = LightBackup.ClockTime
            Lighting.FogEnd = LightBackup.FogEnd
            Lighting.GlobalShadows = LightBackup.GlobalShadows
            Lighting.OutdoorAmbient = LightBackup.OutdoorAmbient
            LightBackup = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    local ok, err = pcall(function()
        HandleFly()
        HandleSpeed()
    end)
    if not ok then once("move", err) end
end)

RunService.Stepped:Connect(function()
    local ok, err = pcall(HandleNoclip)
    if not ok then once("noclip", err) end
end)

local function loop(interval, key, fn)
    Spawn(function()
        while true do
            Wait(interval)
            local ok, err = pcall(fn)
            if not ok then once(key, err) end
        end
    end)
end

loop(0.25, "esp", UpdateESP)
loop(0.2, "farm", FarmTick)
loop(0.6, "weapons", function() if Config.Farm.Weapons then WeaponSweep() end end)
loop(0.05, "killall", function() if Config.Combat.KillAll then KillAllTick() end end)
loop(0.25, "aimcache", RefreshAim)

local function Make(cls, props, parent)
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local vp = Camera.ViewportSize
local W = math.clamp(vp.X * 0.52, 300, 520)
local H = math.clamp(vp.Y * 0.62, 230, 400)

local ScreenGui = Make("ScreenGui", {
    Name = "XScript",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, CoreGui)

local Main = Make("Frame", {
    Size = UDim2.fromOffset(W, H),
    Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
    BackgroundColor3 = THEME.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, ScreenGui)

Make("UICorner", { CornerRadius = UDim.new(0, 10) }, Main)
Make("UIStroke", { Color = THEME.Stroke, Thickness = 1 }, Main)

local TitleBar = Make("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = THEME.Panel,
    BorderSizePixel = 0
}, Main)
Make("UICorner", { CornerRadius = UDim.new(0, 10) }, TitleBar)
Make("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = THEME.Panel,
    BorderSizePixel = 0
}, TitleBar)

local iconBox = Make("Frame", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(0, 6, 0.5, -13),
    BackgroundColor3 = THEME.PanelLight,
    BorderSizePixel = 0
}, TitleBar)
Make("UICorner", { CornerRadius = UDim.new(0, 6) }, iconBox)

local iconOk = false
if ICON_ID ~= 0 then
    iconOk = pcall(function()
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. tostring(ICON_ID)
        img.ScaleType = Enum.ScaleType.Stretch
        img.Parent = iconBox
    end)
end
if not iconOk then
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = THEME.Accent,
        Font = Enum.Font.GothamBlack,
        TextSize = 16
    }, iconBox)
end

Make("TextLabel", {
    Size = UDim2.new(1, -116, 1, 0),
    Position = UDim2.new(0, 38, 0, 0),
    BackgroundTransparency = 1,
    Text = "X-SCRIPT",
    TextColor3 = THEME.Knob,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, TitleBar)

local function TitleButton(text, xoff, bg)
    local b = Make("TextButton", {
        Size = UDim2.new(0, 32, 0, 26),
        Position = UDim2.new(1, xoff, 0, 5),
        BackgroundColor3 = bg,
        Text = text,
        TextColor3 = THEME.Knob,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0
    }, TitleBar)
    Make("UICorner", { CornerRadius = UDim.new(0, 6) }, b)
    return b
end

local MinBtn = TitleButton("-", -70, THEME.PanelLight)
local CloseBtn = TitleButton("X", -36, THEME.AccentDark)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.2), {
        Size = UDim2.fromOffset(W, minimized and 36 or H)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    Config.ESP.Enabled = false
    for p, _ in pairs(ESPCache) do RemoveESP(p) end
    pcall(function() ESPHolder:Destroy() end)
    pcall(function() FlyPad:Destroy() end)
    ScreenGui:Destroy()
end)

local dragInput = nil
local dragOffset = Vector2.new(0, 0)

local function InBounds(pos, obj)
    local a = obj.AbsolutePosition
    local s = obj.AbsoluteSize
    return pos.X >= a.X and pos.X <= a.X + s.X and pos.Y >= a.Y and pos.Y <= a.Y + s.Y
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if InBounds(input.Position, TitleBar) and not InBounds(input.Position, MinBtn) and not InBounds(input.Position, CloseBtn) then
            dragInput = input
            dragOffset = Vector2.new(input.Position.X - Main.AbsolutePosition.X, input.Position.Y - Main.AbsolutePosition.Y)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        Main.Position = UDim2.fromOffset(input.Position.X - dragOffset.X, input.Position.Y - dragOffset.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == dragInput then dragInput = nil end
end)

local TabStrip = Make("ScrollingFrame", {
    Size = UDim2.new(1, -8, 0, 32),
    Position = UDim2.new(0, 4, 0, 40),
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    BorderSizePixel = 0
}, Main)

local StripLayout = Make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5)
}, TabStrip)

StripLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabStrip.CanvasSize = UDim2.new(0, StripLayout.AbsoluteContentSize.X + 8, 0, 0)
end)

local PageHolder = Make("Frame", {
    Size = UDim2.new(1, -8, 1, -78),
    Position = UDim2.new(0, 4, 0, 74),
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, Main)

local FlyPad = Make("ScreenGui", {
    Name = "XScript_FlyPad",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, CoreGui)
FlyPad.Enabled = false

local function PadBtn(flag, text, px, py)
    local b = Make("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(1, px, 1, py),
        BackgroundColor3 = THEME.Panel,
        Text = text,
        TextColor3 = THEME.Knob,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0
    }, FlyPad)
    Make("UICorner", { CornerRadius = UDim.new(0, 10) }, b)
    Make("UIStroke", { Color = THEME.Stroke, Thickness = 1 }, b)
    b.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            FlyInputs[flag] = true
        end
    end)
    b.InputEnded:Connect(function()
        FlyInputs[flag] = false
    end)
    return b
end

PadBtn("F", "W", -120, -210)
PadBtn("L", "A", -180, -150)
PadBtn("B", "S", -120, -90)
PadBtn("R", "D", -60, -150)
PadBtn("U", "U", -260, -210)
PadBtn("D", "D", -260, -90)

local tabs = {}
local function CreateTab(name, headerText)
    local btn = Make("TextButton", {
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundColor3 = THEME.Panel,
        Text = name,
        TextColor3 = THEME.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0
    }, TabStrip)
    Make("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)

    local container = Make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ClipsDescendants = true
    }, PageHolder)

    local header = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = THEME.PanelLight,
        BorderSizePixel = 0
    }, container)
    Make("UICorner", { CornerRadius = UDim.new(0, 6) }, header)

    Make("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = headerText,
        TextColor3 = THEME.Knob,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, header)

    local page = Make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -28),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = THEME.Accent,
        BorderSizePixel = 0
    }, container)
    local layout = Make("UIListLayout", { Padding = UDim.new(0, 5) }, page)
    Make("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4)
    }, page)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
    end)

    local tab = { Button = btn, Container = container }
    table.insert(tabs, tab)

    local function selectTab()
        for _, t in ipairs(tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = THEME.Panel
            t.Button.TextColor3 = THEME.TextDim
        end
        container.Visible = true
        btn.BackgroundColor3 = THEME.Accent
        btn.TextColor3 = THEME.Knob
    end

    btn.MouseButton1Click:Connect(selectTab)
    if #tabs == 1 then selectTab() end

    return page
end

local function AddToggle(page, text, default, callback)
    local row = Make("Frame", {
        Size = UDim2.new(1, -4, 0, 36),
        BackgroundColor3 = THEME.Panel,
        BorderSizePixel = 0
    }, page)
    Make("UICorner", { CornerRadius = UDim.new(0, 7) }, row)

    local label = Make("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = THEME.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local track = Make("Frame", {
        Size = UDim2.new(0, 42, 0, 22),
        Position = UDim2.new(1, -50, 0.5, -11),
        BackgroundColor3 = default and THEME.Accent or THEME.PanelLight,
        BorderSizePixel = 0
    }, row)
    Make("UICorner", { CornerRadius = UDim.new(1, 0) }, track)

    local knob = Make("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = THEME.Knob,
        BorderSizePixel = 0
    }, track)
    Make("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local state = default
    local hit = Make("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, row)

    local controller = {}
    function controller.SetText(t) label.Text = t end
    function controller.SetState(s)
        if state == s then return end
        state = s
        track.BackgroundColor3 = state and THEME.Accent or THEME.PanelLight
        knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        if callback then callback(state) end
    end

    hit.MouseButton1Click:Connect(function()
        controller.SetState(not state)
    end)

    return controller
end

local function AddSlider(page, text, min, max, default, callback)
    local row = Make("Frame", {
        Size = UDim2.new(1, -4, 0, 42),
        BackgroundColor3 = THEME.Panel,
        BorderSizePixel = 0
    }, page)
    Make("UICorner", { CornerRadius = UDim.new(0, 7) }, row)

    Make("TextLabel", {
        Size = UDim2.new(0.55, 0, 0, 18),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = THEME.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local valueLabel = Make("TextLabel", {
        Size = UDim2.new(0.45, -10, 0, 18),
        Position = UDim2.new(0.55, 0, 0, 4),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = THEME.Knob,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    }, row)

    local bar = Make("Frame", {
        Position = UDim2.new(0, 10, 0, 27),
        Size = UDim2.new(1, -20, 0, 8),
        BackgroundColor3 = THEME.PanelLight,
        BorderSizePixel = 0
    }, row)
    Make("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

    local fill = Make("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel = 0
    }, bar)
    Make("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

    local dragging = false

    local function setFromX(x)
        local rel = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        if rel < 0 then rel = 0 end
        if rel > 1 then rel = 1 end
        local val = math.floor(min + (max - min) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        valueLabel.Text = tostring(val)
        if callback then callback(val) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)

    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
end

local combatPage = CreateTab("Combat", "COMBAT")
local espPage = CreateTab("ESP", "ESP")
local farmPage = CreateTab("Farm", "COLLECT")
local movePage = CreateTab("Move", "MOVEMENT")
local miscPage = CreateTab("Misc", "VISUALS")

AddToggle(combatPage, "Silent Aim", false, function(v)
    Config.Combat.SilentAim = v
    if v then
        local ok = SetSilentAim(true)
        if not ok then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "X-SCRIPT", Text = "Tu executor no soporta hooks", Duration = 4
                })
            end)
        end
    else
        SetSilentAim(false)
    end
end)
AddToggle(combatPage, "Kill All", false, function(v) Config.Combat.KillAll = v end)

AddToggle(espPage, "Enable ESP", false, function(v) Config.ESP.Enabled = v end)
AddToggle(espPage, "Show Murderer", true, function(v) Config.ESP.Murderer = v end)
AddToggle(espPage, "Show Sheriff", true, function(v) Config.ESP.Sheriff = v end)
AddToggle(espPage, "Show Innocents", false, function(v) Config.ESP.Innocent = v end)
AddToggle(espPage, "Show Distance", true, function(v) Config.ESP.Distance = v end)

AddToggle(farmPage, "Collect Coins", false, function(v) Config.Farm.Coins = v end)
AddToggle(farmPage, "Collect Weapons", false, function(v) Config.Farm.Weapons = v end)

AddToggle(movePage, "Fly", false, function(v)
    Config.Move.Fly = v
    if not v then
        for k in pairs(FlyInputs) do FlyInputs[k] = false end
    end
    FlyPad.Enabled = v and UserInputService.TouchEnabled
end)
AddToggle(movePage, "Noclip", false, function(v) Config.Move.Noclip = v end)
AddToggle(movePage, "Speed", false, function(v) Config.Move.Speed = v end)
AddSlider(movePage, "Speed Value", 16, 120, 60, function(v) Config.Move.SpeedValue = v end)
AddSlider(movePage, "Fly Speed", 20, 200, 60, function(v) Config.Move.FlySpeed = v end)
AddToggle(movePage, "Infinite Jump", false, function(v) Config.Move.InfJump = v end)

AddToggle(miscPage, "FullBright", false, function(v) SetFullBright(v) end)