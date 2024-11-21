local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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
   LoadingSubtitle = "",
   Theme = "Default",
   DisableRayfieldPrompts = true,
})

local Game = Window:CreateTab("Game", 4483362458)

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
