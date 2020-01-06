--[[
TheNexusAvenger

Frame that adds checkbox functionality.
--]]

local CLASS_NAME = "NexusCheckBox"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusObject = NexusPluginFramework:GetResource("NexusInstance.NexusObject")
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusEnums = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection").GetBuiltInEnums()

local NexusCheckBox = NexusWrappedInstance:Extend()
NexusCheckBox:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusCheckBox)



--[[
Creates a Nexus Check Box object.
--]]
function NexusCheckBox:__new()
	self:InitializeSuper("Frame")
	self.Name = CLASS_NAME
	self.BorderSizePixel = 1
	
	--Create the frames.
	local Checkmark = NexusWrappedInstance.GetInstance("ImageLabel")
	Checkmark.Hidden = true
	Checkmark.Size = UDim2.new(1 * 0.9,0,1.4 * 0.9,0)
	Checkmark.Position = UDim2.new(0,0,-0.1,0)
	Checkmark.BackgroundTransparency = 1
	Checkmark.Image = "rbxasset://textures/ui/LuaChat/icons/ic-check.png"
	Checkmark.Visible = false
	Checkmark.Parent = self
	
	local MixedFill = NexusWrappedInstance.GetInstance("Frame")
	MixedFill.Hidden = true
	MixedFill.Size = UDim2.new(0.9,0,0.9,0)
	MixedFill.AnchorPoint = Vector2.new(0.5,0.5)
	MixedFill.Position = UDim2.new(0.5,0,0.5,0)
	MixedFill.BorderSizePixel = 0
	MixedFill.Visible = false
	MixedFill.Parent = self:GetWrappedInstance()
	
	--Set up the non-frame colors.
	self:__SetChangedOverride("CheckColor3",function()
		Checkmark.ImageColor3 = self.CheckColor3
	end)
	
	self:__SetChangedOverride("MixedColor3",function()
		MixedFill.BackgroundColor3 = self.MixedColor3
	end)
	
	--Set up the state changes.
	self:__SetChangedOverride("BoxState",function()
		Checkmark.Visible = NexusEnums.CheckBoxState.Checked:Equals(self.BoxState)
		MixedFill.Visible = NexusEnums.CheckBoxState.Mixed:Equals(self.BoxState)
		self.Selected = NexusEnums.CheckBoxState.Checked:Equals(self.BoxState)
	end)
	
	--Set up user input.
	self.InputBegan:Connect(function(Input)
		--Return if the frame isn't enabled.
		if not self:IsEnabled() then
			return
		end
		
		--If the mouse button was pressed, toggle the button.
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:Toggle()
		end
	end)
	
	--Initialize the initial state.
	self.BoxState = NexusEnums.CheckBoxState.Unchecked
	
	--Initialize the colors.
	self.BackgroundColor3 = "CheckedFieldBackground"
	self.BorderColor3 = "CheckedFieldBorder"
	self.CheckColor3 = "CheckedFieldIndicator"
	self.MixedColor3 = "CheckedFieldIndicator"
end

--[[
Toggles the checkbox.
--]]
function NexusCheckBox:Toggle()
	if NexusEnums.CheckBoxState.Unchecked:Equals(self.BoxState) then
		self.BoxState = NexusEnums.CheckBoxState.Checked
	else
		self.BoxState = NexusEnums.CheckBoxState.Unchecked
	end
end



return NexusCheckBox