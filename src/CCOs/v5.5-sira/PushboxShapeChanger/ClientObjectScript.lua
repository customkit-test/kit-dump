return function()
	script.Parent.Touched:Connect(function(t)
		if t.Name == "Pushbox" then
			t.Shape = "Cylinder" --Replace this with [Block] or [Ball] or [Cylinder].
		end
	end)
end