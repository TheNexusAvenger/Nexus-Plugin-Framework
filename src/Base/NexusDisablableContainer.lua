--[[
TheNexusAvenger

Guarentees a container can be enabled or disabled.
--]]

local CLASS_NAME = "NexusDisablableContainer"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")

local NexusDisablableContainer = NexusContainer:Extend()
NexusDisablableContainer:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusDisablableContainer)



--[[
Creates a Nexus Disablable Container object.
--]]
function NexusDisablableContainer:__new()
	self:InitializeSuper()
	
	self.Name = CLASS_NAME
	self.Disabled = false
end

--[[
Returns if the container is enabled.
--]]
function NexusDisablableContainer:IsEnabled()
	return not self.Disabled
end



return NexusDisablableContainer