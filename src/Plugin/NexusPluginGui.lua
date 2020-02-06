--[[
TheNexusAvenger

Mirrors the API of Roblox's PluginGui class.
--]]

local CLASS_NAME = "NexusPluginGui"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusPlugin = NexusPluginFramework:GetResource("Plugin.NexusPlugin")
local NexusPluginButton = NexusPluginFramework:GetResource("Plugin.NexusPluginButton")

local NexusPluginGui = NexusWrappedInstance:Extend()
NexusPluginGui:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusPluginGui)



--[[
Creates a Nexus Plugin Gui object.
--]]
function NexusPluginGui:__new(WidgetName,DockWidgetInfo)
	local PluginGui = NexusPlugin.GetPlugin():CreateDockWidgetPluginGui(WidgetName,DockWidgetInfo)
	self:InitializeSuper(PluginGui)
	
	--Store the Gui.
	self:__SetChangedOverride("PluginGui",function() end)
	self.PluginGui = PluginGui
	
	--Set the defaults.
	self.Title = WidgetName
	self.Name = WidgetName
end



return NexusPluginGui