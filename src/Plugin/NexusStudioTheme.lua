--[[
TheNexusAvenger

Mirrors the API of Roblox's StudioTheme class.
--]]

local CLASS_NAME = "NexusStudioTheme"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")
local ThemeColors = NexusPluginFramework:GetResource("Data.ThemeColors")

local NexusStudioTheme = NexusContainer:Extend()
NexusStudioTheme:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusStudioTheme)

local CachedThemes = {}



--[[
Creates a theme class from an enum.
--]]
function NexusStudioTheme.FromThemeEnum(ThemeType)
	--Create the cached theme.
	if not CachedThemes[ThemeType] then
		CachedThemes[ThemeType] = NexusStudioTheme.new(ThemeType)
	end
	
	--Return the cached theme.
	return CachedThemes[ThemeType]
end

--[[
Creates a Studio Theme object.
--]]
function NexusStudioTheme:__new(Theme)
	self:InitializeSuper()
	
	--Store the theme and set the name.
	self.__Theme = Theme
	self.Name = Theme.Name
end

--[[
Returns the color corresponding to the arguments provided.
--]]
function NexusStudioTheme:GetColor(StyleGuideColor,Modifier)
	--Correct the input.
	if type(StyleGuideColor) == "string" then
		StyleGuideColor = Enum.StudioStyleGuideColor[StyleGuideColor]	
	end
	
	if not Modifier then
		Modifier = Enum.StudioStyleGuideModifier.Default
	elseif type(Modifier) == "string" then
		Modifier = Enum.StudioStyleGuideModifier[Modifier]
	end
	
	--Return the color.
	return ThemeColors[self.__Theme][StyleGuideColor][Modifier]
end

--[[
Returns the path of an asset (or image) for the Id and Modifier.
--]]
function NexusStudioTheme:GetPath(AssetId,Modifier)
	warn("Unimplemented: NexusStudioTheme:GetPath(AssetId,Modifier)")
	return "Unimplemented"
end



return NexusStudioTheme