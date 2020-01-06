--[[
TheNexusAvenger

Text box that disables input functionality when disabled.
--]]

local CLASS_NAME = "NexusTextBox"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")

local NexusTextBox = NexusWrappedInstance:Extend()
NexusTextBox:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusTextBox)



--[[
Creates a Nexus Text Box object.
--]]
function NexusTextBox:__new()
	self:InitializeSuper("TextBox")
	self.Name = CLASS_NAME
	
	--Set up input disabling.
	self:GetPropertyChangedSignal("Disabled"):Connect(function()
		if self.Disabled then
			self:ReleaseFocus()
		end
	end)
	
	self.Focused:Connect(function()
		if self.Disabled then
			self:ReleaseFocus()
		end
	end)
	
	--Set the defaults.
	self.BackgroundColor3 = "InputFieldBackground"
	self.BorderColor3 = "InputFieldBorder"
	self.TextColor3 = "MainText"
	self.PlaceholderColor3 = "DimmedText"
	self.TextXAlignment = "Left"
	self.Font = "SourceSans"
	self.TextSize = 14
	self.ClearTextOnFocus = false
	self.ClipsDescendants = true
end



return NexusTextBox