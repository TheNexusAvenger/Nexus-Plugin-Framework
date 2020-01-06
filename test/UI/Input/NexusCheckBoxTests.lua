--[[
TheNexusAvenger

Tests the NexusCheckBox class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusCheckBox = NexusPluginFramework:GetResource("UI.Input.NexusCheckBox")
local NexusEnums = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection").GetBuiltInEnums()



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusCheckBox.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusCheckBox","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusCheckBox","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusCheckBox","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
end)

--[[
Tests the BoxState property.
--]]
NexusUnitTesting:RegisterUnitTest("BoxState",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCheckBox.new()
	local ImageLabel,Frame = CuT:GetWrappedInstance():FindFirstChild("ImageLabel"),CuT:GetWrappedInstance():FindFirstChild("Frame")
	
	--Assert the checked box state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Checked
	UnitTest:AssertTrue(ImageLabel.Visible,"Check isn't visible.")
	UnitTest:AssertFalse(Frame.Visible,"Box is visible.")
	UnitTest:AssertTrue(CuT.Selected,"Frame isn't selected.")
	
	--Assert the mixed box state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Mixed
	UnitTest:AssertFalse(ImageLabel.Visible,"Check is visible.")
	UnitTest:AssertTrue(Frame.Visible,"Box isn't visible.")
	UnitTest:AssertFalse(CuT.Selected,"Frame is selected.")
	
	--Assert the unchecked box state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Unchecked
	UnitTest:AssertFalse(ImageLabel.Visible,"Check is visible.")
	UnitTest:AssertFalse(Frame.Visible,"Box is visible.")
	UnitTest:AssertFalse(CuT.Selected,"Frame is selected.")
end)

--[[
Tests the CheckColor3 and MixedColor3 properties.
--]]
NexusUnitTesting:RegisterUnitTest("Colors",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCheckBox.new()
	local ImageLabel,Frame = CuT:GetWrappedInstance():FindFirstChild("ImageLabel"),CuT:GetWrappedInstance():FindFirstChild("Frame")
	
	--Set the colors.
	CuT.CheckColor3 = Color3.new(1,0,0)
	CuT.MixedColor3 = Color3.new(0,1,0)
	
	--Assert the colors are correct.
	UnitTest:AssertClose(ImageLabel.ImageColor3,Color3.new(1,0,0),0.0001,"Color is not close.")
	UnitTest:AssertClose(Frame.BackgroundColor3,Color3.new(0,1,0),0.0001,"Color is not close.")
end)

--[[
Tests the Toggle method.
TODO: Nexus Unit Testing requires NexusEnums twice, leading to the refernces being incorrect.
--]]
NexusUnitTesting:RegisterUnitTest("Toggle",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCheckBox.new()
	
	--Assert toggling from the checked state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Checked
	CuT:Toggle()
	UnitTest:AssertTrue(NexusEnums.CheckBoxState.Unchecked:Equals(CuT.BoxState),"Final state is incorrect.")
	
	--Assert toggling from the mixed state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Mixed
	CuT:Toggle()
	UnitTest:AssertTrue(NexusEnums.CheckBoxState.Unchecked:Equals(CuT.BoxState),"Final state is incorrect.")
	
	--Assert toggling from the unchecked state is correct.
	CuT.BoxState = NexusEnums.CheckBoxState.Unchecked
	CuT:Toggle()
	UnitTest:AssertTrue(NexusEnums.CheckBoxState.Checked:Equals(CuT.BoxState),"Final state is incorrect.")
end)



return true