local newsky
if not game.Lighting:FindFirstChildWhichIsA("Sky") then local forcedsky = Instance.new("Sky",game.Lighting) end
local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

if script.Parent:FindFirstChild("Default") then
	if game.Lighting:FindFirstChildWhichIsA("Sky") then
		newsky = game.Lighting:FindFirstChildWhichIsA("Sky"):Clone()
		newsky.Parent = script.Parent
	end
end

if script.Parent:FindFirstChildWhichIsA("Sky") then
	newsky = script.Parent:FindFirstChildWhichIsA("Sky")
end

return function()
	local debounce = true
	script.Parent.Transparency = 0.9
	script.Parent.Touched:Connect(function(hit)
		if debounce == true and game.Players:GetPlayerFromCharacter(hit.Parent) == game.Players.LocalPlayer then
			debounce = false
			local CloneSound = script.Parent.Sound:Clone()
			CloneSound.Parent = workspace
			CloneSound:Play()
			local gui = player.PlayerGui.FlashGUI
			local TransparencyTweenInfo = TweenInfo.new(
				1, 
				Enum.EasingStyle.Linear, 
				Enum.EasingDirection.Out,
				0,
				false,
				0
			)
			local FrameProperties = {
				Transparency = 1
			}
			local Tween = tweenService:Create(gui.Frame, TransparencyTweenInfo, FrameProperties)
			gui.Frame.Transparency = 0
			Tween:Play()
			local CloneSky = newsky:Clone()
			CloneSky.Parent = game.Lighting
			spawn(function()
				wait(CloneSound.TimeLength)
				if CloneSound ~= nil then
					CloneSound:Destroy()
				end
				debounce = true
			end)
		end
	end)
end