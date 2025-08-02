local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local stdio = require("@lune/stdio")

local Instance = roblox.Instance
local SRC_FOLDER = "src"

function getArgument(type: string, prompt: string?, ...)
	local value = stdio.prompt(type, prompt, ...)

	if not value or value == "" then
		repeat
			value = stdio.prompt(type, prompt)
		until value and value ~= ""
	end

	return value
end

function sortBySemver(list: { string }): ({ string }, { [number]: number })
	local parsed = {}

	for _, version in ipairs(list) do
		local v = version:gsub("^v", "")
		local parts = string.split(v, ".")
		local major = tonumber(parts[1]) or 0
		local minor = tonumber(parts[2]) or 0
		local patch = tonumber(parts[3]) or 0

		table.insert(parsed, {
			original = version,
			major = major,
			minor = minor,
			patch = patch,
		})
	end

	table.sort(parsed, function(a, b)
		if a.major ~= b.major then
			return a.major < b.major
		elseif a.minor ~= b.minor then
			return a.minor < b.minor
		else
			return a.patch < b.patch
		end
	end)

	local displayList = {}
	local indexMap = {} -- [displayIndex] = originalVersionIndex
	local lastMajor = nil

	for i, entry in ipairs(parsed) do
		if entry.major ~= lastMajor then
			table.insert(displayList, "--- v" .. entry.major .. " ---")
			lastMajor = entry.major
		end

		table.insert(displayList, entry.original)
		indexMap[#displayList] = i -- map display index to parsed index
	end

	return displayList, indexMap
end

local kits = {}
local versions = {}

for _, kit in pairs(fs.readDir(SRC_FOLDER)) do
	table.insert(kits, kit)
	versions[kit] = {}

	for _, kitVersion in pairs(fs.readDir(SRC_FOLDER .. "/" .. kit)) do
		table.insert(versions[kit], kitVersion)
	end
end

local kitNumber = getArgument("select", "choose kit", kits)
local chosenKit = kits[kitNumber]

function fetchOptions()
	local versionsRaw = versions[chosenKit]
	local displayList, indexMap = sortBySemver(versionsRaw)

	table.insert(displayList, "---")
	table.insert(displayList, "Back")

	local versionNumber = getArgument("select", "choose version", displayList)

	if displayList[versionNumber] == "Back" then 
		kitNumber = getArgument("select", "choose kit", kits)
		chosenKit = kits[kitNumber]

		return fetchOptions()
	end

	local parsedIndex = indexMap[versionNumber]

	if not parsedIndex then
		return fetchOptions()
	end

	local chosenVersion = versionsRaw[parsedIndex]
	local OUTPUT_FILE = chosenKit .. "-" .. chosenVersion .. ".rbxm"

	local confirmed: boolean = stdio.prompt("confirm", "are you sure you would like to build " .. OUTPUT_FILE .. "?")

	if not confirmed then
		stdio.write("\n")
		return fetchOptions()
	end

	return OUTPUT_FILE
end

local OUTPUT_FILE = fetchOptions()

function createModuleScript(name, source)
	local module = Instance.new("ModuleScript")

	module.Name = name
	module.Source = source

	return module
end

function processDirectory(dir)
	local split = string.split(dir, "/")
	local folder = Instance.new("Folder")

	folder.Name = dir ~= "src" and split[#split] or "UniversalRepo"

	for _, file in pairs(fs.readDir(dir)) do
		local fullPath = dir .. "/" .. file

		if fs.isDir(fullPath) then
			processDirectory(fullPath).Parent = folder
		elseif fs.isFile(fullPath) and file:match("%.lua[u]?$") then
			local source = fs.readFile(fullPath)
			local name = file:gsub("%.lua[u]?$", "")

			createModuleScript(name, source).Parent = folder
		end
	end

	return folder
end

local rootInstance = processDirectory(SRC_FOLDER)
local buffer = roblox.serializeModel({ rootInstance })

if not fs.isDir("build") then 
	fs.writeDir("build/")
end

fs.writeFile("build/" .. OUTPUT_FILE, buffer)
print("✅ Serialized", SRC_FOLDER, "→", "build/" .. OUTPUT_FILE)
