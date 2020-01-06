--[[
TheNexusAvenger

Main module for Nexus Plugin Framework.
Version 0.1.0
--]]

local NEXUS_CLASS_PATHS = {
	--Signal Classes
	["Signal"] = "NexusInstance.Event.RobloxEvent",
	
	--Plugin
	["PluginButton"] = "Plugin.NexusPluginButton",
	["PluginGui"] = "Plugin.NexusPluginGui",
	["PluginToolbar"] = "Plugin.NexusPluginToolbar",
	["UserInput"] = "Plugin.NexusUserInput",
	
	--UI Classes
	["CollapsableListFrame"] = "UI.CollapsableList.NexusCollapsableListFrame",
	["ListContentsPropertyConstraint"] = "UI.CollapsableList.Constraint.NexusContentsPropertyConstraint",
	["ListMultiConstraint"] = "UI.CollapsableList.Constraint.NexusMultiConstraint",
	["ListPositionConstraint"] = "UI.CollapsableList.Constraint.NexusPositionConstraint",
	["ListSelectionConstraint"] = "UI.CollapsableList.Constraint.NexusSelectionConstraint",
	["BoundingSizeConstraint"] = "UI.Constraint.NexusBoundingSizeConstraint",
	["CheckBox"] = "UI.Input.NexusCheckBox",
	["ImageButton"] = "UI.Input.NexusImageButton",
	["TextBox"] = "UI.Input.NexusTextBox",
	["ScrollBar"] = "UI.Scroll.NexusScrollBar",
	["ScrollingFrame"] = "UI.Scroll.NexusScrollingFrame",
}



local NexusPluginFramework = require(script:WaitForChild("NexusPluginFrameworkProject"))
local NexusPlugin = NexusPluginFramework:GetResource("Plugin.NexusPlugin")
local NexusSettings = NexusPluginFramework:GetResource("Plugin.NexusSettings")
NexusPluginFramework.NexusEnum = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection").GetBuiltInEnums()



--[[
Creates either a Nexus Plugin Framework class or a wrapped Roblox
class for Nexus Plugin Framework. Not all classes are exposed 
through this function.
--]]
function NexusPluginFramework.new(ClassName,...)
	--Return a Nexus Plugin Framework class if any.
	local Path = NEXUS_CLASS_PATHS[ClassName]
	if Path then
		return NexusPluginFramework:GetClass(ClassName).new(...)
	end
	
	--Return a wrapped class.
	local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
	return NexusWrappedInstance.GetInstance(ClassName)
end

--[[
Returns the class for a given name. Note that it
will yield if the class doesn't exist.
--]]
function NexusPluginFramework:GetClass(ClassName)
	local Path = NEXUS_CLASS_PATHS[ClassName]
	return NexusPluginFramework:GetResource(Path)
end

--[[
Returns the plugin instance.
--]]
function NexusPluginFramework:GetPlugin()
	return NexusPlugin.GetPlugin()
end

--[[
Returns the settings instance.
--]]
function NexusPluginFramework:GetSettings()
	return NexusSettings.GetSettings()
end



return NexusPluginFramework