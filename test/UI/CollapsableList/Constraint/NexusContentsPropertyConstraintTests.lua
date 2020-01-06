--[[
TheNexusAvenger

Tests the NexusContentsPropertyConstraint class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusContentsPropertyConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusContentsPropertyConstraint")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusContentsPropertyConstraint.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusContentsPropertyConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusContentsPropertyConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusContentsPropertyConstraint","Name is incorrect.")
end)

--[[
Tests that properties are passed through.
--]]
NexusUnitTesting:RegisterUnitTest("PassThrough",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusContentsPropertyConstraint.new()
	
	--Create 2 list frames and add them to the constraint.
	local Frame1,Frame2 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	local TextLabel1,TextLabel2,TextLabel3 = NexusPluginFramework.new("TextLabel"),NexusPluginFramework.new("TextLabel"),NexusPluginFramework.new("TextLabel")
	TextLabel1.Parent = Frame1:GetMainContainer()
	TextLabel2.Parent = Frame2:GetMainContainer()
	TextLabel3.Parent = Frame2:GetCollapsableContainer()
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	
	--Modify the properties and assert they are passed through.
	Frame1.Disabled = true
	Frame2.Selected = true
	UnitTest:AssertFalse(TextLabel1.Selected,"Text label is selected.")
	UnitTest:AssertTrue(TextLabel1.Disabled,"Text label is not disabled.")
	UnitTest:AssertTrue(TextLabel2.Selected,"Text label is not selected.")
	UnitTest:AssertFalse(TextLabel2.Disabled,"Text label is disabled.")
	UnitTest:AssertFalse(TextLabel3.Selected,"Text label is selected.")
	UnitTest:AssertFalse(TextLabel3.Disabled,"Text label is disabled.")
	
	--Modify the properties and assert they are passed through.
	Frame1.Disabled = false
	Frame1.Selected = true
	Frame2.Disabled = true
	Frame2.Selected = false
	UnitTest:AssertTrue(TextLabel1.Selected,"Text label is not selected.")
	UnitTest:AssertFalse(TextLabel1.Disabled,"Text label is disabled.")
	UnitTest:AssertFalse(TextLabel2.Selected,"Text label is selected.")
	UnitTest:AssertTrue(TextLabel2.Disabled,"Text label is not disabled.")
	UnitTest:AssertFalse(TextLabel3.Selected,"Text label is selected.")
	UnitTest:AssertFalse(TextLabel3.Disabled,"Text label is disabled.")
end)



return true