--[[
TheNexusAvenger

Tests the NexusSelectionConstraint class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusSelectionConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusSelectionConstraint")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusSelectionConstraint.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusSelectionConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusSelectionConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusSelectionConstraint","Name is incorrect.")
end)

--[[
Tests that only one can be selected.
--]]
NexusUnitTesting:RegisterUnitTest("OneSelection",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusSelectionConstraint.new()
	
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
	local CuT = NexusSelectionConstraint.new()
	CuT.AllowMultipleSelections = true
	
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
	CuT.AllowMultipleSelections = false
	UnitTest:AssertTrue(Frame1.Selected,"Frame is not selected.")
	UnitTest:AssertFalse(Frame2.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame3.Selected,"Frame is selected.")
	UnitTest:AssertFalse(Frame4.Selected,"Frame is selected.")
end)

--[[
Creates a series of list frames and the constraint.
Disabled unless needed.
--]]
--[[
NexusUnitTesting:RegisterUnitTest("ManualTestingSingleSelection",function(UnitTest)
	--Create the screen gui.
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("StarterGui")
	
	--Create the constraint.
	local CuT = NexusSelectionConstraint.new()
	
	--Create the background frame.
	local Frame = NexusPluginFramework.new("Frame")
	Frame.Size = UDim2.new(0,500,0,200)
	Frame.Parent = ScreenGui
	
	--Create the first list frame.
	local ListFrame1 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame1.Size = UDim2.new(1,0,0,16)
	ListFrame1.Expanded = false
	ListFrame1.Parent = Frame
	CuT:AddListFrame(ListFrame1)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 1 (Collapsed by default)"
	TextLabel.Parent = ListFrame1:GetMainContainer()
	
	--Create the second list frame.
	local ListFrame2 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame2.Size = UDim2.new(1,0,0,16)
	ListFrame2.Parent = ListFrame1:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 2"
	TextLabel.Parent = ListFrame2:GetMainContainer()
	
	--Create the third list frame.
	local ListFrame3 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame3.Size = UDim2.new(1,0,0,16)
	ListFrame3.Position = UDim2.new(0,0,0,16)
	ListFrame3.Parent = ListFrame1:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 3"
	TextLabel.Parent = ListFrame3:GetMainContainer()
	
	--Create the fourth list frame.
	local ListFrame4 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame4.Size = UDim2.new(1,0,0,16)
	ListFrame4.Position = UDim2.new(0,0,0,48)
	ListFrame4.Parent = Frame
	CuT:AddListFrame(ListFrame4)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 4"
	TextLabel.Parent = ListFrame4:GetMainContainer()
	
	--Create the fifth list frame.
	local ListFrame5 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame5.Size = UDim2.new(1,0,0,16)
	ListFrame5.Position = UDim2.new(0,0,0,64)
	ListFrame5.Parent = Frame
	CuT:AddListFrame(ListFrame5)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 5"
	TextLabel.Parent = ListFrame5:GetMainContainer()
	
	--Create the sixth list frame.
	local ListFrame6 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame6.Size = UDim2.new(1,0,0,16)
	ListFrame6.Position = UDim2.new(0,0,0,80)
	ListFrame6.Parent = Frame
	CuT:AddListFrame(ListFrame6)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 6"
	TextLabel.Parent = ListFrame6:GetMainContainer()
	
	--Wait for the screen gui to be deleted.
	while ScreenGui.Parent do wait() end
end)
--]]

--[[
Creates a series of list frames and the constraint.
Disabled unless needed.
--]]
--[[
NexusUnitTesting:RegisterUnitTest("ManualTestingMultipleSelection",function(UnitTest)
	--Create the screen gui.
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("StarterGui")
	
	--Create the constraint.
	local CuT = NexusSelectionConstraint.new()
	CuT.AllowMultipleSelections = true
	
	--Create the background frame.
	local Frame = NexusPluginFramework.new("Frame")
	Frame.Position = UDim2.new(0,600,0,0)
	Frame.Size = UDim2.new(0,500,0,200)
	Frame.Parent = ScreenGui
	
	--Create the first list frame.
	local ListFrame1 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame1.Size = UDim2.new(1,0,0,16)
	ListFrame1.Expanded = false
	ListFrame1.Parent = Frame
	CuT:AddListFrame(ListFrame1)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 1 (Collapsed by default)"
	TextLabel.Parent = ListFrame1:GetMainContainer()
	
	--Create the second list frame.
	local ListFrame2 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame2.Size = UDim2.new(1,0,0,16)
	ListFrame2.Parent = ListFrame1:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 2"
	TextLabel.Parent = ListFrame2:GetMainContainer()
	
	--Create the third list frame.
	local ListFrame3 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame3.Size = UDim2.new(1,0,0,16)
	ListFrame3.Position = UDim2.new(0,0,0,16)
	ListFrame3.Parent = ListFrame1:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 3"
	TextLabel.Parent = ListFrame3:GetMainContainer()
	
	--Create the fourth list frame.
	local ListFrame4 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame4.Size = UDim2.new(1,0,0,16)
	ListFrame4.Position = UDim2.new(0,0,0,48)
	ListFrame4.Parent = Frame
	CuT:AddListFrame(ListFrame4)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 4"
	TextLabel.Parent = ListFrame4:GetMainContainer()
	
	--Create the fifth list frame.
	local ListFrame5 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame5.Size = UDim2.new(1,0,0,16)
	ListFrame5.Position = UDim2.new(0,0,0,64)
	ListFrame5.Parent = Frame
	CuT:AddListFrame(ListFrame5)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 5"
	TextLabel.Parent = ListFrame5:GetMainContainer()
	
	--Create the sixth list frame.
	local ListFrame6 = NexusPluginFramework.new("CollapsableListFrame")
	ListFrame6.Size = UDim2.new(1,0,0,16)
	ListFrame6.Position = UDim2.new(0,0,0,80)
	ListFrame6.Parent = Frame
	CuT:AddListFrame(ListFrame6)
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 6"
	TextLabel.Parent = ListFrame6:GetMainContainer()
	
	--Wait for the screen gui to be deleted.
	while ScreenGui.Parent do wait() end
end)
--]]



return true