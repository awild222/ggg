local globalenv = getgenv and getgenv() or _G or shared
if globalenv and (globalenv.MDH_BB and not globalenv.MDH_DEBUG) then
	print("MDH BOOBIES IS ALREADY RUNNING")
	return
elseif globalenv then
	globalenv.MDH_BB = true
else
	print("GLOBAL ENVIRONMENTS FAILED (GETGENV / _G / SHARED)")
end

local HttpService = game:GetService("HttpService")
local function Load(Link, DebugName, ...)
	local Response = table.pack(pcall(loadstring(game:HttpGet(Link), DebugName), ...))
	if Response[1] == false then
	    if OnError then OnError() end
		(printconsole or print)(type(Response[2]) == "string" and Response[2] or HttpService:JSONEncode(Response))
	end
	table.remove(Response, 1)
	return table.unpack(Response)
end
local finder, globalcontainer =
	Load("https://raw.githubusercontent.com/lua-u/SomeHub/main/UniversalMethodFinder.luau", "UniversalMethodFinder")

finder({
	quetp = '(...):find("queue") and (...):find("tele") and not ((...):find("run") or (...):find("script"))',
	protgui = '(...):find("protect") and (...):find("gui") and not (...):find("un")',
})

if globalcontainer.quetp then
	local players = game:GetService("Players")
	local client = players.LocalPlayer
	while not client do
		players.ChildAdded:Wait()
		client = players.LocalPlayer
	end
	client.OnTeleport:Connect(function()
		-- if State == Enum.TeleportState.Started then
		globalcontainer.quetp(
			'loadstring(game:HttpGet("https://gist.githubusercontent.com/htt-py/92db22eeefad0042a6da9117501ad827/raw/BBies.luau"))()'
		)
		-- end
	end)
end
local DefaultSettings = {
	Breast = true,
	BreastPhysics = { Target = 5, Speed = 10, Damper = 0.2 },
	BreastSize = 2,
	Cheeks = true,
	CheeksPhysics = { Target = 3, Speed = 10, Damper = 0.1 },
	CheeksSize = 2,
	Collisions = false,
	ForceAllRigs = false,
	Only_Others = false,
	Simulate_Physics_On_LocalPlayer_Only = false,
}
local Settings = globalenv.BB_Settings or ...
if Settings then
	for key, value in next, DefaultSettings do
		if Settings[key] == nil then
			-- print(key)
			Settings[key] = value
		end
	end
else
	Settings = DefaultSettings
end
if not globalenv.BB_Settings then
	-- print("set")
	globalenv.BB_Settings = Settings
end
-- ForceAllRigs is basically forcing the changes on all humanoids that it finds

--[[
	Originally Created by:
	'With love and lust from "V" / Ukiyo'

	Re-written & Optimized by:
	Deuces
]]
local ScaleCalculators = {
	BreastScales = {
		BRST = { -- bust
			{ -- min
				Vector3.new(0, 0.026, 0),
				Vector3.new(0.93, 0.907, 0.904),
			},

			{ -- max
				Vector3.new(0, -0.1, 0),
				Vector3.new(1.356, 1.33, 1.327),
			},
		},
		BRSTVisual = { -- visual bust
			{ -- min
				Vector3.new(0, 0, 0),
				Vector3.new(0.877, 0.9, 0.819),
			},
			{ -- max
				Vector3.new(0, -0.1, -0.05),
				Vector3.new(1.166, 1.25, 1.23),
			},
		},
	},
	CheekScales = {
		{
			Vector3.new(0.83, 0.83, 0.9000000000000001),
			Vector3.new(1.2, 1.2, 1.269),
		},
		{
			Vector3.new(0.1, 0.2, 0),
			Vector3.new(0, 0, 0),
		},
	},
	BreastScaler = function(self, Torso, alpha)
		Torso.Part.Mesh.Scale = self.BreastScales.BRST[1][2]:Lerp(self.BreastScales.BRST[2][2], alpha)
		Torso.Part.Mesh.Offset = self.BreastScales.BRST[1][1]:Lerp(self.BreastScales.BRST[2][1], alpha)

		Torso.Part.BRSTVisual.Mesh.Scale =
			self.BreastScales.BRSTVisual[1][2]:Lerp(self.BreastScales.BRSTVisual[2][2], alpha)
		Torso.Part.BRSTVisual.Mesh.Offset =
			self.BreastScales.BRSTVisual[1][1]:Lerp(self.BreastScales.BRSTVisual[2][1], alpha)
	end,
	CheekScaler = function(self, Torso, alpha)
		Torso.Model.LeftCHK.Mesh.Scale = self.CheekScales[1][1]:Lerp(self.CheekScales[1][2], alpha)
		Torso.Model.LeftCHK.Mesh.Offset = self.CheekScales[2][1]:Lerp(self.CheekScales[2][2], alpha)

		Torso.Model.RightCHK.Mesh.Scale = self.CheekScales[1][1]:Lerp(self.CheekScales[1][2], alpha)
		Torso.Model.RightCHK.Mesh.Offset = self.CheekScales[2][1]:Lerp(self.CheekScales[2][2], alpha)
	end,
}
local Spring = Load(
	"https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Physics/Spring.lua",
	"Spring"
)
local FemaleRig = Load(
	"https://gist.githubusercontent.com/htt-py/9d7f2500ee984bda56a5d69b86654c29/raw/FemaleRig.luau",
	"FemaleRig",
	Settings.Collisions
)

local function RandomString()
	local randomarray = {}
	for i = 1, math.random(10, 20) do
		randomarray[i] = string.char(math.random(32, 126))
	end
	return table.concat(randomarray)
end
local function Protect(instance)
	instance.Name = RandomString()
	for _, desc in ipairs(instance:GetDescendants()) do -- not sure if its worth to protgui (it also works on instances not just guis)  every descendant as in documentation it says it protects "instance and all it's children" not descendants however, but I would assume it does. You could always add it below for extra security and execution-lag :) (Deuces)
		desc.Name = RandomString()
	end

	if globalcontainer.protgui and not (is_sirhurt_closure or (syn and DrawingImmediate)) then --sirhurt is retarded
		globalcontainer.protgui(instance)
	end
end

local function Weld(p0, p1)
	local weld = Instance.new("Weld")
	weld.Parent = p0

	weld.Part0 = p0
	weld.Part1 = p1
	weld.C0 = CFrame.new()
	weld.C1 = CFrame.new()
	return weld
end

local function DressUp(Model, NewModel)
	local Shirt, Pants = Model:FindFirstChildOfClass("Shirt"), Model:FindFirstChildOfClass("Pants")
	Shirt = Shirt and Shirt.ShirtTemplate
	Pants = Pants and Pants.PantsTemplate

	for _, desc in ipairs(NewModel:GetDescendants()) do
		if desc:IsA("Decal") then
			desc.Texture = (desc.Name == "Shirt" and Shirt or desc.Name == "Pants" and Pants or "")
		end
	end
end

local function ApplyRig(Model, R6)
	local NewModel = FemaleRig:Clone()
	local NewParts = {
		Torso = NewModel.T.Torso,
		RightLeg = NewModel.R["Right Leg"],
		LeftLeg = NewModel.L["Left Leg"],
	}
	local Parts = {}
	if R6 then
		Parts.Torso = "Torso"
		Parts.RightLeg = "Right Leg"
		Parts.LeftLeg = "Left Leg"
	else
		Parts.Torso = "UpperTorso"
		Parts.RightLeg = "RightUpperLeg"
		Parts.LeftLeg = "LeftUpperLeg"
	end
	Parts.Torso = Model:WaitForChild(Parts.Torso, math.huge)
	Parts.RightLeg = Model:WaitForChild(Parts.RightLeg, math.huge)
	Parts.LeftLeg = Model:WaitForChild(Parts.LeftLeg, math.huge)
	NewParts.Torso.Color = Parts.Torso.Color
	if Settings.Breast then
		if Settings.BreastSize then
			ScaleCalculators:BreastScaler(NewParts.Torso, Settings.BreastSize)
		end
		NewParts.Torso.Part.BRSTVisual.Color = Parts.Torso.Color
	else
		NewParts.Torso.Part:Destroy()
	end
	if Settings.Cheeks then
		if Settings.CheeksSize then
			ScaleCalculators:CheekScaler(NewParts.Torso, Settings.CheeksSize)
		end
		NewParts.Torso.Model.RightCHK.Color = Parts.RightLeg.Color
		NewParts.Torso.Model.LeftCHK.Color = Parts.LeftLeg.Color
	else
		NewParts.Torso.Model.RightCHK:Destroy()
		NewParts.Torso.Model.LeftCHK:Destroy()
	end
	if R6 then
		NewParts.RightLeg.Color = Parts.RightLeg.Color
		NewParts.LeftLeg.Color = Parts.LeftLeg.Color

		NewParts.RightLeg = NewModel.R
		NewParts.LeftLeg = NewModel.L
	else
		NewParts.RightLeg = nil
		NewParts.LeftLeg = nil
	end
	NewParts.Torso = NewModel.T
	DressUp(Model, NewModel)

	-- added stuff. (Ukiyo)
	Model.ChildAdded:Connect(function(child)
		if child:IsA("Clothing") then
			DressUp(Model, NewModel)
		end
	end)

	for name, part in next, NewParts do
		Weld(part, Parts[name])
		Parts[name].Transparency = 1
	end
	if Settings.Cheeks then
		NewParts.BJ = NewParts.Torso.Torso.BTJ.BJ
	end
	if Settings.Breast then
		NewParts.BJJ = NewParts.Torso.Torso.BUJ.BJJ
	end
	Protect(NewModel)
	NewModel.Parent = Model
	return NewParts
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end

local function JigglePhysics(NewParts) -- I've no idea what is happening here (Deuces)
	local Torso = NewParts.Torso
	local A, SJ, OGC0, OGC02, BTTSpring, BRSTSpring
	if NewParts.BJ then
		A = NewParts.BJ
		BTTSpring = Spring.new()
		BTTSpring.Target = Settings.CheeksPhysics.Target
		BTTSpring.Speed = Settings.CheeksPhysics.Speed
		BTTSpring.Damper = Settings.CheeksPhysics.Damper
		OGC02 = A.C0
	end
	if NewParts.BJJ then
		SJ = NewParts.BJJ
		BRSTSpring = Spring.new()
		BRSTSpring.Target = Settings.BreastPhysics.Target
		BRSTSpring.Speed = Settings.BreastPhysics.Speed
		BRSTSpring.Damper = Settings.BreastPhysics.Damper
		OGC0 = SJ.C0
	end
	local OGY = Torso.Position.Y

	RunService.Stepped:Connect(function(_, deltatime)
		task.spawn(function()
			if LocalPlayer and LocalPlayer.Character and workspace.CurrentCamera then
				local Camera = workspace.CurrentCamera
				local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if HRP and (HRP.Position - Camera.CFrame.Position).Magnitude < 50 then
					local CURRY = Torso.Position.Y
					local Calculated = OGY - CURRY
					OGY = CURRY
					if BRSTSpring then
						BRSTSpring:TimeSkip(deltatime)
						BRSTSpring:Impulse(Calculated)
					end
					if BTTSpring then
						BTTSpring:TimeSkip(deltatime)
						BTTSpring:Impulse(Calculated)
					end
					if SJ then
						SJ.C0 = OGC0
							* CFrame.new(0, -0.02 * (BRSTSpring.Velocity / 10), 0)
							* CFrame.Angles(-10 * math.rad(BRSTSpring.Velocity), 0, 0)
					end
					if A then
						A.C0 = OGC02
							* CFrame.new(0, -0.05 * (BTTSpring.Velocity / 10), 0)
							* CFrame.Angles(2 * math.rad(BTTSpring.Velocity), 0, 0)
					end
				end
			end
		end)
	end)
end

local function VerifyRigAndApply(instance, ApplyPhysics)
	if instance:IsA("Model") then
		local Player
		if Settings.Only_Others then
			Player = Players:GetPlayerFromCharacter(instance)
			if Player == LocalPlayer then
				return
			end
		end
		if ApplyPhysics == nil then
			ApplyPhysics = true
		end
		task.delay(30, task.cancel, coroutine.running()) -- time out the whole thing after 30 seconds (Deuces)
		local Humanoid
		repeat
			Humanoid = instance:FindFirstChildWhichIsA("Humanoid")
			if not Humanoid then
				task.wait()
			end
		until Humanoid

		if not Settings.ForceAllRigs and instance:FindFirstChild("CustomRig") then -- maybe use findfirstdescendant instead just to be sure? (Deuces)
			return
		end -- we dont need floating tiddies again (Ukiyo)
		local NewParts = ApplyRig(instance, Humanoid.RigType == Enum.HumanoidRigType.R6)

		if ApplyPhysics then
			if not (Settings.Breast or Settings.Cheeks) then
				return
			end
			if Settings.Simulate_Physics_On_LocalPlayer_Only then
				if not Player then
					Player = Players:GetPlayerFromCharacter(instance)
				end
				if not Player or Player ~= LocalPlayer then
					return
				end
			end
			JigglePhysics(NewParts)
		end
	end
end

while game.GameId == 0 do
	task.wait()
end

if game.GameId == 1359573625 then -- dw (Deuces)
	local LiveFolder = workspace:WaitForChild("Live", math.huge)
	LiveFolder.ChildAdded:Connect(VerifyRigAndApply)

	for _, child in ipairs(LiveFolder:GetChildren()) do
		task.spawn(VerifyRigAndApply, child)
	end

	local NPCFolder = workspace:WaitForChild("NPCs", math.huge)
	NPCFolder.ChildAdded:Connect(VerifyRigAndApply)

	for _, child in ipairs(NPCFolder:GetChildren()) do
		task.spawn(VerifyRigAndApply, child, false)
	end
else -- other games (Deuces)
	workspace.DescendantAdded:Connect(VerifyRigAndApply)

	for _, child in ipairs(workspace:GetDescendants()) do
		task.spawn(VerifyRigAndApply, child, false)
	end
end
