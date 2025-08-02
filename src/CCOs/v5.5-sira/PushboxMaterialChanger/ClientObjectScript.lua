return function()
	script.Parent.Touched:Connect(function(t)
		if t.Name == "Pushbox" then
			t.Material = "Neon" --choose any material lol
		end
	end)
end