if not game:IsLoaded() then game.Loaded:Wait() end
local ps=game:GetService("Players")
local rs=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local cg=game:GetService("CoreGui")
local sgui=game:GetService("StarterGui")
local lp=ps.LocalPlayer
local cam=workspace.CurrentCamera
local ms=lp:GetMouse()
local logo=134441968486950
local alive=true
local function sf(f) pcall(f) end
pcall(function()
local bad={"dumpstring","decompile","getscriptbytecode","getbytecode","decompilefunction","getfunctionbytecode","dumpfunction","disassemble","getdisassembly","getscripts","getloadedmodules","getscriptsbytecode","decompileclosure","getscriptclosure","dump"}
for _,n in ipairs(bad) do
pcall(function()
if type(_G[n])=="function" then
if type(hookfunction)=="function" then
hookfunction(_G[n],function() return "" end)
end
end
end)
pcall(function() _G[n]=nil end)
pcall(function()
if getgenv then getgenv()[n]=nil end
end)
end
end)
pcall(function()
for _,n in ipairs({"XScript","XScript_ESP","XScript_FlyPad","XScript_Icon"}) do
local o=cg:FindFirstChild(n)
if o then o:Destroy() end
end
end)
local th={
Bg=Color3.fromRGB(9,10,16),Pn=Color3.fromRGB(16,18,30),Pl=Color3.fromRGB(24,27,44),
Ac=Color3.fromRGB(88,101,242),Ad=Color3.fromRGB(58,68,170),St=Color3.fromRGB(70,86,200),
Tx=Color3.fromRGB(178,188,235),Td=Color3.fromRGB(126,136,190),Kn=Color3.fromRGB(147,160,255)
}
local cfg={
es={On=false,M=true,S=true,I=false,D=true},
cb={sa=false,ka=false,fk=false,ad=false},
mv={fly=false,fs=60,nc=false,spd=false,sv=32,ij=false},
fm={cn=false,wp=false}
}
local fi={F=false,B=false,L=false,R=false,U=false,D=false}
local function fbc(p,c)
if not p then return nil end
local ok,l=pcall(function() return p:GetChildren() end)
if not ok then return nil end
for _,ch in ipairs(l) do if ch:IsA(c) then return ch end end
return nil
end
local function gc() return lp.Character end
local function gr()
local c=gc()
if not c then return nil end
return c:FindFirstChild("HumanoidRootPart")
end
local function gh() return fbc(gc(),"Humanoid") end
local function grl(p)
local b={}
local c=p.Character
if c then table.insert(b,c) end
local bp=p:FindFirstChild("Backpack")
if bp then table.insert(b,bp) end
for _,bx in ipairs(b) do
for _,it in ipairs(bx:GetChildren()) do
if it:IsA("Tool") then
local n=it.Name:lower()
if n:find("knife") then return "Murderer" end
if n=="gun" then return "Sheriff" end
if n=="revolver" then return "Sheriff" end
end
end
end
return "Innocent"
end
local function ra()
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
if grl(p)=="Murderer" then return true end
end
end
return false
end
local function gk()
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
if grl(p)=="Murderer" then return p end
end
end
return nil
end
local ld=0
local function sm()
if not alive then return end
local r=gr()
local h=gh()
if not r then return end
if not h then return end
if r.Position.Y<-200 then sf(function() r.CFrame=CFrame.new(0,50,0) end) end
if not cfg.cb.ad then return end
if not ra() then return end
if tick()-ld<0.5 then return end
local k=gk()
if not k then return end
local kr=nil
if k.Character then kr=k.Character:FindFirstChild("HumanoidRootPart") end
if not kr then return end
local d=(kr.Position-r.Position).Magnitude
if d<6 then
local kc=k.Character
if kc then
for _,t in ipairs(kc:GetChildren()) do
if t:IsA("Tool") then
if t.Name:lower():find("knife") then
sf(function()
r.CFrame=CFrame.new(r.Position+Vector3.new(math.random(-25,25),8,math.random(-25,25)))
ld=tick()
end)
return
end
end
end
end
end
if d<80 then
local kh=nil
if k.Character then kh=k.Character:FindFirstChild("Head") end
if kh then
local tp=(r.Position-kh.Position).Unit
local dot=tp:Dot(kh.CFrame.LookVector)
if dot>0.9 then
sf(function()
local h2=gh()
if h2 then
local pp=Vector3.new(-tp.Z,0,tp.X)
h2:MoveTo(r.Position+pp*12)
ld=tick()
end
end)
end
end
end
end
local es=Instance.new("ScreenGui")
es.Name="XScript_ESP"
es.ResetOnSpawn=false
es.Parent=cg
local ec={}
local rc={
Murderer=Color3.fromRGB(255,60,60),
Sheriff=Color3.fromRGB(60,150,255),
Innocent=Color3.fromRGB(120,255,120)
}
local function ce(p)
local c={B=nil,L=nil}
sf(function()
local b=Instance.new("BillboardGui")
b.Size=UDim2.new(0,130,0,40)
b.ExtentsOffset=Vector3.new(0,3.2,0)
b.AlwaysOnTop=true
b.MaxDistance=600
b.Enabled=false
b.Parent=es
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,0,1,0)
l.BackgroundTransparency=1
l.TextScaled=true
l.Font=Enum.Font.GothamBold
l.TextStrokeTransparency=0
l.Parent=b
c.B=b
c.L=l
end)
ec[p]=c
return c
end
local function re(p)
local c=ec[p]
if c then
sf(function() c.B:Destroy() end)
ec[p]=nil
end
end
ps.PlayerRemoving:Connect(re)
local function ue()
if not es.Parent then return end
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
local c=ec[p]
if not c then c=ce(p) end
local ch=p.Character
local hm=fbc(ch,"Humanoid")
local hd=nil
if ch then hd=ch:FindFirstChild("Head") end
local rt=nil
if ch then rt=ch:FindFirstChild("HumanoidRootPart") end
local al=false
if cfg.es.On then
if ch then
if hd then
if rt then
if hm then
if hm.Health>0 then al=true end
end
end
end
end
end
if al then
local r=grl(p)
local sh=false
if r=="Murderer" then if cfg.es.M then sh=true end end
if r=="Sheriff" then if cfg.es.S then sh=true end end
if r=="Innocent" then if cfg.es.I then sh=true end end
local co=rc[r]
if not co then co=Color3.new(1,1,1) end
if c.B then
c.B.Adornee=hd
c.B.Enabled=sh
if sh then
if c.L then
local t=r
if cfg.es.D then
local mr=gr()
if mr then t=t.." ["..tostring(math.floor((rt.Position-mr.Position).Magnitude)).."]" end
end
c.L.Text=t
c.L.TextColor3=co
end
end
end
else
if c.B then c.B.Enabled=false end
end
end
end
end
local function fk(f,k)
if fi[f] then return true end
return uis:IsKeyDown(k)
end
local function hf()
if not alive then return end
local r=gr()
if not r then return end
if cfg.mv.fly then
local d=Vector3.new(0,0,0)
local cf=cam.CFrame
if fk("F",Enum.KeyCode.W) then d=d+cf.LookVector end
if fk("B",Enum.KeyCode.S) then d=d-cf.LookVector end
if fk("L",Enum.KeyCode.A) then d=d-cf.RightVector end
if fk("R",Enum.KeyCode.D) then d=d+cf.RightVector end
if fk("U",Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
if fk("D",Enum.KeyCode.LeftControl) then d=d-Vector3.new(0,1,0) end
if d.Magnitude>0 then
sf(function() r.CFrame=r.CFrame+d.Unit*(cfg.mv.fs*0.03) end)
end
end
end
local ns={}
local function hn()
if not alive then return end
local c=gc()
if not c then return end
if cfg.mv.nc then
for _,p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") then
if ns[p]==nil then ns[p]=p.CanCollide end
p.CanCollide=false
end
end
else
if next(ns) then
for p,v in pairs(ns) do
sf(function() if p.Parent then p.CanCollide=v end end)
end
ns={}
end
end
end
local so=false
local function hs()
local h=gh()
if not h then return end
if cfg.mv.spd then
h.WalkSpeed=cfg.mv.sv
so=true
else
if so then
h.WalkSpeed=16
so=false
end
end
end
uis.JumpRequest:Connect(function()
if cfg.mv.ij then
local h=gh()
if h then sf(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end
end)
local at=nil
local av=Vector3.new(0,0,0)
local function ra2()
if not cfg.cb.sa then at=nil return end
local c=gc()
local hg=false
if c then
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n=t.Name:lower()
if n=="gun" then hg=true break end
if n=="revolver" then hg=true break end
end
end
end
if not hg then at=nil return end
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
if grl(p)=="Murderer" then
local ch=p.Character
if ch then
local rt=ch:FindFirstChild("HumanoidRootPart")
local bd=ch:FindFirstChild("UpperTorso")
if not bd then bd=ch:FindFirstChild("Torso") end
if not bd then bd=rt end
if not bd then bd=ch:FindFirstChild("Head") end
if bd then
at=bd
if rt then
local ok,v=pcall(function() return rt.Velocity end)
if ok then
if type(v)=="userdata" then av=v else av=Vector3.new(0,0,0) end
else
av=Vector3.new(0,0,0)
end
end
return
end
end
end
end
end
at=nil
end
local sai=false
local oldidx=nil
local function aimHook(s,k)
if s==ms then
if k=="Hit" then
local t=at
if t then
if t.Parent then
return CFrame.new(t.Position+(av*0.1))
end
end
end
if k=="Target" then
local t=at
if t then
if t.Parent then
return t
end
end
end
end
if type(oldidx)=="function" then
return oldidx(s,k)
end
if type(oldidx)=="table" then
return oldidx[k]
end
return nil
end
local function isa()
if sai then return true end
local ok=pcall(function()
if type(getrawmetatable)~="function" then error("a") end
if type(setreadonly)~="function" then error("b") end
local mt=getrawmetatable(game)
if not mt then error("c") end
oldidx=mt.__index
setreadonly(mt,false)
if type(newcclosure)=="function" then
mt.__index=newcclosure(aimHook)
else
mt.__index=aimHook
end
setreadonly(mt,true)
sai=true
end)
return ok
end
local function rsaM()
if not sai then return end
pcall(function()
if type(getrawmetatable)=="function" then
if type(setreadonly)=="function" then
local mt=getrawmetatable(game)
setreadonly(mt,false)
mt.__index=oldidx
setreadonly(mt,true)
end
end
end)
sai=false
end
local hookedList={}
local function redir(o,d)
local r=gr()
if not r then return d end
if (o-r.Position).Magnitude>15 then return d end
local t=at
if not t then return d end
if not t.Parent then return d end
local pos=t.Position+(av*0.1)
local dd=pos-o
if dd.Magnitude<0.01 then return d end
return dd.Unit*math.min(dd.Magnitude+1,999)
end
local function irh()
if type(hookfunction)~="function" then return false end
local ok=pcall(function()
if type(workspace.Raycast)=="function" then
local orig=hookfunction(workspace.Raycast,function(o,d,...)
if cfg.cb.sa then d=redir(o,d) end
return orig(o,d,...)
end)
table.insert(hookedList,"Raycast")
end
if type(workspace.FindPartOnRay)=="function" then
local orig2=hookfunction(workspace.FindPartOnRay,function(ray,...)
if cfg.cb.sa then
if type(ray)=="userdata" then
ray=Ray.new(ray.Origin,redir(ray.Origin,ray.Direction))
end
end
return orig2(ray,...)
end)
table.insert(hookedList,"FindPartOnRay")
end
end)
return ok
end
local function rrh()
pcall(function()
if type(restorefunction)=="function" then
for _,n in ipairs(hookedList) do restorefunction(workspace[n]) end
end
end)
hookedList={}
end
local kc=nil
local ik=false
local function ck()
if kc then pcall(function() kc:Disconnect() end) kc=nil end
end
local function sk()
ck()
local c=gc()
if not c then return end
local k=nil
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
if t.Name:lower():find("knife") then k=t break end
end
end
if not k then return end
kc=k.Activated:Connect(function()
if not cfg.cb.sa then return end
if ik then return end
ik=true
local r=gr()
if r then
local tg={}
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
if p.Character then
if p.Character:FindFirstChild("HumanoidRootPart") then
local h=fbc(p.Character,"Humanoid")
if h then
if h.Health>0 then table.insert(tg,p) end
end
end
end
end
end
if #tg>0 then
local t=tg[math.random(1,#tg)]
local tr=t.Character:FindFirstChild("HumanoidRootPart")
local oc=r.CFrame
sf(function() r.CFrame=tr.CFrame*CFrame.new(0,0,2) end)
wait(0.05)
sf(function() k:Activate() end)
wait(0.1)
sf(function() r.CFrame=oc end)
end
end
ik=false
end)
end
local function ssa(o)
if o then
local a=isa()
local b=irh()
sk()
if not a and not b then
pcall(function()
sgui:SetCore("SendNotification",{Title="X-SCRIPT",Text="Silent Aim no soportado",Duration=4})
end)
end
return a or b
else
rsaM()
rrh()
ck()
at=nil
return true
end
end
local function doFling(tr)
local r=gr()
if not r then return end
local oc=r.CFrame
pcall(function() r.CFrame=tr.CFrame end)
r.CanCollide=true
local m=0.1
local t0=tick()
pcall(function()
while tick()-t0<0.3 do
rs.Heartbeat:Wait()
local v=r.Velocity
r.Velocity=v*10000+Vector3.new(0,10000,0)
rs.RenderStepped:Wait()
r.Velocity=v
rs.Stepped:Wait()
r.Velocity=v+Vector3.new(0,m,0)
m=-m
end
end)
pcall(function() r.Velocity=Vector3.new(0,0,0) end)
pcall(function() r.CFrame=oc end)
end
local function ft()
if not cfg.cb.fk then return end
if not ra() then return end
local k=gk()
if not k then return end
local kr=nil
if k.Character then kr=k.Character:FindFirstChild("HumanoidRootPart") end
if not kr then return end
local r=gr()
if not r then return end
if (kr.Position-r.Position).Magnitude<8 then
doFling(kr)
end
end
local function kt()
local r=gr()
local c=gc()
if not r then return end
if not c then return end
local k=nil
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
if t.Name:lower():find("knife") then k=t end
end
end
if not k then return end
local oc=r.CFrame
for _,p in ipairs(ps:GetPlayers()) do
if not cfg.cb.ka then break end
if p~=lp then
if p.Character then
local tr=p.Character:FindFirstChild("HumanoidRootPart")
local th=fbc(p.Character,"Humanoid")
if tr then
if th then
if th.Health>0 then
sf(function() r.CFrame=tr.CFrame*CFrame.new(0,0,2) end)
sf(function() k:Activate() end)
wait(0.01)
end
end
end
end
end
end
sf(function() r.CFrame=oc end)
end
local fn={"coin"}
local wn={"gun","revolver","pistol"}
local function mn(n,l)
for _,w in ipairs(l) do
if n:find(w) then return true end
end
return false
end
local function iip(o)
for _,p in ipairs(ps:GetPlayers()) do
local c=p.Character
if c then
if o:IsDescendantOf(c) then return true end
end
local b=p:FindFirstChild("Backpack")
if b then
if o:IsDescendantOf(b) then return true end
end
end
return false
end
local function gip(o)
if o:IsA("BasePart") then return o end
if o:IsA("Model") then return fbc(o,"BasePart") end
if o:IsA("Tool") then return o:FindFirstChild("Handle") end
return nil
end
local coinTarget=nil
local coinTimer=0
local coinNoclip=false
local function cm()
if not alive then return end
local r=gr()
local h=gh()
if not r or not h then return end
if not cfg.fm.cn then
if coinNoclip then
r.CanCollide=true
coinNoclip=false
end
coinTarget=nil
return
end
r.CanCollide=false
coinNoclip=true
if tick()-coinTimer>0.3 then
coinTimer=tick()
coinTarget=nil
local bd=math.huge
for _,o in ipairs(workspace:GetDescendants()) do
local n=o.Name:lower()
if mn(n,fn) then
if not iip(o) then
local p=gip(o)
if p then
local d=(p.Position-r.Position).Magnitude
if d<bd then bd=d coinTarget=p end
end
end
end
end
end
if coinTarget then
local tp=Vector3.new(coinTarget.Position.X, coinTarget.Position.Y-2, coinTarget.Position.Z)
local d=tp-r.Position
if d.Magnitude>1 then
r.CFrame=r.CFrame+d.Unit*math.min(d.Magnitude,2.5)
end
end
end
local wc=nil
local function pw(p)
local r=gr()
if not r then return false end
local oc=r.CFrame
sf(function() r.CFrame=p.CFrame end)
wait(0.2)
sf(function() r.CFrame=oc end)
return true
end
local function ws()
local r=gr()
local h=gh()
if not r then return end
if not h then return end
if h.Health<=0 then return end
local pk=false
local gd=workspace:FindFirstChild("GunDrop",true)
if gd then
if not iip(gd) then
local p=gip(gd)
if not p then p=gd end
pk=pw(p)
end
else
for _,o in ipairs(workspace:GetDescendants()) do
if not cfg.fm.wp then return end
local n=o.Name:lower()
if mn(n,wn) then
if not iip(o) then
local p=gip(o)
if p then pk=pw(p) break end
end
end
end
end
if pk then
cfg.fm.wp=false
if wc then pcall(function() wc.SetState(false) end) end
end
end
local function ft2()
if cfg.fm.wp then pcall(ws) end
end
rs.RenderStepped:Connect(function()
if not alive then return end
pcall(function() hf() hs() sm() cm() end)
end)
rs.Stepped:Connect(function()
if not alive then return end
pcall(hn)
end)
local function lp(iv,k,f)
local co=coroutine.create(function()
while alive do
wait(iv)
pcall(f)
end
end)
coroutine.resume(co)
end
lp(0.25,"esp",ue)
lp(0.6,"wp",ft2)
lp(0.05,"ka",function() if cfg.cb.ka then kt() end end)
lp(0.3,"fk",ft)
lp(0.1,"ac",ra2)
local function mk(cl,pr,pa)
local i=Instance.new(cl)
for k,v in pairs(pr) do i[k]=v end
if pa then i.Parent=pa end
return i
end
local vp=cam.ViewportSize
local W=vp.X*0.52
if W<300 then W=300 end
if W>520 then W=520 end
local H=vp.Y*0.62
if H<230 then H=230 end
if H>400 then H=400 end
local ui=mk("ScreenGui",{Name="XScript",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},cg)
local mn=mk("Frame",{
Size=UDim2.fromOffset(W,H),
Position=UDim2.new(0.5,-W/2,0.5,-H/2),
BackgroundColor3=th.Bg,
BorderSizePixel=0,
ClipsDescendants=true,
Active=true,
Draggable=true
},ui)
mk("UICorner",{CornerRadius=UDim.new(0,10)},mn)
pcall(function() mk("UIStroke",{Color=th.St,Thickness=1},mn) end)
local tb=mk("Frame",{Size=UDim2.new(1,0,0,36),BackgroundColor3=th.Pn,BorderSizePixel=0},mn)
mk("UICorner",{CornerRadius=UDim.new(0,10)},tb)
mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=th.Pn,BorderSizePixel=0},tb)
local ib=mk("Frame",{Size=UDim2.new(0,26,0,26),Position=UDim2.new(0,6,0.5,-13),BackgroundColor3=th.Pl,BorderSizePixel=0},tb)
mk("UICorner",{CornerRadius=UDim.new(0,6)},ib)
pcall(function()
local i=Instance.new("ImageLabel")
i.Size=UDim2.new(1,0,1,0)
i.BackgroundTransparency=1
i.Image="rbxassetid://"..tostring(logo)
i.ScaleType=Enum.ScaleType.Stretch
i.Parent=ib
end)
mk("TextLabel",{
Size=UDim2.new(1,-140,1,0),
Position=UDim2.new(0,38,0,0),
BackgroundTransparency=1,
Text="X-SCRIPT",
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=15,
TextXAlignment=Enum.TextXAlignment.Left
},tb)
local function tbtn(t,xo,bg)
local b=mk("TextButton",{
Size=UDim2.new(0,32,0,26),
Position=UDim2.new(1,xo,0,5),
BackgroundColor3=bg,
Text=t,
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=14,
BorderSizePixel=0
},tb)
mk("UICorner",{CornerRadius=UDim.new(0,6)},b)
return b
end
local mb=tbtn("-", -70, th.Pl)
local cb=tbtn("X", -36, th.Ad)
local cf=mk("Frame",{
Size=UDim2.fromOffset(260,110),
Position=UDim2.new(0.5,-130,0.5,-55),
BackgroundColor3=th.Pn,
BorderSizePixel=0,
Visible=false,
ZIndex=10
},ui)
mk("UICorner",{CornerRadius=UDim.new(0,10)},cf)
pcall(function() mk("UIStroke",{Color=th.St,Thickness=1},cf) end)
mk("TextLabel",{
Size=UDim2.new(1,-20,0,40),
Position=UDim2.new(0,10,0,8),
BackgroundTransparency=1,
Text="Are you sure you want to destroy the UI?",
TextColor3=th.Tx,
Font=Enum.Font.GothamBold,
TextSize=13,
TextWrapped=true,
ZIndex=11
},cf)
local yb=mk("TextButton",{
Size=UDim2.new(0.44,0,0,32),
Position=UDim2.new(0.06,0,1,-40),
BackgroundColor3=th.Ac,
Text="Yes",
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=14,
ZIndex=11
},cf)
mk("UICorner",{CornerRadius=UDim.new(0,7)},yb)
local nb=mk("TextButton",{
Size=UDim2.new(0.44,0,0,32),
Position=UDim2.new(0.5,0,1,-40),
BackgroundColor3=th.Pl,
Text="No",
TextColor3=th.Tx,
Font=Enum.Font.GothamBold,
TextSize=14,
ZIndex=11
},cf)
mk("UICorner",{CornerRadius=UDim.new(0,7)},nb)
local ig=nil
local ib2=nil
local function si()
if ig then ig.Enabled=true return end
ig=mk("ScreenGui",{Name="XScript_Icon",ResetOnSpawn=false},cg)
ib2=mk("TextButton",{
Size=UDim2.fromOffset(50,50),
Position=UDim2.new(0,10,0.5,-25),
BackgroundColor3=th.Pl,
Text="",
BorderSizePixel=0,
AutoButtonColor=false,
Active=true,
Draggable=true
},ig)
mk("UICorner",{CornerRadius=UDim.new(0,10)},ib2)
pcall(function()
local i=Instance.new("ImageLabel")
i.Size=UDim2.new(1,0,1,0)
i.BackgroundTransparency=1
i.Image="rbxassetid://"..tostring(logo)
i.ScaleType=Enum.ScaleType.Stretch
i.Parent=ib2
end)
ib2.MouseButton1Click:Connect(function()
mn.Visible=true
ig.Enabled=false
end)
end
mb.MouseButton1Click:Connect(function()
mn.Visible=false
si()
end)
cb.MouseButton1Click:Connect(function()
cf.Visible=true
end)
nb.MouseButton1Click:Connect(function()
cf.Visible=false
end)
yb.MouseButton1Click:Connect(function()
alive=false
pcall(function() ui:Destroy() end)
pcall(function() if ig then ig:Destroy() end end)
pcall(function() es:Destroy() end)
pcall(function() fp:Destroy() end)
end)
local ts2=mk("ScrollingFrame",{Size=UDim2.new(1,-8,0,32),Position=UDim2.new(0,4,0,40),BackgroundTransparency=1,ScrollBarThickness=0,BorderSizePixel=0},mn)
local sl=mk("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},ts2)
sl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
ts2.CanvasSize=UDim2.new(0,sl.AbsoluteContentSize.X+8,0,0)
end)
local ph=mk("Frame",{Size=UDim2.new(1,-8,1,-78),Position=UDim2.new(0,4,0,74),BackgroundTransparency=1,ClipsDescendants=true},mn)
local fp=mk("ScreenGui",{Name="XScript_FlyPad",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},cg)
fp.Enabled=false
local function pb(f,t,px,py)
local b=mk("TextButton",{
Size=UDim2.new(0,52,0,52),
Position=UDim2.new(1,px,1,py),
BackgroundColor3=th.Pn,
Text=t,
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=14,
BorderSizePixel=0
},fp)
mk("UICorner",{CornerRadius=UDim.new(0,10)},b)
pcall(function() mk("UIStroke",{Color=th.St,Thickness=1},b) end)
b.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.Touch then fi[f]=true end
if i.UserInputType==Enum.UserInputType.MouseButton1 then fi[f]=true end
end)
b.InputEnded:Connect(function() fi[f]=false end)
return b
end
pb("F","W",-120,-210)
pb("L","A",-180,-150)
pb("B","S",-120,-90)
pb("R","D",-60,-150)
pb("U","U",-260,-210)
pb("D","D",-260,-90)
local tabs={}
local function ct(n,ht)
local btn=mk("TextButton",{Size=UDim2.new(0,70,1,0),BackgroundColor3=th.Pn,Text=n,TextColor3=th.Td,Font=Enum.Font.GothamBold,TextSize=13,BorderSizePixel=0},ts2)
mk("UICorner",{CornerRadius=UDim.new(0,6)},btn)
local ct=mk("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,ClipsDescendants=true},ph)
local hd=mk("Frame",{Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,0),BackgroundColor3=th.Pl,BorderSizePixel=0},ct)
mk("UICorner",{CornerRadius=UDim.new(0,6)},hd)
mk("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text=ht,TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},hd)
local pg=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,-28),Position=UDim2.new(0,0,0,28),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=th.Ac,BorderSizePixel=0},ct)
local ly=mk("UIListLayout",{Padding=UDim.new(0,5)},pg)
mk("UIPadding",{PaddingTop=UDim.new(0,2),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,4)},pg)
ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
pg.CanvasSize=UDim2.new(0,0,0,ly.AbsoluteContentSize.Y+6)
end)
local tb={Button=btn,Container=ct}
table.insert(tabs,tb)
local function st()
for _,t in ipairs(tabs) do
t.Container.Visible=false
t.Button.BackgroundColor3=th.Pn
t.Button.TextColor3=th.Td
end
ct.Visible=true
btn.BackgroundColor3=th.Ac
btn.TextColor3=th.Kn
end
btn.MouseButton1Click:Connect(st)
if #tabs==1 then st() end
return pg
end
local function at2(pg,t,d,cb)
local r=mk("Frame",{Size=UDim2.new(1,-4,0,36),BackgroundColor3=th.Pn,BorderSizePixel=0},pg)
mk("UICorner",{CornerRadius=UDim.new(0,7)},r)
local l=mk("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=t,TextColor3=th.Tx,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},r)
local tc=th.Pl
if d then tc=th.Ac end
local tr=mk("Frame",{Size=UDim2.new(0,42,0,22),Position=UDim2.new(1,-50,0.5,-11),BackgroundColor3=tc,BorderSizePixel=0},r)
mk("UICorner",{CornerRadius=UDim.new(1,0)},tr)
local kn=mk("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=th.Kn,BorderSizePixel=0},tr)
if d then kn.Position=UDim2.new(1,-19,0.5,-8) end
mk("UICorner",{CornerRadius=UDim.new(1,0)},kn)
local st=d
local h=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},r)
local ct={}
function ct.SetText(t) l.Text=t end
function ct.SetState(s)
if st==s then return end
st=s
local sc=th.Pl
if st then sc=th.Ac end
tr.BackgroundColor3=sc
if st then
kn.Position=UDim2.new(1,-19,0.5,-8)
else
kn.Position=UDim2.new(0,3,0.5,-8)
end
if cb then cb(st) end
end
h.MouseButton1Click:Connect(function() ct.SetState(not st) end)
return ct
end
local function as(pg,t,mi,mx,d,cb)
local r=mk("Frame",{Size=UDim2.new(1,-4,0,42),BackgroundColor3=th.Pn,BorderSizePixel=0},pg)
mk("UICorner",{CornerRadius=UDim.new(0,7)},r)
mk("TextLabel",{Size=UDim2.new(0.55,0,0,18),Position=UDim2.new(0,10,0,4),BackgroundTransparency=1,Text=t,TextColor3=th.Tx,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},r)
local vl=mk("TextLabel",{Size=UDim2.new(0.45,-10,0,18),Position=UDim2.new(0.55,0,0,4),BackgroundTransparency=1,Text=tostring(d),TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right},r)
local br=mk("Frame",{Position=UDim2.new(0,10,0,27),Size=UDim2.new(1,-20,0,8),BackgroundColor3=th.Pl,BorderSizePixel=0},r)
mk("UICorner",{CornerRadius=UDim.new(1,0)},br)
local rng=mx-mi
local rat=0
if rng>0 then rat=(d-mi)/rng end
local fl=mk("Frame",{Size=UDim2.new(rat,0,1,0),BackgroundColor3=th.Ac,BorderSizePixel=0},br)
mk("UICorner",{CornerRadius=UDim.new(1,0)},fl)
local dg=false
local function sfx(x)
local rl=(x-br.AbsolutePosition.X)/br.AbsoluteSize.X
if rl<0 then rl=0 end
if rl>1 then rl=1 end
local v=math.floor(mi+(mx-mi)*rl+0.5)
fl.Size=UDim2.new(rl,0,1,0)
vl.Text=tostring(v)
if cb then cb(v) end
end
br.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=true sfx(i.Position.X) end
if i.UserInputType==Enum.UserInputType.Touch then dg=true sfx(i.Position.X) end
end)
br.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false end
if i.UserInputType==Enum.UserInputType.Touch then dg=false end
end)
uis.InputChanged:Connect(function(i)
if dg then
if i.UserInputType==Enum.UserInputType.MouseMovement then sfx(i.Position.X) end
if i.UserInputType==Enum.UserInputType.Touch then sfx(i.Position.X) end
end
end)
end
local cp=ct("Combat","COMBAT")
local ep=ct("ESP","ESP")
local fp2=ct("Farm","COLLECT")
local mp=ct("Move","MOVEMENT")
local flp=ct("Fling","FLING USER")
local ip=ct("Info","INFO")
at2(cp,"Silent Aim",false,function(v)
cfg.cb.sa=v
ssa(v)
end)
at2(cp,"Kill All",false,function(v) cfg.cb.ka=v end)
at2(cp,"Fling Killer",false,function(v) cfg.cb.fk=v end)
at2(cp,"Auto Dodge",false,function(v) cfg.cb.ad=v end)
at2(ep,"Enable ESP",false,function(v) cfg.es.On=v end)
at2(ep,"Show Murderer",true,function(v) cfg.es.M=v end)
at2(ep,"Show Sheriff",true,function(v) cfg.es.S=v end)
at2(ep,"Show Innocents",false,function(v) cfg.es.I=v end)
at2(ep,"Show Distance",true,function(v) cfg.es.D=v end)
at2(fp2,"Collect Coins",false,function(v) cfg.fm.cn=v end)
wc=at2(fp2,"Collect Weapons",false,function(v) cfg.fm.wp=v end)
at2(mp,"Fly",false,function(v)
cfg.mv.fly=v
if not v then for k in pairs(fi) do fi[k]=false end end
if v then
if uis.TouchEnabled then fp.Enabled=true end
else
fp.Enabled=false
end
end)
at2(mp,"Noclip",false,function(v) cfg.mv.nc=v end)
at2(mp,"Speed",false,function(v) cfg.mv.spd=v end)
as(mp,"Speed Value",16,120,60,function(v) cfg.mv.sv=v end)
as(mp,"Fly Speed",20,200,60,function(v) cfg.mv.fs=v end)
at2(mp,"Infinite Jump",false,function(v) cfg.mv.ij=v end)
local ub=mk("TextButton",{
Size=UDim2.new(1,-4,0,36),
BackgroundColor3=th.Ad,
Text="Unbug",
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=13,
BorderSizePixel=0
},mp)
mk("UICorner",{CornerRadius=UDim.new(0,7)},ub)
ub.MouseButton1Click:Connect(function()
local r=gr()
if r then
r.Velocity=Vector3.new(0,0,0)
pcall(function() r.CFrame=CFrame.new(0,50,0) end)
end
end)
local flist=mk("ScrollingFrame",{
Size=UDim2.new(1,-4,1,-40),
Position=UDim2.new(0,2,0,38),
BackgroundTransparency=1,
ScrollBarThickness=3,
ScrollBarImageColor3=th.Ac,
BorderSizePixel=0
},flp)
mk("UIListLayout",{Padding=UDim.new(0,5)},flist)
local function bfl()
for _,ch in ipairs(flist:GetChildren()) do
if ch:IsA("TextButton") then ch:Destroy() end
end
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
local row=mk("TextButton",{
Size=UDim2.new(1,-4,0,40),
BackgroundColor3=th.Pn,
Text="",
BorderSizePixel=0
},flist)
mk("UICorner",{CornerRadius=UDim.new(0,7)},row)
local av=mk("ImageLabel",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(0,4,0.5,-16),
BackgroundTransparency=1
},row)
mk("UICorner",{CornerRadius=UDim.new(0,6)},av)
pcall(function()
av.Image="rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=48&h=48"
end)
mk("TextLabel",{
Size=UDim2.new(1,-44,1,0),
Position=UDim2.new(0,40,0,0),
BackgroundTransparency=1,
Text=p.Name,
TextColor3=th.Tx,
Font=Enum.Font.Gotham,
TextSize=13,
TextXAlignment=Enum.TextXAlignment.Left
},row)
row.MouseButton1Click:Connect(function()
local tr=nil
if p.Character then tr=p.Character:FindFirstChild("HumanoidRootPart") end
if tr then doFling(tr) end
end)
end
end
end
local rb=mk("TextButton",{
Size=UDim2.new(1,-4,0,32),
BackgroundColor3=th.Ac,
Text="Refresh List",
TextColor3=th.Kn,
Font=Enum.Font.GothamBold,
TextSize=13,
BorderSizePixel=0
},flp)
mk("UICorner",{CornerRadius=UDim.new(0,7)},rb)
rb.MouseButton1Click:Connect(bfl)
bfl()
local function ab(pg,t,cb)
local b=mk("TextButton",{Size=UDim2.new(1,-4,0,36),BackgroundColor3=th.Ac,Text=t,TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=13,BorderSizePixel=0},pg)
mk("UICorner",{CornerRadius=UDim.new(0,7)},b)
b.MouseButton1Click:Connect(cb)
return b
end
ab(ip,"Discord Server",function()
pcall(function()
if setclipboard then setclipboard("https://discord.gg/rTdZxp9Djf") end
sgui:SetCore("SendNotification",{Title="X-SCRIPT",Text="Link cop