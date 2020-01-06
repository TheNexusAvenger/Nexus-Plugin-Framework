--[[
TheNexusAvenger

Gui button that disables auto button colors when disabled.
Class is abstract, so it should not be called directly.
--]]

local CLASS_NAME = "NexusGuiButton"



local NexusPluginFramework = require(script.Parent.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")

local NexusGuiButton = NexusWrappedInstance:Extend()
NexusGuiButton:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusGuiButton)



--[[
Creates a Nexus Text Box object.
--]]
function NexusGuiButton:__new(ButtonClassName)
	self:InitializeSuper(ButtonClassName)
	self.Name = CLASS_NAME
	
	--Set up auto button color disabling.
	self:GetPropertyChangedSignal("Disabled"):Connect(function()
		self.AutoButtonColor = not self.Disabled
	end)
end



return NexusGuiButton