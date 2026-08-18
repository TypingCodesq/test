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
local function nearSelf(o)
local r=gr()
if not r then return false end
return (o-r.Position).Magnitude<25
end
local function wallParams()
local t=at
if not t or not t.Parent then return nil end
local char=t.Parent
local ok,rp=pcall(function()
local p=RaycastParams.new()
p.FilterType=Enum.RaycastFilterType.Whitelist
p.FilterDescendantsInstances={char}
return p
end)
if ok then return rp end
return nil
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
if type(newcclosure)=="function" then
mt.__index=newcclosure(hk)
else
mt.__index=hk
end
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
local p=aimPos()
if p then
local m=getnamecallmethod()
if m=="Raycast" then
local a={...}
if typeof(a[1])=="Vector3" and typeof(a[2])=="Vector3" then
if nearSelf(a[1]) then
a[2]=ad(a[1],p)
local wp=wallParams()
if wp then a[3]=wp end
end
return on(s,unpack(a))
end
elseif m=="FindPartOnRay" or m=="FindPartOnRayWithIgnoreList" or m=="FindPartOnRayWithWhitelist" then
local a={...}
if typeof(a[1])=="Ray" then
if nearSelf(a[1].Origin) then
a[1]=Ray.new(a[1].Origin,ad(a[1].Origin,p))
end
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
if type(restorefunction)=="function" then
pcall(function() restorefunction(game,"__namecall") end)
end
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
local p=aimPos()
if p then
local a={...}
if n=="Raycast" then
if typeof(a[1])=="Vector3" and typeof(a[2])=="Vector3" then
if nearSelf(a[1]) then
a[2]=ad(a[1],p)
local wp=wallParams()
if wp then a[3]=wp end
end
return of[n](unpack(a))
end
else
if typeof(a[1])=="Ray" then
if nearSelf(a[1].Origin) then
a[1]=Ray.new(a[1].Origin,ad(a[1].Origin,p))
end
return of[n](unpack(a))
end
end
end
end
return of[n](...)
end)
end
end
ri=true
end)
return ok and ri
end
local function rrh()
if not ri then return end
if type(restorefunction)=="function" then
pcall(function()
for n,_ in pairs(of) do restorefunction(workspace[n]) end
end)
end
of={}
ri=false
end