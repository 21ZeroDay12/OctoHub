local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Speaker = game.Players.LocalPlayer
local Players = game.Players
local ListPlayers = {}
local PlayerToTeleport
local HipHeight = Speaker.Character.Humanoid.HipHeight
local ESPColor
local EspWhile = true

local function ESP(Color, turn)
	for i = 1, #Players:GetChildren() do
		if turn == "Create" then
			if not Players:GetChildren()[i].Character:FindFirstChild("Highlight") then
				local Highlight = Instance.new("Highlight")
				Highlight.FillColor = Color
				Highlight.Parent = Players:GetChildren()[i].Character
			end
		else
			if Players:GetChildren()[i].Character:FindFirstChild("Highlight") then
				Players:GetChildren()[i].Character:FindFirstChild("Highlight"):Destroy()
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

local ESPToggle = Character:CreateToggle({
    Name = "Turn ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
		if Value then
			EspWhile = true
			while EspWhile do
				ESP(ESPColor, "Create")
				task.wait()
			end
		end
        if not Value then
			EspWhile = false
            ESP(ESPColor, "Destroy")
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
