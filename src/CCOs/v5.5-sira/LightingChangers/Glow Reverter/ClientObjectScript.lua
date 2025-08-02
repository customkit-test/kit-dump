return function()
	script.Parent.Transparency = 1
	script.Parent.Touched:Connect(function(t)
		if t.Parent.Humanoid then
			if t.Parent.Torso:FindFirstChild("Glow") then
				t.Parent.Torso.Glow:Destroy()
			end
		end
	end)
end