local userInputService = game:GetService("UserInputService")
local descendants = workspace:GetDescendants()
local tweenService = game:GetService("TweenService")
local runService = game:GetService('RunService')

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local mainParts = {}
local info = TweenInfo.new(script.Parent.FlipTime.Value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweening = {}
local tweened = {}
return function()
	local i = 0
	for _, instance in pairs(script.Parent:GetDescendants()) do
		if instance.Name == "MainPart" then
			table.insert(mainParts, instance)
			i = i + 1
			tweening[i] = false
			tweened[i] = false
			instance.Transparency = 1
		end
	end
	userInputService.JumpRequest:Connect(function()
		character = player.Character or player.CharacterAdded:Wait()
		if character:FindFirstChild("HumanoidRootPart") then
			for i, mainPart in pairs(mainParts) do
				if mainPart.Parent:IsA("Model") then
					if mainPart.Name == "MainPart" then
						if tweening[i] == false then
							tweening[i] = true
							spawn(function()
								if tweened[i] == false then
									local tween = tweenService:Create(mainPart, info, {CFrame = mainPart.CFrame * CFrame.Angles(math.pi,0,0)})
									tween:Play()
									tween.Completed:Connect(function()
										tweening[i] = false
									end)
									tweened[i] = true
								elseif tweened[i] == true then
									local tween = tweenService:Create(mainPart, info, {CFrame = mainPart.CFrame * CFrame.Angles((-math.pi),0,0)})
									tween:Play()
									tween.Completed:Connect(function()
										tweening[i] = false
									end)
									tweened[i] = false
								end
							end)
						end
					end
				end
			end
		end
	end)
end