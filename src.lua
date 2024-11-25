--[[
	Credits:

	Sirius,
	Infinite Yield
]]
--Librarys and Services
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Places
local RagdollEngine = 11998821664

-- Variables
local FlyMode
local GameTab
local Speaker = game.Players.LocalPlayer
local Players = game.Players
local ListPlayers = {}
local PlayerToTeleport
local HipHeight = Speaker.Character.Humanoid.HipHeight
local ESPColor
local EspWhile = true
local ESPOnTop
local Highlight
local ESPTransparency
local speaker = Speaker
local localPlayer = Speaker
local Turn
local FlyHeartbeat

local function FlyToggle(FlyMode)
	FlyHeartbeat = RunService.Heartbeat:Connect(function()
		local character = localPlayer.Character
		local primaryPart = character and character.PrimaryPart
		if primaryPart then
			
			local bodyVelocity = primaryPart:FindFirstChild("FlyBodyVelocity") or Instance.new("BodyVelocity")
			bodyVelocity.Name = "FlyBodyVelocity"
			bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

			local bodyGyro = primaryPart:FindFirstChild("FlyBodyGyro") or Instance.new("BodyGyro")
			bodyGyro.Name = "FlyBodyGyro"
			bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			bodyGyro.P = 9e4

			local camCFrame = workspace.CurrentCamera.CFrame
			local velocity = Vector3.zero
			local rotation = camCFrame.Rotation

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				velocity += camCFrame.LookVector
				rotation *= CFrame.Angles(math.rad(-40), 0, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				velocity -= camCFrame.LookVector
				rotation *= CFrame.Angles(math.rad(40), 0, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				velocity += camCFrame.RightVector
				rotation *= CFrame.Angles(0, 0, math.rad(-40))
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				velocity -= camCFrame.RightVector
				rotation *= CFrame.Angles(0, 0, math.rad(40))
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				velocity += Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				velocity -= Vector3.new(0, 1, 0)
			end

			local tweenInfo = TweenInfo.new(0.5)
			TweenService:Create(bodyVelocity, tweenInfo, { Velocity = velocity * 45 }):Play()
			bodyVelocity.Parent = primaryPart
			
			TweenService:Create(bodyGyro, tweenInfo, { CFrame = rotation }):Play()
			bodyGyro.Parent = primaryPart
			if FlyMode == "Normal" then
				
				Speaker.Character.Humanoid.PlatformStand = true
			end
			if not Turn then
				task.wait()
				Speaker.Character.Humanoid.PlatformStand = false
				Speaker.Character.HumanoidRootPart.FlyBodyGyro:Destroy()
				Speaker.Character.HumanoidRootPart.FlyBodyVelocity:Destroy()
				FlyHeartbeat:Disconnect()
			end
		end
	end)
end
local function toggleExploit(enable)
    local genv = getgenv()

    if enable then
        genv.noclipEnabled = true
        genv.walkflinging = true

        local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                genv.walkflinging = false
            end)
        end

        repeat
            RunService.Heartbeat:Wait()

            local character = speaker.Character
            local root = character.HumanoidRootPart
            local vel, movel = nil, 0.1

            while not (character and character.Parent and root and root.Parent) do
                RunService.Heartbeat:Wait()
                character = speaker.Character
                root = getRoot(character)
            end

            vel = root.Velocity
            root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

            RunService.RenderStepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel
            end

            RunService.Stepped:Wait()
            if character and character.Parent and root and root.Parent then
                root.Velocity = vel + Vector3.new(0, movel, 0)
                movel = movel * -1
            end
        until not genv.walkflinging
    else
        genv.noclipEnabled = false
        genv.walkflinging = false
    end
end


local function ESP(Color, Transparency, OnTop, turn)
	for i = 1, #Players:GetChildren() do
		local TCharacter = Players:GetChildren()[i].Character
		if TCharacter then
			if turn == "Create" then
				if not TCharacter:FindFirstChild("Highlight") then
					Highlight = Instance.new("Highlight")
				else
					Highlight = Players:GetChildren()[i].Character:FindFirstChild("Highlight")
				end
				Highlight.Parent = Players:GetChildren()[i].Character
				Players:GetChildren()[i].Character:FindFirstChild("Highlight").Enabled = true

				Highlight.FillColor = Color
				Highlight.FillTransparency = Transparency
				Highlight.DepthMode = OnTop
			else
				if TCharacter:FindFirstChild("Highlight") then
					Players:GetChildren()[i].Character:FindFirstChild("Highlight").Enabled = false
				end
			end
		end
	end
end

local function RefreshPlayers()
	for i = 1, #Players:GetChildren() do
		table.insert(ListPlayers, game.Players:GetChildren()[i].Name)
	end
end

local Window = Rayfield:CreateWindow({
   Name = "OctoHub",
   Icon = 0,
   LoadingTitle = "Octopus Hub is Currently Loading...",
   LoadingSubtitle = "Please Wait...",
   Theme = "Default",
   DisableRayfieldPrompts = true,
})
if game.PlaceId == RagdollEngine then
	GameTab = Window:CreateTab("Ragdoll Engine", 4483362458)

	local RagdollToggle = GameTab:CreateToggle({
		Name = "AntiRagdoll",
		CurrentValue = false,
		Flag = "RagdollToggle",
		Callback = function(Value)
			if Value then
				Speaker.Character["Local Ragdoll"].Enabled = false
			else
				Speaker.Character["Local Ragdoll"].Enabled = true
			end
		end,
	})
	local Divider = GameTab:CreateDivider()
else
	GameTab = Window:CreateTab("Unexpected Game", 4483362458)
end
local GravitySlider = GameTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 350},
    Increment = 1,
    Suffix = "",
    CurrentValue = 198,
    Flag = "GravitySlider",
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end,
})

local ResetGraviyButton = GameTab:CreateButton({
    Name = "Reset",
    Callback = function()
        GravitySlider:Set(198)
		game.Workspace.Gravity = 198
    end,
})

local Character = Window:CreateTab("Character", 4483362458)
local MovementSection = Character:CreateSection("Movement")

local WalkSpeed = Character:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 550},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Speaker.Character.Humanoid.WalkSpeed = Value
    end,
})
local JumpPower = Character:CreateSlider({
    Name = "JumpPower",
    Range = {0, 550},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "JumpPower",
    Callback = function(Value)
        Speaker.Character.Humanoid.JumpPower = Value
    end,
})
local ResetButton = Character:CreateButton({
    Name = "Reset",
    Callback = function()
        WalkSpeed:Set(16)
        JumpPower:Set(50)
    end,
})

local Divider = Character:CreateDivider()
local ActionsSection = Character:CreateSection("Actions")

local ResetButton = Character:CreateButton({
    Name = "Sit",
    Callback = function()
        Speaker.Character.Humanoid.Sit = true
    end,
})
local GlideToggle = Character:CreateToggle({
    Name = "Glide",
    CurrentValue = false,
    Flag = "Glide",
    Callback = function(Value)
        if Value then
            Speaker.Character.Humanoid.HipHeight = 0
        else
            Speaker.Character.Humanoid.HipHeight = HipHeight
        end
    end,
})

local Divider = Character:CreateDivider()
local ESPSection = Character:CreateSection("ESP")

local ColorPicker = Character:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1",
    Callback = function(Value)
        ESPColor = Value
    end
})

local DepthModeDropdown = Character:CreateDropdown({
	Name = "DepthMode",
	Options = {"Occluded", "AlwaysOnTop"},
	CurrentOption = {"AlwaysOnTop"},
	MultipleOptions = false,
	Flag = "DepthModeDropdown",
	Callback = function(Options)
		ESPOnTop = table.concat(Options)
	end,
})

local ESPTransparencySlider = Character:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPTransparency",
    Callback = function(Value)
        ESPTransparency = Value
    end,
})

local ESPToggle = Character:CreateToggle({
    Name = "Turn ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
		if Value then
			EspWhile = true
			while EspWhile do
				if ESPColor == nil then ESPColor = Color3.fromRGB(225, 225, 225) end
				if ESPOnTop == nil then ESPOnTop = "AlwaysOnTop" end
				if ESPTransparency == nil then ESPTransparency = 0.5 end
				ESP(ESPColor, ESPTransparency, ESPOnTop, "Create")
				task.wait()
			end
		end
        if not Value then
			EspWhile = false
            ESP(ESPColor, false, false, "Destroy")
        end
    end,
})

local D2ivider = Character:CreateDivider()
local FlingSection = Character:CreateSection("Fling")

local WalkFlingToggle = Character:CreateToggle({
    Name = "WalkFling",
    CurrentValue = false,
    Flag = "WalkFlingToggle",
    Callback = function(Value)
		if Value then
			toggleExploit(true)
		else
			toggleExploit(false)
		end
    end,
})

local D2ivider = Character:CreateDivider()
local FlingSection = Character:CreateSection("Fly")

local FlyModeDropdown = Character:CreateDropdown({
	Name = "Mode",
	Options = {"Normal", "Bypass a little"},
	CurrentOption = {"Normal"},
	MultipleOptions = false,
	Flag = "FlyModeDropdown",
	Callback = function(Options)
		FlyMode = table.concat(Options)
	end,
})

local FlyToggle = Character:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
		if Value then
			Turn = true
			if FlyMode == nil then FlyMode = "Normal" end
			FlyToggle(FlyMode)	
		else
			Turn = false
		end
    end,
})

local D2ivider = Character:CreateDivider()

local Teleport = Window:CreateTab("Teleport", 4483362458)
RefreshPlayers()
local PlayersDropdown = Teleport:CreateDropdown({
	Name = "Players",
	Options = ListPlayers,
	CurrentOption = {"Choose an Player"},
	MultipleOptions = false,
	Flag = "PlayersDropdown",
	Callback = function(Options)
		PlayerToTeleport = table.concat(Options)
	end,
})

local TeleportButton = Teleport:CreateButton({
    Name = "Teleport",
    Callback = function()
        Speaker.Character.HumanoidRootPart.CFrame = game.Players[tostring(PlayerToTeleport)].Character.HumanoidRootPart.CFrame
    end,
})

local Other = Window:CreateTab("Other", 4483362458)
local ScriptsSection = Other:CreateSection("Most Popular")
local IYButton = Other:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
    end,
})
local DexButton = Other:CreateButton({
    Name = "Moon Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/21ZeroDay12/Dex/refs/heads/main/Dex.lua"))()
    end,
})
