--[[
TheNexusAvenger

Proxy's Roblox's settings.
--]]

local CLASS_NAME = "NexusSettings"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")

local NexusSettings = NexusContainer:Extend()
NexusSettings:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusSettings)

local CachedSettings

--[[
Returns a singleton version of the settings.
--]]
function NexusSettings.GetSettings()
	--Create the cached settings.
	if not CachedSettings then
		CachedSettings = NexusSettings.new()
	end
	
	--Return the cached settings.
	return CachedSettings
end

--[[
Creates a Nexus Settings object.
--]]
function NexusSettings:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
end

--[[
Returns the setting for the given category and name.
--]]
function NexusSettings:GetSetting(Category,Name)
	return settings()[Category][Name]
end

--[[
Sets the setting for the given category and name.
--]]
function NexusSettings:SetSetting(Category,Name,Value)
	settings()[Category][Name] = Value
end

--[[
Returns a changed signal for a given property. If the name
is nil, a changed signal for the category is returned.
--]]
function NexusSettings:GetSettingsChangedSignal(Category,Name)
	--Get the settings category.
	local SettingsCategory = settings()[Category]
	
	--Return the changed signal.
	if Name == nil then
		return SettingsCategory.Changed
	else
		return SettingsCategory:GetPropertyChangedSignal(Name)
	end
end



return NexusSettings