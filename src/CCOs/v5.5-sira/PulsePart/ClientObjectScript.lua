local pulsecolor = script.Parent.PulseColor
local colorshift = script.Parent.Cooldown
local ts = game:GetService("TweenService")

-- // Hey code snooper, I see you! Thanks for using this CO though :)

return function()
	local ogcolor = script.Parent.Color
	
	local T1 = ts:Create(script.Parent, TweenInfo.new(colorshift.Value, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Color = pulsecolor.Value})
	local T2 = ts:Create(script.Parent, TweenInfo.new(colorshift.Value, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Color = ogcolor})
	
	while true do
		T1:Play()
		task.wait(colorshift.Value)
		T2:Play()
		task.wait(colorshift.Value)
	end
	
end