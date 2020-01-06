--[[
TheNexusAvenger

Image button that disables auto button colors when disabled.
--]]

local CLASS_NAME = "NexusImageButton"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusGuiButton = NexusPluginFramework:GetResource("UI.Input.Abstract.NexusGuiButton")

local NexusImageButton = NexusGuiButton:Extend()
NexusImageButton:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusImageButton)



--[[
Creates a Nexus Image Box object.
--]]
function NexusImageButton:__new()
	self:InitializeSuper("ImageButton")
	self.Name = CLASS_NAME
	
	--Set the defaults.
	self.BackgroundColor3 = "Button"
	self.BorderColor3 = "ButtonBorder"
end



return NexusImageButton