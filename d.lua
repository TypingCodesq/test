if not game:IsLoaded() then game.Loaded:Wait() end
local ps=game:GetService("Players")
local rs=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local cg=game:GetService("CoreGui")
local sgui=game:GetService("StarterGui")
local lp=ps.LocalPlayer
local cam=workspace.CurrentCamera
local ms=lp:GetMouse()
local wt=(task and task.wait) or wait
local sp=(task and task.spawn) or spawn
local logo=134441968486950
local alive=true
pcall(function()
for _,n in ipairs({"XScript","XScript_ESP","XScript_FlyPad","XScript_Icon"}) do
local o=cg:FindFirstChild(n)
if o then o:Destroy() end
end
end)
local th={Bg=Color3.fromRGB(9,10,16),Pn=Color3.fromRGB(16,18,30),Pl=Color3.fromRGB(24,27,44),Ac=Color3.fromRGB(88,101,242),Ad=Color3.fromRGB(58,68,170),St=Color3.fromRGB(70,86,200),Tx=Color3.fromRGB(178,188,235),Td=Color3.fromRGB(126,136,190),Kn=Color3.fromRGB(147,160,255)}
local cfg={
es={On=false,M=true,S=true,I=false,D=true},
cb={sa=false,ka=false,fk=false,ad=true},
mv={fly=false,fs=60,nc=false,spd=false,sv=32,ij=false},
fm={cn=false,wp=false}
}
local fi={F=false,B=false,L=false,R=false,U=false,D=false}
local wrn={}
local function once(k,e)
if not wrn[k] then wrn[k]=true warn("[X-SCRIPT] "..k..": "..tostring(e)) end
end
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
return c and c:FindFirstChild("HumanoidRootPart")
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
if n=="gun" or n=="revolver" then return "Sheriff" end
end
end
end
return "Innocent"
end
local function roundActive()
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp and grl(p)=="Murderer" then return true end
end
return false
end
local function getKiller()
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp and grl(p)=="Murderer" then return p end
end
return nil
end
local lastDodge=0
local function safeMode()
if not alive then return end
local r=gr()
local h=gh()
if not r or not h then return end
if r.Position.Y<-200 then pcall(function() r.CFrame=CFrame.new(0,50,0) end) end
if not cfg.cb.ad then return end
if not roundActive() then return end
if tick()-lastDodge<0.4 then return end
local killer=getKiller()
if not killer then return end
local kr=killer.Character and killer.Character:FindFirstChild("HumanoidRootPart")
if not kr then return end
local dist=(kr.Position-r.Position).Magnitude
if dist<7 then
local kc=killer.Character
if kc then
for _,t in ipairs(kc:GetChildren()) do
if t:IsA("Tool") and t.Name:lower():find("knife") then
local tp=(r.Position-kr.Position).Unit
local perp=Vector3.new(-tp.Z,0,tp.X)
pcall(function() r.CFrame=r.CFrame+perp*6 lastDodge=tick() end)
return
end
end
end
end
if dist<60 then
local kh=killer.Character and killer.Character:FindFirstChild("Head")
if kh then
local toP=(r.Position-kh.Position).Unit
local dot=toP:Dot(kh.CFrame.LookVector)
if dot>0.9 then
local perp=Vector3.new(-toP.Z,0,toP.X)
pcall(function() r.CFrame=r.CFrame+perp*4 lastDodge=tick() end)
end
end
end
end
local es=Instance.new("ScreenGui")
es.Name="XScript_ESP"
es.ResetOnSpawn=false
es.Parent=cg
local ec={}
local rc={Murderer=Color3.fromRGB(255,60,60),Sheriff=Color3.fromRGB(60,150,255),Innocent=Color3.fromRGB(120,255,120)}
local function ce(p)
local c={H=nil,B=nil,L=nil}
pcall(function()
local h=Instance.new("Highlight")
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.FillTransparency=0.6
h.OutlineTransparency=0
h.Enabled=false
h.Parent=es
c.H=h
end)
pcall(function()
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
pcall(function() c.H:Destroy() end)
pcall(function() c.B:Destroy() end)
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
local hd=ch and ch:FindFirstChild("Head")
local rt=ch and ch:FindFirstChild("HumanoidRootPart")
local al=cfg.es.On and ch and hd and rt and hm and hm.Health>0
if al then
local r=grl(p)
local sh=false
if r=="Murderer" and cfg.es.M then sh=true end
if r=="Sheriff" and cfg.es.S then sh=true end
if r=="Innocent" and cfg.es.I then sh=true end
local co=rc[r] or Color3.new(1,1,1)
if c.H then c.H.Adornee=ch c.H.FillColor=co c.H.OutlineColor=co c.H.Enabled=sh end
if c.B then
c.B.Adornee=hd
c.B.Enabled=sh
if sh and c.L then
local t=r
if cfg.es.D then
local mr=gr()
if mr then t=t.." ["..tostring(math.floor((rt.Position-mr.Position).Magnitude)).."]" end
end
c.L.Text=t
c.L.TextColor3=co
end
end
else
if c.H then c.H.Enabled=false end
if c.B then c.B.Enabled=false end
end
end
end
end
local function fk(f,k) return fi[f] or uis:IsKeyDown(k) end
local function hf()
if not alive then return end
local r=gr()
if not r then return end
if cfg.mv.fly then
local a=r:FindFirstChild("XS_FA")
if not a then a=Instance.new("Attachment") a.Name="XS_FA" a.Parent=r end
local l=r:FindFirstChild("XS_FL")
if not l then
pcall(function()
l=Instance.new("LinearVelocity")
l.Name="XS_FL"
l.Attachment0=a
l.MaxForce=100000
l.RelativeTo=Enum.ActuatorRelativeTo.World
l.Parent=r
end)
end
if l then
local d=Vector3.new(0,0,0)
local cf=cam.CFrame
if fk("F",Enum.KeyCode.W) then d=d+cf.LookVector end
if fk("B",Enum.KeyCode.S) then d=d-cf.LookVector end
if fk("L",Enum.KeyCode.A) then d=d-cf.RightVector end
if fk("R",Enum.KeyCode.D) then d=d+cf.RightVector end
if fk("U",Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
if fk("D",Enum.KeyCode.LeftControl) then d=d-Vector3.new(0,1,0) end
if d.Magnitude>0 then d=d.Unit end
pcall(function() l.VectorVelocity=d*cfg.mv.fs end)
end
else
local a=r:FindFirstChild("XS_FA")
local l=r:FindFirstChild("XS_FL")
if a then a:Destroy() end
if l then l:Destroy() end
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
for p,v in pairs(ns) do pcall(function() if p.Parent then p.CanCollide=v end end) end
ns={}
end
end
end
local so=false
local function hs()
local h=gh()
if not h then return end
if cfg.mv.spd then h.WalkSpeed=cfg.mv.sv so=true
elseif so then h.WalkSpeed=16 so=false end
end
uis.JumpRequest:Connect(function()
if cfg.mv.ij then
local h=gh()
if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end
end)
local at=nil
local av=Vector3.new(0,0,0)
local function ra()
if not cfg.cb.sa then at=nil return end
local c=gc()
local hg=false
if c then
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n=t.Name:lower()
if n=="gun" or n=="revolver" then hg=true break end
end
end
end
if not hg then at=nil return end
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp and grl(p)=="Murderer" then
local ch=p.Character
if ch then
local rt=ch:FindFirstChild("HumanoidRootPart")
local bd=ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or rt or ch:FindFirstChild("Head")
if bd then
at=bd
if rt then
local ok,v=pcall(function() return rt.Velocity end)
if ok and typeof(v)=="Vector3" then av=v else av=Vector3.new(0,0,0) end
end
return
end
end
end
end
at=nil
end
local function aimPos()
local t=at
if not t or not t.Parent then return nil end
local base=t.Position
local r=gr()
if r then
local dist=(base-r.Position).Magnitude
local tt=math.min(0.15, dist/800)
return base+(av*tt)
end
return base+(av*0.08)
end
local function ad(o,t)
local d=t-o
if d.Magnitude<0.01 then return d end
return d.Unit*math.min(d.Magnitude+1,999)
end
local mh=false
local oi=nil
local function imh()
if type(getrawmetatable)~="function" or type(setreadonly)~="function" then return false end
local ok=pcall(function()
local mt=getrawmetatable(game)
if not mt or type(mt.__index)~="function" then error("no mt") end
oi=mt.__index
setreadonly(mt,false)
local hk=function(s,k)
if k=="Hit" or k=="Target" then
if s==ms then
local p=aimPos()
if p then
if k=="Hit" then return CFrame.new(p) else return at end
end
end
end
return oi(s,k)
end
if type(newcclosure)=="function" then mt.__index=newcclosure(hk) else mt.__index=hk end
setreadonly(mt,true)
mh=true
end)
return ok and mh
end
local function rmh()
if not mh then return end
pcall(function()
local mt=getrawmetatable(game)
setreadonly(mt,false)
mt.__index=oi
setreadonly(mt,true)
end)
mh=false
end
local ni=false
local on=nil
local function inh()
if type(hookmetamethod)~="function" or type(getnamecallmethod)~="function" then return false end
local ok=pcall(function()
on=hookmetamethod(game,"__namecall",function(s,...)
if cfg.cb.sa and s==workspace then
local t=at
if t and t.Parent then
local m=getnamecallmethod()
local p=aimPos() or (t.Position+(av*0.1))
if m=="Raycast" then
local a={...}
if typeof(a[1])=="Vector3" and typeof(a[2])=="Vector3" then
a[2]=ad(a[1],p)
return on(s,unpack(a))
end
elseif m=="FindPartOnRay" or m=="FindPartOnRayWithIgnoreList" or m=="FindPartOnRayWithWhitelist" then
local a={...}
if typeof(a[1])=="Ray" then
a[1]=Ray.new(a[1].Origin,ad(a[1].Origin,p))
return on(s,unpack(a))
end
end
end
end
return on(s,...)
end)
ni=true
end)
return ok and ni
end
local function rnh()
if not ni then return end
if type(restorefunction)=="function" then pcall(function() restorefunction(game,"__namecall") end) end
ni=false
end
local ri=false
local of={}
local function irh()
if type(hookfunction)~="function" then return false end
local ok=pcall(function()
local tg={"Raycast","FindPartOnRay","FindPartOnRayWithIgnoreList"}
for _,n in ipairs(tg) do
local f=workspace[n]
if type(f)=="function" then
of[n]=hookfunction(f,function(...)
if cfg.cb.sa then
local t=at
if t and t.Parent then
local p=aimPos() or (t.Position+(av*0.1))
local a={...}
if n=="Raycast" then
if typeof(a[1])=="Vector3" and typeof(a[2])=="Vector3" then
a[2]=ad(a[1],p)
return of[n](unpack(a))
end
else
if typeof(a[1])=="Ray" then
a[1]=Ray.new(a[1].Origin,ad(a[1].Origin,p))
return of[n](unpack(a))
end
end
end
end
end
return of[n](...)
end)
end
end
end
ri=true
end)
return ok and ri
end
local function rrh()
if not ri then return end
if type(restorefunction)=="function" then
pcall(function() for n,_ in pairs(of) do restorefunction(workspace[n]) end end)
end
of={}
ri=false
end
local knifeConn=nil
local inKnife=false
local function clearKnife()
if knifeConn then pcall(function() knifeConn:Disconnect() end) knifeConn=nil end
end
local function setupKnife()
clearKnife()
local c=gc()
if not c then return end
local knife=nil
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") and t.Name:lower():find("knife") then knife=t break end
end
if not knife then return end
knifeConn=knife.Activated:Connect(function()
if not cfg.cb.sa then return end
if inKnife then return end
inKnife=true
local r=gr()
if r then
local targets={}
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local h=fbc(p.Character,"Humanoid")
if h and h.Health>0 then table.insert(targets,p) end
end
end
if #targets>0 then
local t=targets[math.random(1,#targets)]
local tr=t.Character:FindFirstChild("HumanoidRootPart")
local origin=r.CFrame
pcall(function() r.CFrame=tr.CFrame*CFrame.new(0,0,2) end)
wt(0.05)
pcall(function() knife:Activate() end)
wt(0.1)
pcall(function() r.CFrame=origin end)
end
end
inKnife=false
end)
end
local function ssa(o)
if o then
local a=imh()
local b=inh()
local c=irh()
setupKnife()
return a or b or c
else
rmh();rnh();rrh();clearKnife();at=nil
return true
end
end
local function doFlingWelded(targetRoot)
local r=gr()
if not r then return end
local origin=r.CFrame
local parts={}
for i=1,8 do
local p=Instance.new("Part")
p.Size=Vector3.new(2,2,2)
p.Transparency=1
p.CanCollide=true
p.Anchored=false
p.Massless=true
p.Parent=workspace
local w=Instance.new("WeldConstraint")
w.Part0=r
w.Part1=p
w.Parent=p
p.CFrame=r.CFrame*CFrame.Angles(0,math.pi*2*i/8,0)*CFrame.new(0,0,3)
table.insert(parts,{p=p,w=w})
end
pcall(function() r.CFrame=targetRoot.CFrame end)
local t0=tick()
pcall(function()
while tick()-t0<0.6 do
rs.Heartbeat:Wait()
if not targetRoot.Parent then break end
local a=(tick()-t0)*80
r.CFrame=targetRoot.CFrame*CFrame.Angles(0,a,0)
r.Velocity=Vector3.new(math.random(-800,800),math.random(500,1500),math.random(-800,800))
end
end)
for _,pt in ipairs(parts) do pcall(function() pt.w:Destroy() pt.p:Destroy() end) end
pcall(function() r.Velocity=Vector3.new(0,0,0) end)
pcall(function() r.CFrame=origin end)
end
local function fkTick()
if not cfg.cb.fk then return end
if not roundActive() then return end
local r=gr()
if not r then return end
local killer=getKiller()
if not killer then return end
local kr=killer.Character and killer.Character:FindFirstChild("HumanoidRootPart")
if not kr then return end
if (kr.Position-r.Position).Magnitude<10 then doFlingWelded(kr) end
end
local function flingPlayer(p)
local tr=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if not tr then return end
doFlingWelded(tr)
end
local function kaTick()
local r=gr()
local c=gc()
if not r or not c then return end
local k=nil
for _,t in ipairs(c:GetChildren()) do
if t:IsA("Tool") and t.Name:lower():find("knife") then k=t end
end
if not k then return end
local o=r.CFrame
for _,p in ipairs(ps:GetPlayers()) do
if not cfg.cb.ka then break end
if p~=lp and p.Character then
local tr=p.Character:FindFirstChild("HumanoidRootPart")
local th=fbc(p.Character,"Humanoid")
if tr and th and th.Health>0 then
pcall(function() r.CFrame=tr.CFrame*CFrame.new(0,0,2) end)
pcall(function() k:Activate() end)
wt(0.01)
end
end
end
pcall(function() r.CFrame=o end)
end
local fn={"coin"}
local wn={"gun","revolver","pistol"}
local function mn(n,l)
for _,w in ipairs(l) do if n:find(w) then return true end end
return false
end
local function iip(o)
for _,p in ipairs(ps:GetPlayers()) do
local c=p.Character
if c and o:IsDescendantOf(c) then return true end
local b=p:FindFirstChild("Backpack")
if b and o:IsDescendantOf(b) then return true end
end
return false
end
local function gip(o)
if o:IsA("BasePart") then return o end
if o:IsA("Model") then return fbc(o,"BasePart") end
if o:IsA("Tool") then return o:FindFirstChild("Handle") end
return nil
end
local coinNoclip=false
local function cs()
local r=gr()
local h=gh()
if not h or (h and h.Health<=0) then return end
if not cfg.fm.cn then
if coinNoclip then
r.CanCollide=true
coinNoclip=false
end
return
end
r.CanCollide=false
coinNoclip=true
local best=nil
local bd=math.huge
for _,o in ipairs(workspace:GetDescendants()) do
local n=o.Name:lower()
if mn(n,fn) and not iip(o) then
local p=gip(o)
if p then
local d=(p.Position-r.Position).Magnitude
if d<bd then bd=d best=p end
end
end
end
if best then
local tp=Vector3.new(best.Position.X,best.Position.Y-2,best.Position.Z)
local d=tp-r.Position
if d.Magnitude>0.3 then
r.CFrame=r.CFrame+d.Unit*math.min(d.Magnitude,10)
end
end
end
local wc=nil
local function pw(p)
local r=gr()
if not r then return false end
local o=r.CFrame
pcall(function() r.CFrame=p.CFrame end)
wt(0.2)
pcall(function() r.CFrame=o end)
return true
end
local function ws()
local r=gr()
local h=gh()
if not r or not h or h.Health<=0 then return end
local pk=false
local gd=workspace:FindFirstChild("GunDrop",true)
if gd and not iip(gd) then
local p=gip(gd) or gd
pk=pw(p)
else
for _,o in ipairs(workspace:GetDescendants()) do
if not cfg.fm.wp then return end
local n=o.Name:lower()
if mn(n,wn) and not iip(o) then
local p=gip(o)
if p then pk=pw(p) break end
end
end
end
if pk then
cfg.fm.wp=false
if wc then pcall(function() wc.SetState(false) end) end
end
end
rs.RenderStepped:Connect(function()
if not alive then return end
pcall(function() hf() hs() safeMode() cs() end)
end)
rs.Stepped:Connect(function()
if not alive then return end
pcall(hn)
end)
local function lpp(iv,k,f)
sp(function()
while alive do
wt(iv)
pcall(f)
end
end)
end
lpp(0.25,"esp",ue)
lpp(0.6,"wp",function() if cfg.fm.wp then ws() end end)
lpp(0.05,"ka",function() if cfg.cb.ka then kaTick() end end)
lpp(0.3,"fk",fkTick)
lpp(0.1,"ac",ra)
local function mk(cl,pr,pa)
local i=Instance.new(cl)
for k,v in pairs(pr) do i[k]=v end
if pa then i.Parent=pa end
return i
end
local vp=cam.ViewportSize
local W=math.clamp(vp.X*0.52,300,520)
local H=math.clamp(vp.Y*0.62,230,400)
local ui=mk("ScreenGui",{Name="XScript",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},cg)
local mn=mk("Frame",{Size=UDim2.fromOffset(W,H),Position=UDim2.new(0.5,-W/2,0.5,-H/2),BackgroundColor3=th.Bg,BorderSizePixel=0,ClipsDescendants=true},ui)
mk("UICorner",{CornerRadius=UDim.new(0,10)},mn)
mk("UIStroke",{Color=th.St,Thickness=1},mn)
local tb=mk("Frame",{Size=UDim2.new(1,0,0,36),BackgroundColor3=th.Pn,BorderSizePixel=0},mn)
mk("UICorner",{CornerRadius=UDim.new(0,10)},tb)
mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=th.Pn,BorderSizePixel=0},tb)
local ib=mk("Frame",{Size=UDim2.new(0,26,0,26),Position=UDim2.new(0,6,0.5,-13),BackgroundColor3=th.Pl,BorderSizePixel=0},tb)
mk("UICorner",{CornerRadius=UDim.new(0,6)},ib)
local io=false
if logo~=0 then
io=pcall(function()
local i=Instance.new("ImageLabel")
i.Size=UDim2.new(1,0,1,0)
i.BackgroundTransparency=1
i.Image="rbxassetid://"..tostring(logo)
i.ScaleType=Enum.ScaleType.Stretch
i.Parent=ib
end)
end
if not io then mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="X",TextColor3=th.Ac,Font=Enum.Font.GothamBlack,TextSize=16},ib) end
mk("TextLabel",{Size=UDim2.new(1,-140,1,0),Position=UDim2.new(0,38,0,0),BackgroundTransparency=1,Text="X-SCRIPT",TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},tb)
local function tbtn(t,xo,bg)
local b=mk("TextButton",{Size=UDim2.new(0,32,0,26),Position=UDim2.new(1,xo,0,5),BackgroundColor3=bg,Text=t,TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=14,BorderSizePixel=0},tb)
mk("UICorner",{CornerRadius=UDim.new(0,6)},b)
return b
end
local mb=tbtn("-", -70, th.Pl)
local cb=tbtn("X", -36, th.Ad)
local iconGui=nil
local function createIcon()
if iconGui then return end
iconGui=mk("ScreenGui",{Name="XScript_Icon",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},cg)
local iconBtn=mk("TextButton",{Size=UDim2.fromOffset(50,50),Position=UDim2.new(0,10,0.5,-25),BackgroundColor3=th.Pl,Text="",AutoButtonColor=false,BorderSizePixel=0,Active=true,Draggable=true},iconGui)
mk("UICorner",{CornerRadius=UDim.new(0,10)},iconBtn)
mk("UIStroke",{Color=th.St,Thickness=2},iconBtn)
if logo~=0 then
pcall(function()
local img=Instance.new("ImageLabel")
img.Size=UDim2.new(1,0,1,0)
img.BackgroundTransparency=1
img.Image="rbxassetid://"..tostring(logo)
img.ScaleType=Enum.ScaleType.Stretch
img.Parent=iconBtn
end)
else
mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="X",TextColor3=th.Ac,Font=Enum.Font.GothamBlack,TextSize=28},iconBtn)
end
iconBtn.MouseButton1Click:Connect(function()
mn.Visible=true
iconGui.Enabled=false
iconGui=nil
end)
end
mb.MouseButton1Click:Connect(function()
mn.Visible=false
createIcon()
iconGui.Enabled=true
end)
cb.MouseButton1Click:Connect(function()
alive=false
pcall(function() ui:Destroy() end)
pcall(function() if iconGui then iconGui:Destroy() end end)
pcall(function() es:Destroy() end)
pcall(function() fp:Destroy() end)
end)
local di=nil
local doff=Vector2.new(0,0)
local function inb(p,o)
local a=o.AbsolutePosition
local s=o.AbsoluteSize
return p.X>=a.X and p.X<=a.X+s.X and p.Y>=a.Y and p.Y<=a.Y+s.Y
end
uis.InputBegan:Connect(function(i,pr)
if pr then return end
if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
if inb(i.Position,tb) and not inb(i.Position,cb) and not inb(i.Position,mb) then
di=i
doff=Vector2.new(i.Position.X-mn.AbsolutePosition.X,i.Position.Y-mn.AbsolutePosition.Y)
end
end
end)
uis.InputChanged:Connect(function(i)
if i==di then mn.Position=UDim2.fromOffset(i.Position.X-doff.X,i.Position.Y-doff.Y) end
end)
uis.InputEnded:Connect(function(i)
if i==di then di=nil end
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
local b=mk("TextButton",{Size=UDim2.new(0,52,0,52),Position=UDim2.new(1,px,1,py),BackgroundColor3=th.Pn,Text=t,TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=14,BorderSizePixel=0},fp)
mk("UICorner",{CornerRadius=UDim.new(0,10)},b)
mk("UIStroke",{Color=th.St,Thickness=1},b)
b.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then fi[f]=true end
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
local tr=mk("Frame",{Size=UDim2.new(0,42,0,22),Position=UDim2.new(1,-50,0.5,-11),BackgroundColor3=d and th.Ac or th.Pl,BorderSizePixel=0},r)
mk("UICorner",{CornerRadius=UDim.new(1,0)},tr)
local kn=mk("Frame",{Size=UDim2.new(0,16,0,16),Position=d and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),BackgroundColor3=th.Kn,BorderSizePixel=0},tr)
mk("UICorner",{CornerRadius=UDim.new(1,0)},kn)
local st=d
local h=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},r)
local ct={}
function ct.SetText(t) l.Text=t end
function ct.SetState(s)
if st==s then return end
st=s
tr.BackgroundColor3=st and th.Ac or th.Pl
kn.Position=st and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
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
local fl=mk("Frame",{Size=UDim2.new((d-mi)/(mx-mi),0,1,0),BackgroundColor3=th.Ac,BorderSizePixel=0},br)
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
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true sfx(i.Position.X) end
end)
br.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end
end)
uis.InputChanged:Connect(function(i)
if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then sfx(i.Position.X) end
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
if v then
local ok=ssa(true)
if not ok then
pcall(function() sgui:SetCore("SendNotification",{Title="X-SCRIPT",Text="Tu executor no soporta hooks",Duration=4}) end)
end
else
ssa(false)
end
end)
at2(cp,"Kill All",false,function(v) cfg.cb.ka=v end)
at2(cp,"Fling Killer",false,function(v) cfg.cb.fk=v end)
at2(cp,"Auto Dodge",true,function(v) cfg.cb.ad=v end)
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
fp.Enabled=v and uis.TouchEnabled
end)
at2(mp,"Noclip",false,function(v) cfg.mv.nc=v end)
at2(mp,"Speed",false,function(v) cfg.mv.spd=v end)
as(mp,"Speed Value",16,120,60,function(v) cfg.mv.sv=v end)
as(mp,"Fly Speed",20,200,60,function(v) cfg.mv.fs=v end)
at2(mp,"Infinite Jump",false,function(v) cfg.mv.ij=v end)
local flist=mk("ScrollingFrame",{Size=UDim2.new(1,-4,1,-40),Position=UDim2.new(0,2,0,38),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=th.Ac,BorderSizePixel=0},flp)
mk("UIListLayout",{Padding=UDim.new(0,5)},flist)
local function buildFlingList()
for _,ch in ipairs(flist:GetChildren()) do
if ch:IsA("TextButton") then ch:Destroy() end
end
for _,p in ipairs(ps:GetPlayers()) do
if p~=lp then
local row=mk("TextButton",{Size=UDim2.new(1,-4,0,40),BackgroundColor3=th.Pn,Text="",BorderSizePixel=0},flist)
mk("UICorner",{CornerRadius=UDim.new(0,7)},row)
local av=mk("ImageLabel",{Size=UDim2.new(0,32,0,32),Position=UDim2.new(0,4,0.5,-16),BackgroundTransparency=1},row)
mk("UICorner",{CornerRadius=UDim.new(0,6)},av)
pcall(function() av.Image="rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=48&h=48" end)
mk("TextLabel",{Size=UDim2.new(1,-44,1,0),Position=UDim2.new(0,40,0,0),BackgroundTransparency=1,Text=p.Name,TextColor3=th.Tx,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},row)
row.MouseButton1Click:Connect(function() flingPlayer(p) end)
end
end
end
local rbtn=mk("TextButton",{Size=UDim2.new(1,-4,0,32),BackgroundColor3=th.Ac,Text="Refresh List",TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=13,BorderSizePixel=0},flp)
mk("UICorner",{CornerRadius=UDim.new(0,7)},rbtn)
rbtn.MouseButton1Click:Connect(buildFlingList)
buildFlingList()
local function addButton(pg,text,callback)
local btn=mk("TextButton",{Size=UDim2.new(1,-4,0,36),BackgroundColor3=th.Ac,Text=text,TextColor3=th.Kn,Font=Enum.Font.GothamBold,TextSize=13,BorderSizePixel=0},pg)
mk("UICorner",{CornerRadius=UDim.new(0,7)},btn)
btn.MouseButton1Click:Connect(callback)
return btn
end
addButton(ip,"Discord Server",function()
if setclipboard then
setclipboard("https://discord.gg/rTdZxp9Djf")
pcall(function() sgui:SetCore("SendNotification",{Title="X-SCRIPT",Text="Link copiado al portapapeles",Duration=3}) end)
end
end)
mk("TextLabel",{Size=UDim2.new(1,-4,0,20),BackgroundTransparency=1,Text="Credits: X Hub Team",TextColor3=th.Tx,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},ip)