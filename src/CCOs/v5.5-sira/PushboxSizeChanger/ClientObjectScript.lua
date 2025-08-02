return function()
	script.Parent.Touched:Connect(function(t)
		if t.Name == "Pushbox" then
			t.Size = script.Parent.SizeValue.Value
		end
	end)
end