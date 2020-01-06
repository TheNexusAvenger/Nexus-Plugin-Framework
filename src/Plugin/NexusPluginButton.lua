--[[
TheNexusAvenger

Mirrors the API of Roblox's PluginButton class.
--]]

local CLASS_NAME = "NexusPluginButton"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")

local NexusPluginButton = NexusWrappedInstance:Extend()
NexusPluginButton:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusPluginButton)



--[[
Creates a Nexus Plugin Button object.
--]]
function NexusPluginButton:__new(Toolbar,ButtonName,ButtonTooltip,ButtonIcon)
	--Correct the inputs.
	if not ButtonName then
		error("Button name can't be nil.")
	end
	ButtonTooltip = ButtonTooltip or ""
	ButtonIcon = ButtonIcon or ""
	
	--Create the button.
	local Button = Toolbar.Toolbar:CreateButton(ButtonName,ButtonTooltip,ButtonIcon)
	self:InitializeSuper(Button)
	self.Name = CLASS_NAME
	
	--Store the button.
	self:__SetChangedOverride("Button",function() end)
	self.Button = Button
	
	--Connect the changes.
	self:__SetChangedOverride("Active",function()
		self.Button:SetActive(self.Active)
	end)
	self.Active = false
end



return NexusPluginButton