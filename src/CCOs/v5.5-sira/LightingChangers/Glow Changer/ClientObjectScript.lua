return function()
script.Parent.Transparency = 1
	script.Parent.Touched:Connect(function(t)
if t.Parent.Humanoid then
if t.Parent.Torso:FindFirstChild("Glow") then
else
local glow = Instance.new("PointLight")
glow.Name = "Glow"
glow.Brightness = script.Parent.Brightness.Value
glow.Range = script.Parent.Range.Value
glow.Color = script.Parent.LightColor.Value
glow.Parent = t.Parent.Torso
end
end
	end)
end