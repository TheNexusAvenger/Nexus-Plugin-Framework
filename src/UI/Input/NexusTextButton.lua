--[[
TheNexusAvenger

Text button that disables auto button colors when disabled.
--]]

local CLASS_NAME = "NexusTextButton"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusGuiButton = NexusPluginFramework:GetResource("UI.Input.Abstract.NexusGuiButton")

local NexusTextBox = NexusGuiButton:Extend()
NexusTextBox:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusTextBox)



--[[
Creates a Nexus Text Box object.
--]]
function NexusTextBox:__new()
	self:InitializeSuper("TextButton")
	self.Name = CLASS_NAME
	
	--Set the defaults.
	self.BackgroundColor3 = "Button"
	self.BorderColor3 = "ButtonBorder"
	self.TextColor3 = "ButtonText"
	self.Font = "SourceSans"
	self.TextSize = 14
end



return NexusTextBox