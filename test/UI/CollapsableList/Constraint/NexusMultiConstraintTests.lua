--[[
TheNexusAvenger

Tests the NexusMultiConstraint class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusMultiConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusMultiConstraint")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusMultiConstraint.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusMultiConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusMultiConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusMultiConstraint","Name is incorrect.")
end)

--[[
Tests that only one can be selected.
--]]
NexusUnitTesting:RegisterUnitTest("OneSelection",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusMultiConstraint.new()
	local Constraint = NexusPluginFramework.new("ListSelectionConstraint")
	CuT:AddConstraint(Constraint)
	
	--Create 4 frames and add 3 of them.
	local Frame1,Frame2 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	local Frame3,Frame4 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	CuT:AddListFrame(Frame3)
	
	--Select 1 frame and assert they are correct.
	Frame1.Selected = true
	UnitTest:AssertTrue(Frame1.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame2.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	
	--Select another frame and assert it is selected.
	Frame2.Selected = true
	UnitTest:AssertFalse(Frame1.Selected,"Frame is selected.")
	UnitTest:AssertTrue(Frame2.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	
	--Assert adding a selected frame late disables the selection.
	Frame4.Selected = true
	CuT:AddListFrame(Frame4)
	UnitTest:AssertFalse(Frame1.Selected,"Frame is selected.")
	UnitTest:AssertTrue(Frame2.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame4.Selected,"Frame is selected.")
end)

--[[
Tests that multiple can be selected.
--]]
NexusUnitTesting:RegisterUnitTest("MultipleSelection",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusMultiConstraint.new()
	local Constraint = NexusPluginFramework.new("ListSelectionConstraint")
	Constraint.AllowMultipleSelections = true
	CuT:AddConstraint(Constraint)
	
	--Create 4 frames and add 3 of them.
	local Frame1,Frame2 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	local Frame3,Frame4 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	CuT:AddListFrame(Frame3)
	Frame1.Selected = true
	Frame4.Selected = true
	
	--Add the 4th frame and assert the selections weren't changed.
	CuT:AddListFrame(Frame4)
	UnitTest:AssertTrue(Frame1.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame2.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	UnitTest:AssertTrue(Frame4.Selected,"Frame is not selected.")
	
	--Make only 1 selection valid and assert only the first frame was selected.
	Constraint.AllowMultipleSelections = false
	UnitTest:AssertTrue(Frame1.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame2.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame4.Selected,"Frame is selected.")
end)



return true