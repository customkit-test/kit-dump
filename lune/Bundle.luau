local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local stdio = require("@lune/stdio")

local Instance = roblox.Instance
local SourceFolder = "src"

function GetArgument(type: string, prompt: string?, ...)
	local value = stdio.prompt(type, prompt, ...)

	if not value or value == "" then
		repeat
			value = stdio.prompt(type, prompt)
		until value and value ~= ""
	end

	return value
end

function SortBySemver(List: { string }): ({ string }, { [number]: number })
	local Parsed = {}

	for _, Version in pairs(List) do
		local RawVersion = Version:gsub("^v", "")

		local Parts = string.split(RawVersion, ".")
		local Major = tonumber(Parts[1]) or 0
		local Minor = tonumber(Parts[2]) or 0
		local Patch = tonumber(Parts[3]) or 0

		table.insert(Parsed, {
			Original = Version,

			Major = Major,
			Minor = Minor,
			Patch = Patch,
		})
	end

	table.sort(Parsed, function(A, B)
		if A.Major ~= B.Major then
			return A.Major < B.Major
		elseif A.Minor ~= B.Minor then
			return A.Minor < B.Minor
		else
			return A.Patch < B.Patch
		end
	end)

	local DisplayList = {}
	local IndexMap = {}
	local LastMajor = nil

	for Index, Entry in pairs(Parsed) do
		if Entry.Major ~= LastMajor then
			table.insert(DisplayList, "--- v" .. Entry.Major .. " ---")
			LastMajor = Entry.Major
		end

		table.insert(DisplayList, Entry.Original)
		IndexMap[#DisplayList] = Index
	end

	return DisplayList, IndexMap
end

local Kits = {}
local Versions = {}

for _, Kit in pairs(fs.readDir(SourceFolder)) do
	table.insert(Kits, Kit)
	Versions[Kit] = {}

	for _, KitVersion in pairs(fs.readDir(SourceFolder .. "/" .. Kit)) do
		table.insert(Versions[Kit], KitVersion)
	end
end

local KitNumber = GetArgument("select", "choose kit", Kits)
local ChosenKit = Kits[KitNumber]

function FetchOptions()
	local VersionsRaw = Versions[ChosenKit]
	local DisplayList, IndexMap = SortBySemver(VersionsRaw)

	table.insert(DisplayList, "--- Misc ---")
	table.insert(DisplayList, "Back")
	table.insert(DisplayList, "Bundle All")

	local VersionNumber = GetArgument("select", "choose version", DisplayList)
	local BundleAll = false

	if DisplayList[VersionNumber] == "Back" then
		KitNumber = GetArgument("select", "choose kit", Kits)
		ChosenKit = Kits[KitNumber]

		return FetchOptions()
	elseif DisplayList[VersionNumber] == "Bundle All" then
		BundleAll = true
	end

	local ParsedIndex = IndexMap[VersionNumber]

	if not ParsedIndex and not BundleAll then
		return FetchOptions()
	end

	local ChosenVersion = VersionsRaw[ParsedIndex]
	local OutputFile

	if BundleAll == true then
		OutputFile = ChosenKit
	else
		OutputFile = string.format("%s-%s", ChosenKit, ChosenVersion)
	end

	local Confirmed: boolean

	if BundleAll == true then
		Confirmed = stdio.prompt("confirm", "are you sure you would like to bundle all of " .. OutputFile .. "'s kits?")
	else
		Confirmed = stdio.prompt("confirm", "are you sure you would like to bundle " .. OutputFile:gsub("-", " Kit ") .. "?")
	end

	if not Confirmed then
		stdio.write("\n")
		return FetchOptions()
	end

	return ChosenVersion, OutputFile, BundleAll
end

function CreateModuleScript(Name, Source)
	local Module = Instance.new("ModuleScript")

	Module.Name = Name
	Module.Source = Source

	return Module
end

function ProcessDirectory(Directory)
	local Folder = Instance.new("Folder")

	for _, File in pairs(fs.readDir(Directory)) do
		local FullPath = Directory .. "/" .. File

		if fs.isDir(FullPath) then
			ProcessDirectory(FullPath).Parent = Folder
		elseif fs.isFile(FullPath) and File:match("%.lua[u]?$") then
			local Source = fs.readFile(FullPath)
			local Name = File:gsub("%.lua[u]?$", "")

			CreateModuleScript(Name, Source).Parent = Folder
		end
	end

	return Folder
end

local ChosenVersion, OutputFile, BundleAll = FetchOptions()
local Directory

OutputFile = string.format("%s.rbxm", OutputFile)

if BundleAll == true then 
	Directory = string.format("%s/%s", SourceFolder, ChosenKit)
else
	Directory = string.format("%s/%s/%s", SourceFolder, ChosenKit, ChosenVersion)
end

local RootInstance = ProcessDirectory(Directory)
local SerializedInstance = roblox.serializeModel({ RootInstance })

if not fs.isDir("bundles") then
	fs.writeDir("bundles/")
end

fs.writeFile("bundles/" .. OutputFile, SerializedInstance)
print("✅ Bundled", Directory, "in", "bundles/" .. OutputFile)
