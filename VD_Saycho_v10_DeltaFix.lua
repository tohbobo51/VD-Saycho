--[[
╔══════════════════════════════════════════════════════════╗
║   PROJECT : VD (Violence District) - PLATINUM            ║
║   VERSION : 9.0 — FULL FEATURE BUILD                    ║
║   BY      : Saycho  |  Build : Claude                   ║
╠══════════════════════════════════════════════════════════╣
║  TAB LAYOUT:                                             ║
║  1. ESP      — Player (Survivor Hijau/Killer Merah),    ║
║                Generator, Pallet                         ║
║  2. Aimbot   — Toggle, FOV, Target Bone, Team Check     ║
║  3. Player   — WalkSpeed, Jump, NoClip, Fly, GodMode    ║
║  4. Visual   — FullBright, Fog, Crosshair, Chams, FOV   ║
║  5. Utility  — TP Player, Anti AFK, FPS Boost,         ║
║                Server Hop, Rejoin, Spectate              ║
║  6. Settings — Icon Size, Shape, Color, Accent          ║
╚══════════════════════════════════════════════════════════╝
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = WS.CurrentCamera

-- ============================================================
-- SAFE PLAYERGUI
-- ============================================================
local function getPlayerGui()
    local ok, res = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 8) end)
    return (ok and res) or CoreGui
end
local PlayerGui = getPlayerGui()

-- ============================================================
-- CLEANUP
-- ============================================================
for _, parent in ipairs({CoreGui, PlayerGui}) do
    local old = parent:FindFirstChild("VD_Saycho_Official")
    if old then old:Destroy() end
end

-- ============================================================
-- SCREENGUI — coba CoreGui, fallback PlayerGui
-- ============================================================
local ScreenGui
local ok_cg = pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "VD_Saycho_Official"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999; sg.Parent = CoreGui
    ScreenGui = sg
end)
if not ok_cg or not ScreenGui or not ScreenGui.Parent then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VD_Saycho_Official"; ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999; ScreenGui.Parent = PlayerGui
end

-- ============================================================
-- STATES
-- ============================================================
local States = {
    -- ESP
    EspPlayer    = false, EspGenerator  = false, PalletEsp = false,
    EspName      = true,  EspHP         = true,  EspDist   = true,
    EspBox       = true,  EspHeadDot    = false,  EspTracer = false,
    -- Aimbot
    Aimbot       = false, AimbotTeamCheck = true,
    AimbotBone   = "body",  -- "head" or "body"
    AimbotFOV    = 100,
    -- Player
    NoClip       = false, GodMode    = false, FlyMode    = false,
    InfiniteJump = false, AntiKnock  = false,
    WalkSpeed    = 16,    JumpPower  = 50,
    -- Visual
    FullBright   = false, NoFog      = false, Chams      = false,
    Crosshair    = false, RainbowESP = false,
    -- Utility
    AntiAFK      = false, FPSBoost   = false, SpectateTarget = nil,
}

-- ============================================================
-- COLORS
-- ============================================================
local COLOR = {
    ORANGE   = Color3.fromRGB(255, 140, 0),
    SURVIVOR = Color3.fromRGB(80,  220, 80),
    KILLER   = Color3.fromRGB(220, 40,  40),
    GEN_PROG = Color3.fromRGB(255, 200, 0),
    GEN_DONE = Color3.fromRGB(0,   220, 100),
    PALLET   = Color3.fromRGB(180, 80,  220),
    DARK     = Color3.fromRGB(25,  25,  25),
    SIDEBAR  = Color3.fromRGB(22,  22,  22),
    BG       = Color3.fromRGB(18,  18,  18),
}

-- ============================================================
-- ROLE DETECTION
-- ============================================================
local function getRole(player)
    if player and player.Team then
        local t = player.Team.Name:lower()
        if t:find("killer") or t:find("maniac") then return "Killer" end
    end
    return "Survivor"
end

-- ============================================================
-- DRAGGING
-- ============================================================
local function MakeDraggable(obj, handle)
    local drag, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag=true; dragStart=i.Position; startPos=obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                     startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then drag=false end
    end)
end

-- ============================================================
-- FLOATING ICON
-- ============================================================
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name = "LynxxIcon"; OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.Position = UDim2.new(0,20,0.5,-25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenBtn.Image = "rbxassetid://15125301131"
OpenBtn.Visible = false; OpenBtn.ZIndex = 10
local LogoCorner = Instance.new("UICorner", OpenBtn)
LogoCorner.CornerRadius = UDim.new(1,0)
MakeDraggable(OpenBtn, OpenBtn)

-- ============================================================
-- MAIN FRAME
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"; MainFrame.BackgroundColor3 = COLOR.BG
MainFrame.Size = UDim2.new(0,540,0,360); MainFrame.Position = UDim2.new(0.5,-270,0.5,-180)
MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

local TopGrip = Instance.new("Frame", MainFrame)
TopGrip.Size = UDim2.new(0,40,0,3); TopGrip.Position = UDim2.new(0.5,-20,0,8)
TopGrip.BackgroundColor3 = COLOR.ORANGE; TopGrip.BorderSizePixel = 0
Instance.new("UICorner", TopGrip)
MakeDraggable(MainFrame, TopGrip)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1,0,0,50); Header.BackgroundTransparency = 1

local LynxxTitle = Instance.new("TextLabel", Header)
LynxxTitle.Text = "Lynxx 🪐"; LynxxTitle.Position = UDim2.new(0,15,0,15)
LynxxTitle.Size = UDim2.new(0,90,0,22); LynxxTitle.TextColor3 = COLOR.ORANGE
LynxxTitle.Font = Enum.Font.GothamBold; LynxxTitle.TextSize = 16
LynxxTitle.BackgroundTransparency = 1; LynxxTitle.TextXAlignment = Enum.TextXAlignment.Left

local Sep = Instance.new("Frame", Header)
Sep.Size = UDim2.new(0,1,0,20); Sep.Position = UDim2.new(0,110,0,18)
Sep.BackgroundColor3 = Color3.fromRGB(60,60,60); Sep.BorderSizePixel = 0

local GameTitle = Instance.new("TextLabel", Header)
GameTitle.Text = "Violence District"; GameTitle.Position = UDim2.new(0,120,0,15)
GameTitle.Size = UDim2.new(0,160,0,22); GameTitle.TextColor3 = Color3.fromRGB(140,140,140)
GameTitle.Font = Enum.Font.GothamMedium; GameTitle.TextSize = 13
GameTitle.BackgroundTransparency = 1; GameTitle.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,30,0,30); MinBtn.Position = UDim2.new(1,-42,0,10)
MinBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16; MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)
MinBtn.Activated:Connect(function() MainFrame.Visible=false; OpenBtn.Visible=true end)
OpenBtn.Activated:Connect(function() MainFrame.Visible=true; OpenBtn.Visible=false end)

-- Resize
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0,15,0,15); ResizeBtn.Position = UDim2.new(1,-20,1,-20)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); ResizeBtn.Text = ""
ResizeBtn.BorderSizePixel = 0; Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0,3)
local resizing=false
ResizeBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        resizing=true; local ss=MainFrame.Size; local sp=inp.Position; local mc
        mc=UserInputService.InputChanged:Connect(function(mi)
            if resizing and (mi.UserInputType==Enum.UserInputType.MouseMovement or mi.UserInputType==Enum.UserInputType.Touch) then
                local d=mi.Position-sp
                MainFrame.Size=UDim2.new(0,math.max(480,ss.X.Offset+d.X),0,math.max(320,ss.Y.Offset+d.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function() resizing=false; if mc then mc:Disconnect() end end)
    end
end)

-- ============================================================
-- SIDEBAR & CONTAINER
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0,10,0,55); Sidebar.Size = UDim2.new(0,130,1,-65)
Sidebar.BackgroundColor3 = COLOR.SIDEBAR; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)
local SL = Instance.new("UIListLayout", Sidebar); SL.Padding = UDim.new(0,4)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,8)

local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0,150,0,55); Container.Size = UDim2.new(1,-160,1,-65)
Container.BackgroundTransparency = 1

-- ============================================================
-- PAGE & TAB SYSTEM
-- ============================================================
local Pages = {}; local TabButtons = {}

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name=name; pg.Size=UDim2.new(1,0,1,0)
    pg.BackgroundTransparency=1; pg.Visible=false
    pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=COLOR.ORANGE
    pg.ScrollBarImageTransparency=0.5; pg.BorderSizePixel=0
    pcall(function() pg.AutomaticCanvasSize=Enum.AutomaticSize.Y end)
    local layout=Instance.new("UIListLayout",pg)
    layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding",pg).PaddingBottom=UDim.new(0,10)
    Pages[name]=pg; return pg
end

local function AddTab(name, icon)
    local btn=Instance.new("TextButton",Sidebar)
    btn.Size=UDim2.new(1,0,0,38); btn.BackgroundTransparency=1
    btn.Text="  "..icon.." "..name; btn.TextColor3=Color3.fromRGB(130,130,130)
    btn.Font=Enum.Font.GothamMedium; btn.TextSize=12
    btn.TextXAlignment=Enum.TextXAlignment.Left; btn.BorderSizePixel=0

    local ind=Instance.new("Frame",btn)
    ind.Size=UDim2.new(0,3,0,18); ind.Position=UDim2.new(0,6,0.5,-9)
    ind.BackgroundColor3=COLOR.ORANGE; ind.Visible=false
    ind.BorderSizePixel=0; Instance.new("UICorner",ind)

    btn.Activated:Connect(function()
        for _,p in pairs(Pages) do p.Visible=false end
        for _,tb in pairs(TabButtons) do
            tb.btn.TextColor3=Color3.fromRGB(130,130,130); tb.ind.Visible=false
        end
        if Pages[name] then Pages[name].Visible=true end
        btn.TextColor3=Color3.new(1,1,1); ind.Visible=true
    end)
    table.insert(TabButtons,{btn=btn,ind=ind})
    return btn,ind
end

local EspPage = CreatePage("ESP")
local AimPage = CreatePage("Aimbot")
local PlrPage = CreatePage("Player")
local VisPage = CreatePage("Visual")
local UtlPage = CreatePage("Utility")
local SetPage = CreatePage("Settings")

local espBtn,espInd = AddTab("ESP","👁️")
AddTab("Aimbot","🎯"); AddTab("Player","🧑")
AddTab("Visual","🎨"); AddTab("Utility","🔧"); AddTab("Settings","⚙️")

EspPage.Visible=true; espBtn.TextColor3=Color3.new(1,1,1); espInd.Visible=true

-- ============================================================
-- UI HELPERS
-- ============================================================
local function SectionHeader(parent, text, order)
    local lbl=Instance.new("TextLabel",parent)
    lbl.Text=text; lbl.Size=UDim2.new(1,-10,0,26)
    lbl.TextColor3=COLOR.ORANGE; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=12; lbl.BackgroundTransparency=1
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.LayoutOrder=order
    return lbl
end

local function CreateToggle(parent, labelText, state, callback, order)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,-10,0,44); row.BackgroundColor3=COLOR.DARK
    row.BorderSizePixel=0; row.LayoutOrder=order or 0
    Instance.new("UICorner",row)

    local lbl=Instance.new("TextLabel",row)
    lbl.Text="  "..labelText; lbl.Size=UDim2.new(1,-60,1,0)
    lbl.TextColor3=Color3.new(1,1,1); lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12
    lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left

    local track=Instance.new("TextButton",row)
    track.Size=UDim2.new(0,46,0,24); track.Position=UDim2.new(1,-56,0.5,-12)
    track.BackgroundColor3=state and COLOR.ORANGE or Color3.fromRGB(50,50,50)
    track.Text=""; track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,18,0,18)
    knob.Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local on=state
    track.Activated:Connect(function()
        on=not on
        TweenService:Create(track,TweenInfo.new(0.18),{
            BackgroundColor3=on and COLOR.ORANGE or Color3.fromRGB(50,50,50)
        }):Play()
        TweenService:Create(knob,TweenInfo.new(0.18),{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        }):Play()
        callback(on)
    end)
    return row, track, knob
end

-- Dropdown feature (pakai arrow ▼▲ seperti v5.3)
local function AddDropdownFeature(parent, title, options_table, order)
    local frame=Instance.new("TextButton",parent)
    frame.Size=UDim2.new(1,-10,0,44); frame.BackgroundColor3=COLOR.DARK
    frame.Text=""; frame.BorderSizePixel=0; frame.LayoutOrder=order or 0
    Instance.new("UICorner",frame)

    local label=Instance.new("TextLabel",frame)
    label.Text="  "..title; label.Size=UDim2.new(1,-40,1,0)
    label.TextColor3=Color3.new(1,1,1); label.Font=Enum.Font.GothamMedium; label.TextSize=12
    label.BackgroundTransparency=1; label.TextXAlignment=Enum.TextXAlignment.Left

    local arrow=Instance.new("TextLabel",frame)
    arrow.Text="▼  "; arrow.Size=UDim2.new(0,35,1,0); arrow.Position=UDim2.new(1,-35,0,0)
    arrow.TextColor3=COLOR.ORANGE; arrow.BackgroundTransparency=1
    arrow.TextXAlignment=Enum.TextXAlignment.Right; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=13

    local isOpen=false
    local listFrame=Instance.new("Frame",parent)
    listFrame.Size=UDim2.new(1,-10,0,0); listFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
    listFrame.ClipsDescendants=true; listFrame.BorderSizePixel=0
    listFrame.LayoutOrder=(order or 0)+0.5; Instance.new("UICorner",listFrame)
    local ll=Instance.new("UIListLayout",listFrame); ll.Padding=UDim.new(0,2)
    Instance.new("UIPadding",listFrame).PaddingTop=UDim.new(0,4)

    local itemCount=0
    for _,opt in pairs(options_table) do
        itemCount=itemCount+1
        local b=Instance.new("TextButton",listFrame)
        b.Size=UDim2.new(1,0,0,34); b.BackgroundColor3=Color3.fromRGB(35,35,35)
        b.Text="  "..opt.Name; b.TextColor3=Color3.fromRGB(180,180,180)
        b.Font=Enum.Font.Gotham; b.TextSize=12; b.TextXAlignment=Enum.TextXAlignment.Left; b.BorderSizePixel=0
        local stateOn=false
        b.Activated:Connect(function()
            stateOn=not stateOn
            TweenService:Create(b,TweenInfo.new(0.15),{
                BackgroundColor3=stateOn and Color3.fromRGB(50,35,10) or Color3.fromRGB(35,35,35)
            }):Play()
            b.TextColor3=stateOn and COLOR.ORANGE or Color3.fromRGB(180,180,180)
            opt.Callback(stateOn)
        end)
    end

    local fullH=(itemCount*36)+8
    frame.Activated:Connect(function()
        isOpen=not isOpen
        TweenService:Create(listFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Size=isOpen and UDim2.new(1,-10,0,fullH) or UDim2.new(1,-10,0,0)
        }):Play()
        arrow.Text=isOpen and "▲  " or "▼  "
    end)
    return frame,listFrame
end

-- Slider helper
local function CreateSlider(parent, labelText, minVal, maxVal, defaultVal, callback, order)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,-10,0,56); row.BackgroundColor3=COLOR.DARK
    row.BorderSizePixel=0; row.LayoutOrder=order or 0
    Instance.new("UICorner",row)

    local lbl=Instance.new("TextLabel",row)
    lbl.Text="  "..labelText; lbl.Size=UDim2.new(0.6,0,0,22)
    lbl.Position=UDim2.new(0,0,0,4)
    lbl.TextColor3=Color3.new(1,1,1); lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12
    lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left

    local valLbl=Instance.new("TextLabel",row)
    valLbl.Text=tostring(defaultVal); valLbl.Size=UDim2.new(0.35,0,0,22)
    valLbl.Position=UDim2.new(0.63,0,0,4)
    valLbl.TextColor3=COLOR.ORANGE; valLbl.Font=Enum.Font.GothamBold; valLbl.TextSize=12
    valLbl.BackgroundTransparency=1; valLbl.TextXAlignment=Enum.TextXAlignment.Right

    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,-20,0,6); track.Position=UDim2.new(0,10,0,34)
    track.BackgroundColor3=Color3.fromRGB(50,50,50); track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track)
    local pct=(defaultVal-minVal)/(maxVal-minVal)
    fill.Size=UDim2.new(pct,0,1,0); fill.BackgroundColor3=COLOR.ORANGE
    fill.BorderSizePixel=0; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("TextButton",track)
    knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new(pct,0,0.5,0)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.Text=""; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local sliding=false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sliding=true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sliding=false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local absPos=track.AbsolutePosition.X
            local absSize=track.AbsoluteSize.X
            local rel=math.clamp((i.Position.X-absPos)/absSize,0,1)
            local val=math.floor(minVal+(maxVal-minVal)*rel)
            fill.Size=UDim2.new(rel,0,1,0)
            knob.Position=UDim2.new(rel,0,0.5,0)
            valLbl.Text=tostring(val)
            callback(val)
        end
    end)
    return row
end

-- ============================================================
-- ══════════════ LOGIC FUNCTIONS ══════════════
-- ============================================================

-- ─── UTILS ──────────────────────────────────────────────────
local function aliveObj(o)
    if not o then return false end
    local ok=pcall(function() return o.Parent end)
    return ok and o.Parent~=nil
end

local function findClosestPlayer(maxDist)
    local closest,shortest=nil,maxDist or 200
    local myChar=LocalPlayer.Character
    if not myChar then return nil end
    local myHRP=myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and pl.Character then
            local hrp=pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist=(myHRP.Position-hrp.Position).Magnitude
                if dist<shortest then shortest=dist; closest=pl end
            end
        end
    end
    return closest
end

-- ─── ESP PLAYER ─────────────────────────────────────────────
local espPlayerConns={}; local espLoopConn=nil
local rainbowTick=0

local function makeTag(plName, role)
    local col=(role=="Killer") and COLOR.KILLER or COLOR.SURVIVOR
    local g=Instance.new("BillboardGui")
    g.Name="ESP_Tag"; g.AlwaysOnTop=true
    g.Size=UDim2.new(0,200,0,68); g.StudsOffset=Vector3.new(0,3.5,0)

    local nameL=Instance.new("TextLabel",g); nameL.Name="NameL"
    nameL.BackgroundTransparency=1; nameL.Size=UDim2.new(1,0,0,20)
    nameL.Position=UDim2.new(0,0,0,0); nameL.Font=Enum.Font.GothamBold
    nameL.TextSize=13; nameL.TextColor3=col
    nameL.TextStrokeTransparency=0; nameL.TextStrokeColor3=Color3.new(0,0,0)
    nameL.Text=plName.." ["..role.."]"

    local roleTag=Instance.new("Frame",g); roleTag.Name="RoleBar"
    roleTag.Size=UDim2.new(0,60,0,12); roleTag.Position=UDim2.new(0.5,-30,0,20)
    roleTag.BackgroundColor3=col; roleTag.BorderSizePixel=0
    Instance.new("UICorner",roleTag).CornerRadius=UDim.new(0,4)
    local roleLbl=Instance.new("TextLabel",roleTag)
    roleLbl.Size=UDim2.new(1,0,1,0); roleLbl.BackgroundTransparency=1
    roleLbl.Text=role; roleLbl.Font=Enum.Font.GothamBold; roleLbl.TextSize=9
    roleLbl.TextColor3=Color3.new(1,1,1); roleLbl.TextXAlignment=Enum.TextXAlignment.Center

    local hpL=Instance.new("TextLabel",g); hpL.Name="HpL"
    hpL.BackgroundTransparency=1; hpL.Size=UDim2.new(1,0,0,16)
    hpL.Position=UDim2.new(0,0,0,35); hpL.Font=Enum.Font.Gotham; hpL.TextSize=11
    hpL.TextColor3=Color3.fromRGB(220,220,220); hpL.Text="HP: --"
    hpL.TextStrokeTransparency=0; hpL.TextStrokeColor3=Color3.new(0,0,0)

    local distL=Instance.new("TextLabel",g); distL.Name="DistL"
    distL.BackgroundTransparency=1; distL.Size=UDim2.new(1,0,0,14)
    distL.Position=UDim2.new(0,0,0,52); distL.Font=Enum.Font.Gotham; distL.TextSize=10
    distL.TextColor3=Color3.fromRGB(180,180,180); distL.Text="0 m"
    distL.TextStrokeTransparency=0; distL.TextStrokeColor3=Color3.new(0,0,0)

    return g
end

local function applyESP(pl)
    if pl==LocalPlayer then return end
    local c=pl.Character; if not (c and aliveObj(c)) then return end
    local role=getRole(pl)
    local col
    if States.RainbowESP then
        col=Color3.fromHSV((rainbowTick%1),1,1)
    else
        col=(role=="Killer") and COLOR.KILLER or COLOR.SURVIVOR
    end

    -- Highlight (box)
    if States.EspBox then
        local hl=c:FindFirstChild("ESP_HL")
        if not hl then
            hl=Instance.new("Highlight"); hl.Name="ESP_HL"
            hl.Adornee=c; hl.FillTransparency=0.5
            hl.OutlineTransparency=0
            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=c
        end
        hl.FillColor=col; hl.OutlineColor=col
    else
        local hl=c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
    end

    -- Head dot
    local head=c:FindFirstChild("Head")
    if head and aliveObj(head) then
        if States.EspHeadDot then
            local dot=head:FindFirstChild("ESP_Dot")
            if not dot then
                local bb=Instance.new("BillboardGui"); bb.Name="ESP_Dot"
                bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,12,0,12)
                bb.StudsOffset=Vector3.new(0,0.7,0); bb.Parent=head
                local fr=Instance.new("Frame",bb); fr.Size=UDim2.new(1,0,1,0)
                fr.BackgroundColor3=col; fr.BorderSizePixel=0
                Instance.new("UICorner",fr).CornerRadius=UDim.new(1,0)
            end
        else
            local dot=head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
        end

        -- Tag (nama, hp, jarak)
        local tag=head:FindFirstChild("ESP_Tag")
        if not tag then
            tag=makeTag(pl.Name, role); tag.Parent=head
        end
        local nameL=tag:FindFirstChild("NameL")
        if nameL then nameL.Visible=States.EspName; nameL.TextColor3=col end
        local rolebar=tag:FindFirstChild("RoleBar")
        if rolebar then rolebar.BackgroundColor3=col end

        local hum=c:FindFirstChildOfClass("Humanoid")
        local hpL=tag:FindFirstChild("HpL")
        if hpL then
            hpL.Visible=States.EspHP
            if hum and hum.Parent then
                hpL.Text="HP: "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
            end
        end

        local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hrp=c:FindFirstChild("HumanoidRootPart")
        local distL=tag:FindFirstChild("DistL")
        if distL then
            distL.Visible=States.EspDist
            if myHRP and hrp and hrp.Parent then
                distL.Text=math.floor((hrp.Position-myHRP.Position).Magnitude).." m"
            end
        end
    end

    -- Tracer (via Drawing jika executor support)
    if States.EspTracer then
        pcall(function()
            if not rawget(_G,"Drawing") then return end
            local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            local line=Drawing.new("Line")
            local fromPos=Camera:WorldToViewportPoint(myHRP.Position)
            local toPos=Camera:WorldToViewportPoint(hrp.Position)
            line.Visible=true; line.Color=col; line.Thickness=1
            line.From=Vector2.new(fromPos.X,fromPos.Y)
            line.To=Vector2.new(toPos.X,toPos.Y)
            task.delay(0.05, function() pcall(function() line:Remove() end) end)
        end)
    end
end

local function startESPPlayer()
    espLoopConn=RunService.Heartbeat:Connect(function(dt)
        rainbowTick=rainbowTick+dt*0.4
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then pcall(applyESP,pl) end
        end
    end)
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            espPlayerConns[pl]=espPlayerConns[pl] or {}
            table.insert(espPlayerConns[pl], pl.CharacterAdded:Connect(function()
                task.wait(0.5); pcall(applyESP,pl)
            end))
        end
    end
end

local function stopESPPlayer()
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn=nil end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            local c=pl.Character
            local hl=c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
            local head=c:FindFirstChild("Head")
            if head then
                local tag=head:FindFirstChild("ESP_Tag"); if tag then tag:Destroy() end
                local dot=head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
            end
        end
    end
    for _,conns in pairs(espPlayerConns) do
        for _,cn in pairs(conns) do pcall(function() cn:Disconnect() end) end
    end
    espPlayerConns={}
end

-- ─── ESP GENERATOR ──────────────────────────────────────────
local genHL={}; local genLoopConn=nil

local function getGenProg(gen)
    local v=gen:GetAttribute("RepairProgress")
    if v then return (v<=1) and math.floor(v*100) or math.min(math.floor(v),100) end
    return 0
end

local function buildGenESP()
    for _,d in pairs(genHL) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end; genHL={}
    local map=WS:FindFirstChild("Map") or WS:FindFirstChild("Map1")
    if not map then return end
    for _,obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name=="Generator" then
            local part=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local prog=getGenProg(obj)
                local col=prog>=100 and COLOR.GEN_DONE or COLOR.GEN_PROG
                local hl=Instance.new("Highlight"); hl.FillColor=col; hl.OutlineColor=col
                hl.FillTransparency=0.6; hl.OutlineTransparency=0
                hl.Adornee=obj; hl.Parent=obj
                local bb=Instance.new("BillboardGui"); bb.Name="GenESP"
                bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,140,0,36)
                bb.StudsOffset=Vector3.new(0,4,0); bb.Adornee=part; bb.Parent=part
                local lbl=Instance.new("TextLabel",bb)
                lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
                lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12
                lbl.Text="⚙ "..prog.."%"; lbl.TextColor3=col
                lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
                genHL[obj]={hl=hl,bb=bb,lbl=lbl}
            end
        end
    end
end

local function startESPGenerator()
    buildGenESP()
    genLoopConn=RunService.Heartbeat:Connect(function()
        for gen,d in pairs(genHL) do
            if gen and gen.Parent then
                local prog=getGenProg(gen); local col=prog>=100 and COLOR.GEN_DONE or COLOR.GEN_PROG
                if d.hl then d.hl.FillColor=col; d.hl.OutlineColor=col end
                if d.lbl then d.lbl.Text="⚙ "..prog.."%"; d.lbl.TextColor3=col end
            else
                pcall(function() if d.hl then d.hl:Destroy() end end)
                pcall(function() if d.bb then d.bb:Destroy() end end)
                genHL[gen]=nil
            end
        end
    end)
end

local function stopESPGenerator()
    if genLoopConn then genLoopConn:Disconnect(); genLoopConn=nil end
    for _,d in pairs(genHL) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end; genHL={}
end

-- ─── PALLET ESP ─────────────────────────────────────────────
local palReg={}; local palLoopConn=nil

local function findPallets()
    for _,e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg={}
    for _,obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name=="Palletwrong" or obj.Name:lower():find("pallet")) then
            if not palReg[obj] then palReg[obj]={model=obj,hl=nil} end
        end
    end
end

local function startPalletESP()
    findPallets()
    palLoopConn=RunService.Heartbeat:Connect(function()
        for model,entry in pairs(palReg) do
            if model and aliveObj(model) then
                if not entry.hl or not aliveObj(entry.hl) then
                    local h=Instance.new("Highlight"); h.Name="PalESP_HL"
                    h.Adornee=model; h.FillTransparency=1
                    h.OutlineColor=COLOR.PALLET; h.OutlineTransparency=0
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent=model; entry.hl=h
                end
            else
                pcall(function() if entry.hl then entry.hl:Destroy() end end)
                palReg[model]=nil
            end
        end
    end)
end

local function stopPalletESP()
    if palLoopConn then palLoopConn:Disconnect(); palLoopConn=nil end
    for _,e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg={}
end

-- ─── AIMBOT ─────────────────────────────────────────────────
local aimbotConn=nil; local aimTarget=nil
local fovCircle=nil

local function drawFOV(radius)
    pcall(function()
        if fovCircle then fovCircle:Remove() end
        if not radius or radius<=0 then return end
        fovCircle=Drawing.new("Circle")
        fovCircle.Visible=true; fovCircle.Radius=radius
        fovCircle.Color=COLOR.ORANGE; fovCircle.Thickness=1
        fovCircle.Filled=false; fovCircle.NumSides=64
        local vp=Camera.ViewportSize
        fovCircle.Position=Vector2.new(vp.X/2,vp.Y/2)
    end)
end

local function getBodyPart(char, bone)
    if bone=="head" then return char:FindFirstChild("Head") end
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function isInFOV(pl, radius)
    if not pl.Character then return false end
    local hrp=pl.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then return false end
    local vp=Camera.ViewportSize
    local cx,cy=vp.X/2,vp.Y/2
    return ((pos.X-cx)^2+(pos.Y-cy)^2)^0.5 <= radius
end

local function startAimbot()
    aimbotConn=RunService.Heartbeat:Connect(function()
        if not States.Aimbot then return end
        -- Find target
        local best=nil; local bestDist=math.huge
        local vp=Camera.ViewportSize; local cx,cy=vp.X/2,vp.Y/2
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer and pl.Character then
                if States.AimbotTeamCheck and getRole(pl)=="Survivor" and getRole(LocalPlayer)=="Survivor" then
                    -- don't aim at survivors if you are survivor
                else
                    local hrp=pl.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local d=((pos.X-cx)^2+(pos.Y-cy)^2)^0.5
                            if d<States.AimbotFOV and d<bestDist then
                                bestDist=d; best=pl
                            end
                        end
                    end
                end
            end
        end
        aimTarget=best
        if best and best.Character then
            local part=getBodyPart(best.Character, States.AimbotBone)
            if part then
                Camera.CFrame=CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end)
end

local function stopAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn=nil end
    aimTarget=nil
    pcall(function() if fovCircle then fovCircle:Remove(); fovCircle=nil end end)
    pcall(function() Camera.CameraType=Enum.CameraType.Custom end)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject=LocalPlayer.Character.Humanoid
    end
end

-- ─── PLAYER MODS ────────────────────────────────────────────
local noClipConn=nil; local flyConn=nil; local flyBV=nil
local godConn=nil; local antiKnockConn=nil; local infJumpConn=nil
local origJump=50

-- NoClip
local function startNoClip()
    noClipConn=RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end)
end
local function stopNoClip()
    if noClipConn then noClipConn:Disconnect(); noClipConn=nil end
    local c=LocalPlayer.Character; if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=true end
    end
end

-- Fly
local function startFly()
    local c=LocalPlayer.Character; if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.PlatformStand=true
    flyBV=Instance.new("BodyVelocity",hrp)
    flyBV.Velocity=Vector3.new(0,0,0); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
    flyConn=RunService.Heartbeat:Connect(function()
        local dir=Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
        if flyBV and flyBV.Parent then flyBV.Velocity=dir.Unit~=dir.Unit and Vector3.new(0,0,0) or dir*50 end
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBV then flyBV:Destroy(); flyBV=nil end
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand=false end
end

-- God Mode
local function startGod()
    godConn=RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
    end)
end
local function stopGod()
    if godConn then godConn:Disconnect(); godConn=nil end
end

-- Infinite Jump
local function startInfJump()
    infJumpConn=UserInputService.JumpRequest:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn=nil end
end

-- Anti Knockback
local function startAntiKnock()
    antiKnockConn=RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.Velocity=Vector3.new(hrp.Velocity.X*0.1,hrp.Velocity.Y,hrp.Velocity.Z*0.1)
    end)
end
local function stopAntiKnock()
    if antiKnockConn then antiKnockConn:Disconnect(); antiKnockConn=nil end
end

-- ─── VISUAL ─────────────────────────────────────────────────
local origAmbient=Lighting.Ambient
local origBrightness=Lighting.Brightness
local origFogEnd=Lighting.FogEnd

local function setFullBright(on)
    if on then
        Lighting.Ambient=Color3.fromRGB(255,255,255)
        Lighting.Brightness=2
    else
        Lighting.Ambient=origAmbient
        Lighting.Brightness=origBrightness
    end
end

local function setNoFog(on)
    Lighting.FogEnd=on and 1e6 or origFogEnd
end

local crosshairGui=nil
local function setCustomCrosshair(on)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui=nil end
    if not on then return end
    local sg=Instance.new("ScreenGui")
    sg.Name="VD_Crosshair"; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.Parent=PlayerGui
    crosshairGui=sg
    local ch=Instance.new("Frame",sg)
    ch.AnchorPoint=Vector2.new(0.5,0.5)
    ch.Position=UDim2.new(0.5,0,0.5,0); ch.Size=UDim2.new(0,24,0,24)
    ch.BackgroundTransparency=1
    local function line(w,h)
        local f=Instance.new("Frame",ch)
        f.AnchorPoint=Vector2.new(0.5,0.5)
        f.Position=UDim2.new(0.5,0,0.5,0); f.Size=UDim2.new(0,w,0,h)
        f.BackgroundColor3=COLOR.ORANGE; f.BorderSizePixel=0
    end
    line(2,18); line(18,2)
end

local chamsConn=nil
local function setChams(on)
    if chamsConn then chamsConn:Disconnect(); chamsConn=nil end
    if on then
        chamsConn=RunService.Heartbeat:Connect(function()
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LocalPlayer and pl.Character then
                    for _,p in ipairs(pl.Character:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Material=Enum.Material.Neon
                            p.Color=(getRole(pl)=="Killer") and COLOR.KILLER or COLOR.SURVIVOR
                        end
                    end
                end
            end
        end)
    end
end

-- ─── UTILITY ────────────────────────────────────────────────
local antiAfkConn=nil
local function setAntiAFK(on)
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn=nil end
    if on then
        local t=0
        antiAfkConn=RunService.Heartbeat:Connect(function(dt)
            t=t+dt
            if t>60 then
                t=0
                -- simulasi gerakan kecil
                local c=LocalPlayer.Character; if not c then return end
                local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
                hum:Move(Vector3.new(0.01,0,0))
            end
        end)
    end
end

local fpsBoostObjects={}
local function setFPSBoost(on)
    if on then
        -- Hapus partikel dan efek berat
        for _,obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled=false
                table.insert(fpsBoostObjects,obj)
            end
        end
        Lighting.GlobalShadows=false
    else
        for _,obj in ipairs(fpsBoostObjects) do
            pcall(function() obj.Enabled=true end)
        end
        fpsBoostObjects={}
        Lighting.GlobalShadows=true
    end
end

local function teleportToPlayer(target)
    if not target or not target.Character then return end
    local c=LocalPlayer.Character; if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart")
    local thrp=target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and thrp then
        hrp.CFrame=thrp.CFrame*CFrame.new(0,0,3)
    end
end

local function serverHop()
    pcall(function()
        local id=game.PlaceId
        local servers={}
        local ok,res=pcall(function()
            return game:GetService("HttpService"):JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..id.."/servers/Public?limit=10"))
        end)
        if ok and res and res.data then
            for _,s in ipairs(res.data) do
                if s.id~=game.JobId and (s.maxPlayers-s.playing)>0 then
                    table.insert(servers,s.id)
                end
            end
        end
        if #servers>0 then
            TeleportService:TeleportToPlaceInstance(id,servers[math.random(1,#servers)],LocalPlayer)
        end
    end)
end

local function rejoin()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

-- Spectate
local specConn=nil
local function startSpectate(target)
    if specConn then specConn:Disconnect(); specConn=nil end
    if not target then pcall(function() Camera.CameraType=Enum.CameraType.Custom end); return end
    States.SpectateTarget=target
    pcall(function() Camera.CameraType=Enum.CameraType.Scriptable end)
    specConn=RunService.Heartbeat:Connect(function()
        if not target or not target.Character then
            pcall(function() Camera.CameraType=Enum.CameraType.Custom end); specConn:Disconnect(); return
        end
        local hrp=target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Camera.CFrame=CFrame.new(hrp.Position+Vector3.new(0,5,-8),hrp.Position) end
    end)
end

-- ============================================================
-- ══════════════ ESP PAGE ══════════════
-- ============================================================
SectionHeader(EspPage,"👥  ESP Player",1)

-- Legend bar
local legendRow=Instance.new("Frame",EspPage)
legendRow.Size=UDim2.new(1,-10,0,30); legendRow.BackgroundColor3=Color3.fromRGB(22,22,22)
legendRow.BorderSizePixel=0; legendRow.LayoutOrder=2; Instance.new("UICorner",legendRow)
local sLbl=Instance.new("TextLabel",legendRow)
sLbl.Size=UDim2.new(0.5,0,1,0); sLbl.Text="  🟢 Survivor"
sLbl.Font=Enum.Font.GothamBold; sLbl.TextSize=12; sLbl.TextColor3=COLOR.SURVIVOR
sLbl.BackgroundTransparency=1; sLbl.TextXAlignment=Enum.TextXAlignment.Left
local kLbl=Instance.new("TextLabel",legendRow)
kLbl.Size=UDim2.new(0.5,0,1,0); kLbl.Position=UDim2.new(0.5,0,0,0)
kLbl.Text="🔴 Killer  "; kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=12
kLbl.TextColor3=COLOR.KILLER; kLbl.BackgroundTransparency=1; kLbl.TextXAlignment=Enum.TextXAlignment.Right

CreateToggle(EspPage,"ESP Player  (Highlight + Info)",false,function(s)
    States.EspPlayer=s
    if s then startESPPlayer() else stopESPPlayer() end
end,3)

AddDropdownFeature(EspPage,"🔧  Opsi Tampilan ESP Player",{
    {Name="Tampilkan Nama",  Callback=function(s) States.EspName=s end},
    {Name="Tampilkan HP",    Callback=function(s) States.EspHP=s end},
    {Name="Tampilkan Jarak", Callback=function(s) States.EspDist=s end},
    {Name="Box / Highlight", Callback=function(s) States.EspBox=s
        if not s then
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl.Character then
                    local hl=pl.Character:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
                end
            end
        end
    end},
    {Name="Head Dot",        Callback=function(s) States.EspHeadDot=s end},
    {Name="Tracer",          Callback=function(s) States.EspTracer=s end},
    {Name="Rainbow ESP",     Callback=function(s) States.RainbowESP=s end},
},4)

SectionHeader(EspPage,"⚙️  ESP Generator",10)
CreateToggle(EspPage,"ESP Generator  (Progress %)",false,function(s)
    States.EspGenerator=s
    if s then startESPGenerator() else stopESPGenerator() end
end,11)

SectionHeader(EspPage,"🪵  Pallet ESP",15)
CreateToggle(EspPage,"Pallet ESP  (Outline Ungu)",false,function(s)
    States.PalletEsp=s
    if s then startPalletESP() else stopPalletESP() end
end,16)

-- ============================================================
-- ══════════════ AIMBOT PAGE ══════════════
-- ============================================================
SectionHeader(AimPage,"🎯  Aimbot / Aim Assist",1)

CreateToggle(AimPage,"Aimbot  (Auto Aim ke Target)",false,function(s)
    States.Aimbot=s
    if s then startAimbot() else stopAimbot() end
end,2)

CreateToggle(AimPage,"Team Check  (Jangan Aim ke Survivor)",true,function(s)
    States.AimbotTeamCheck=s
end,3)

AddDropdownFeature(AimPage,"🦴  Target Bone",{
    {Name="Head  (Kepala)", Callback=function(s)
        if s then States.AimbotBone="head" end
    end},
    {Name="Body  (Badan) — Default", Callback=function(s)
        if s then States.AimbotBone="body" end
    end},
},4)

AddDropdownFeature(AimPage,"📐  FOV Circle",{
    {Name="Kecil  (FOV 60)",   Callback=function(s) if s then States.AimbotFOV=60;  drawFOV(60)  end end},
    {Name="Sedang  (FOV 100)", Callback=function(s) if s then States.AimbotFOV=100; drawFOV(100) end end},
    {Name="Besar  (FOV 200)",  Callback=function(s) if s then States.AimbotFOV=200; drawFOV(200) end end},
    {Name="Off (Hapus Circle)",Callback=function(s) if s then drawFOV(0) end end},
},5)

-- ============================================================
-- ══════════════ PLAYER PAGE ══════════════
-- ============================================================
SectionHeader(PlrPage,"🧑  Character Mod",1)

CreateSlider(PlrPage,"WalkSpeed",4,100,16,function(v)
    States.WalkSpeed=v
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=v end
end,2)

CreateSlider(PlrPage,"Jump Power",0,200,50,function(v)
    States.JumpPower=v
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.JumpPower=v end
end,3)

CreateToggle(PlrPage,"Infinite Jump",false,function(s)
    States.InfiniteJump=s
    if s then startInfJump() else stopInfJump() end
end,4)

CreateToggle(PlrPage,"No Clip  (Tembus Objek)",false,function(s)
    States.NoClip=s
    if s then startNoClip() else stopNoClip() end
end,5)

CreateToggle(PlrPage,"Fly Mode  (WASD + Space / Ctrl)",false,function(s)
    States.FlyMode=s
    if s then startFly() else stopFly() end
end,6)

CreateToggle(PlrPage,"God Mode  (Tidak Bisa Mati)",false,function(s)
    States.GodMode=s
    if s then startGod() else stopGod() end
end,7)

CreateToggle(PlrPage,"Anti Knockback",false,function(s)
    States.AntiKnock=s
    if s then startAntiKnock() else stopAntiKnock() end
end,8)

-- ============================================================
-- ══════════════ VISUAL PAGE ══════════════
-- ============================================================
SectionHeader(VisPage,"🎨  Visual & Grafik",1)

CreateToggle(VisPage,"Full Bright  (Map Terang)",false,function(s)
    States.FullBright=s; setFullBright(s)
end,2)

CreateToggle(VisPage,"Remove Fog  (Hilangkan Kabut)",false,function(s)
    States.NoFog=s; setNoFog(s)
end,3)

CreateToggle(VisPage,"Custom Crosshair  (Titik Tengah)",false,function(s)
    States.Crosshair=s; setCustomCrosshair(s)
end,4)

CreateToggle(VisPage,"Chams  (Warna Player Tembus Tembok)",false,function(s)
    States.Chams=s; setChams(s)
end,5)

AddDropdownFeature(VisPage,"🌙  Mode Waktu",{
    {Name="Day Mode  (Siang)",    Callback=function(s) if s then Lighting.ClockTime=14 end end},
    {Name="Night Mode  (Malam)",  Callback=function(s) if s then Lighting.ClockTime=0  end end},
    {Name="Reset Default",        Callback=function(s) if s then Lighting.ClockTime=14 end end},
},6)

AddDropdownFeature(VisPage,"📷  Field of View (Camera)",{
    {Name="FOV Normal  (70)",   Callback=function(s) if s then Camera.FieldOfView=70  end end},
    {Name="FOV Lebar  (100)",   Callback=function(s) if s then Camera.FieldOfView=100 end end},
    {Name="FOV Super  (120)",   Callback=function(s) if s then Camera.FieldOfView=120 end end},
},7)

-- ============================================================
-- ══════════════ UTILITY PAGE ══════════════
-- ============================================================
SectionHeader(UtlPage,"🔧  Utility",1)

CreateToggle(UtlPage,"Anti AFK  (Tidak Kick Idle)",false,function(s)
    States.AntiAFK=s; setAntiAFK(s)
end,2)

CreateToggle(UtlPage,"FPS Boost  (Hapus Partikel)",false,function(s)
    States.FPSBoost=s; setFPSBoost(s)
end,3)

CreateToggle(UtlPage,"Unlock Camera  (Free Cam)",false,function(s)
    Camera.CameraType=s and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end,4)

-- Teleport to player dropdown
local tpDropdown
local function refreshTPList()
    -- dibangun ulang saat dibuka
end

AddDropdownFeature(UtlPage,"🚀  Teleport ke Player",
    (function()
        local list={}
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                table.insert(list,{Name=pl.Name.." ["..getRole(pl).."]",Callback=function(s)
                    if s then teleportToPlayer(pl) end
                end})
            end
        end
        if #list==0 then
            list={{Name="(Belum ada player lain)",Callback=function() end}}
        end
        return list
    end)()
,5)

-- TP Ke Killer tombol langsung
local tpKillerBtn=Instance.new("TextButton",UtlPage)
tpKillerBtn.Size=UDim2.new(1,-10,0,44); tpKillerBtn.BackgroundColor3=Color3.fromRGB(80,15,15)
tpKillerBtn.Text="  🔴  Teleport ke Killer"; tpKillerBtn.TextColor3=Color3.new(1,1,1)
tpKillerBtn.Font=Enum.Font.GothamBold; tpKillerBtn.TextSize=12; tpKillerBtn.TextXAlignment=Enum.TextXAlignment.Left
tpKillerBtn.BorderSizePixel=0; tpKillerBtn.LayoutOrder=6
Instance.new("UICorner",tpKillerBtn)
tpKillerBtn.Activated:Connect(function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and getRole(pl)=="Killer" then
            teleportToPlayer(pl); return
        end
    end
end)

-- Spectate
AddDropdownFeature(UtlPage,"👁️  Spectate Player",
    (function()
        local list={}
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                table.insert(list,{Name="Spectate: "..pl.Name,Callback=function(s)
                    startSpectate(s and pl or nil)
                end})
            end
        end
        if #list==0 then list={{Name="(Belum ada player lain)",Callback=function() end}} end
        return list
    end)()
,7)

-- Server Hop & Rejoin
local hopBtn=Instance.new("TextButton",UtlPage)
hopBtn.Size=UDim2.new(1,-10,0,44); hopBtn.BackgroundColor3=Color3.fromRGB(20,20,50)
hopBtn.Text="  🌐  Server Hop  (Pindah Server)"; hopBtn.TextColor3=Color3.new(1,1,1)
hopBtn.Font=Enum.Font.GothamBold; hopBtn.TextSize=12; hopBtn.TextXAlignment=Enum.TextXAlignment.Left
hopBtn.BorderSizePixel=0; hopBtn.LayoutOrder=8
Instance.new("UICorner",hopBtn)
hopBtn.Activated:Connect(serverHop)

local rejoinBtn=Instance.new("TextButton",UtlPage)
rejoinBtn.Size=UDim2.new(1,-10,0,44); rejoinBtn.BackgroundColor3=Color3.fromRGB(20,20,20)
rejoinBtn.Text="  🔄  Rejoin Server"; rejoinBtn.TextColor3=Color3.new(1,1,1)
rejoinBtn.Font=Enum.Font.GothamBold; rejoinBtn.TextSize=12; rejoinBtn.TextXAlignment=Enum.TextXAlignment.Left
rejoinBtn.BorderSizePixel=0; rejoinBtn.LayoutOrder=9
Instance.new("UICorner",rejoinBtn)
rejoinBtn.Activated:Connect(rejoin)

-- ============================================================
-- ══════════════ SETTINGS PAGE ══════════════
-- ============================================================
local function CreateSettingDropdown(parent, title, icon, options_list, onSelect, order)
    local titleRow=Instance.new("Frame",parent)
    titleRow.Size=UDim2.new(1,-10,0,22); titleRow.BackgroundTransparency=1
    titleRow.LayoutOrder=order
    local titleLbl=Instance.new("TextLabel",titleRow)
    titleLbl.Text=icon.."  "..title; titleLbl.Size=UDim2.new(1,0,1,0)
    titleLbl.TextColor3=Color3.fromRGB(180,180,180); titleLbl.Font=Enum.Font.GothamMedium
    titleLbl.TextSize=12; titleLbl.BackgroundTransparency=1; titleLbl.TextXAlignment=Enum.TextXAlignment.Left

    local optRow=Instance.new("Frame",parent)
    optRow.Size=UDim2.new(1,-10,0,36); optRow.BackgroundTransparency=1
    optRow.LayoutOrder=order+0.5
    local optL=Instance.new("UIListLayout",optRow)
    optL.FillDirection=Enum.FillDirection.Horizontal
    optL.Padding=UDim.new(0,6); optL.SortOrder=Enum.SortOrder.LayoutOrder

    local btnList={}
    for i,opt in ipairs(options_list) do
        local b=Instance.new("TextButton",optRow)
        b.Size=UDim2.new(0,82,1,0)
        b.BackgroundColor3=opt.default and COLOR.ORANGE or Color3.fromRGB(30,30,30)
        b.Text=opt.label
        b.TextColor3=opt.default and Color3.new(1,1,1) or Color3.fromRGB(160,160,160)
        b.Font=Enum.Font.GothamMedium; b.TextSize=12; b.BorderSizePixel=0; b.LayoutOrder=i
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
        b.Activated:Connect(function()
            for _,tb in ipairs(btnList) do
                TweenService:Create(tb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(30,30,30)}):Play()
                tb.TextColor3=Color3.fromRGB(160,160,160)
            end
            TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=COLOR.ORANGE}):Play()
            b.TextColor3=Color3.new(1,1,1); onSelect(opt.value)
        end)
        table.insert(btnList,b)
    end

    local div=Instance.new("Frame",parent)
    div.Size=UDim2.new(1,-10,0,1); div.BackgroundColor3=Color3.fromRGB(35,35,35)
    div.BorderSizePixel=0; div.LayoutOrder=order+0.9
    return optRow
end

local setH=Instance.new("TextLabel",SetPage)
setH.Text="⚙️  UI Settings"; setH.Size=UDim2.new(1,-10,0,30)
setH.TextColor3=COLOR.ORANGE; setH.Font=Enum.Font.GothamBold; setH.TextSize=14
setH.BackgroundTransparency=1; setH.TextXAlignment=Enum.TextXAlignment.Left; setH.LayoutOrder=0

CreateSettingDropdown(SetPage,"Icon Size","📐",{
    {label="Small", value="small",  default=false},
    {label="Medium",value="medium", default=true },
    {label="Large", value="large",  default=false},
},function(v)
    local s={small=35,medium=50,large=75}
    TweenService:Create(OpenBtn,TweenInfo.new(0.2),{Size=UDim2.new(0,s[v],0,s[v])}):Play()
end,1)

CreateSettingDropdown(SetPage,"Icon Shape","🔷",{
    {label="Circle", value="circle",  default=true },
    {label="Square", value="square",  default=false},
    {label="Rounded",value="rounded", default=false},
},function(v)
    local r={circle=UDim.new(1,0),square=UDim.new(0,0),rounded=UDim.new(0,12)}
    LogoCorner.CornerRadius=r[v]
end,3)

CreateSettingDropdown(SetPage,"Icon Color","🎨",{
    {label="Dark",  value="dark",  default=true },
    {label="Orange",value="orange",default=false},
    {label="Purple",value="purple",default=false},
    {label="Blue",  value="blue",  default=false},
},function(v)
    local c={dark=Color3.fromRGB(30,30,30),orange=Color3.fromRGB(200,90,0),
             purple=Color3.fromRGB(120,0,200),blue=Color3.fromRGB(0,100,220)}
    TweenService:Create(OpenBtn,TweenInfo.new(0.2),{BackgroundColor3=c[v]}):Play()
end,5)

CreateSettingDropdown(SetPage,"Accent Color","✨",{
    {label="Orange",value="orange",default=true },
    {label="Cyan",  value="cyan",  default=false},
    {label="Green", value="green", default=false},
},function(v)
    local c={orange=Color3.fromRGB(255,140,0),cyan=Color3.fromRGB(0,200,230),green=Color3.fromRGB(50,200,80)}
    TopGrip.BackgroundColor3=c[v]
end,7)

-- ============================================================
-- WATERMARK
-- ============================================================
local WM=Instance.new("TextLabel",ScreenGui)
WM.Size=UDim2.new(0,230,0,22); WM.Position=UDim2.new(1,-240,0,8)
WM.BackgroundColor3=COLOR.BG; WM.BackgroundTransparency=0.3
WM.Text=" 🪐 Lynxx VD v9.0 | Saycho"; WM.TextColor3=COLOR.ORANGE
WM.Font=Enum.Font.GothamBold; WM.TextSize=11; WM.TextXAlignment=Enum.TextXAlignment.Left; WM.ZIndex=5
Instance.new("UICorner",WM).CornerRadius=UDim.new(0,6)

-- ============================================================
-- ENSURE GUI (tidak hilang setelah respawn)
-- ============================================================
local function ensureGUI()
    if not ScreenGui or not ScreenGui.Parent then ScreenGui.Parent=getPlayerGui() end
end
RunService.Heartbeat:Connect(ensureGUI)

-- CharacterAdded — restore stats & ESP
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1); ensureGUI()

    -- Restore walkspeed & jump
    local hum=char:WaitForChild("Humanoid",5)
    if hum then
        hum.WalkSpeed=States.WalkSpeed
        hum.JumpPower=States.JumpPower
    end

    -- Restart fitur yang aktif
    if States.EspPlayer   then stopESPPlayer();    task.wait(0.1); startESPPlayer()    end
    if States.EspGenerator then stopESPGenerator(); task.wait(0.1); startESPGenerator() end
    if States.GodMode      then stopGod();          task.wait(0.1); startGod()          end
    if States.InfiniteJump then stopInfJump();      task.wait(0.1); startInfJump()      end
    if States.AntiKnock    then stopAntiKnock();    task.wait(0.1); startAntiKnock()    end
    if States.NoClip       then startNoClip()                                            end
end)

-- Pallet scan saat map baru
WS.ChildAdded:Connect(function(child)
    if (child.Name=="Map" or child.Name=="Map1") and States.PalletEsp then
        task.wait(3); findPallets()
    end
end)
task.delay(2, findPallets)

print("✅ VD v9.0 Loaded — Full Feature | By Saycho")
print("   Tab: ESP | Aimbot | Player | Visual | Utility | Settings")
