--[[
TheNexusAvenger

Mirrors the API of Roblox's PluginToolbar class.
--]]

local CLASS_NAME = "NexusPluginToolbar"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusPlugin = NexusPluginFramework:GetResource("Plugin.NexusPlugin")
local NexusPluginButton = NexusPluginFramework:GetResource("Plugin.NexusPluginButton")

local NexusPluginToolbar = NexusWrappedInstance:Extend()
NexusPluginToolbar:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusPluginToolbar)



--[[
Creates a Nexus Plugin Toolbar object.
--]]
function NexusPluginToolbar:__new(ToolbarName)
	local Toolbar = NexusPlugin.GetPlugin():CreateToolbar(ToolbarName)
	self:InitializeSuper(Toolbar)
	self.Name = CLASS_NAME
	
	--Store the toolbar.
	self:__SetChangedOverride("Toolbar",function() end)
	self.Toolbar = Toolbar
end

--[[
Creates a button button.
--]]
function NexusPluginToolbar:CreateButton(ButtonName,ButtonTooltip,ButtonIcon)
	return NexusPluginButton.new(self,ButtonName,ButtonTooltip,ButtonIcon)
end



return NexusPluginToolbar