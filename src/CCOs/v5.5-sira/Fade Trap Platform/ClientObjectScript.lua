local ts=game:GetService'TweenService'
function tween(part,time,inf)
	local tweeninf=TweenInfo.new(
		time,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)
	local tw=ts:Create(part,tweeninf,inf)
	tw:Play()
end

return function()
	local running = false
	local timeLength = script.Parent:FindFirstChild("Time") and script.Parent.Time.Value or 2
	script.Parent.Touched:Connect(function(part)
		if running then return end
		if part.Parent:FindFirstChild("Humanoid") then
			if game.Players:GetPlayerFromCharacter(part.Parent) == game.Players.LocalPlayer then
				running = true
				tween(script.Parent, timeLength, {Transparency = 1})
				wait(timeLength)
				script.Parent.CanCollide = false
				wait(2)
				script.Parent.CanCollide = true
				tween(script.Parent, 0.5, {Transparency = 0})
				wait(0.5)
				running = false
			end
		end
	end)
end