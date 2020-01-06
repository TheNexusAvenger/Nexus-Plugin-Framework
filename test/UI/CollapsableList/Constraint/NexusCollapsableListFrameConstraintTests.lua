--[[
TheNexusAvenger

Tests the NexusCollapsableListFrameConstraint class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusCollapsableListFrameConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusCollapsableListFrameConstraint")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusCollapsableListFrameConstraint.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusCollapsableListFrameConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusCollapsableListFrameConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusCollapsableListFrameConstraint","Name is incorrect.")
end)

--[[
Tests the ContainsListFrame method.
--]]
NexusUnitTesting:RegisterUnitTest("ContainsListFrame",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add 2 of them.
	local Frame1,Frame2,Frame3 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	
	--Assert the correct frames are in the constraint.
	UnitTest:AssertTrue(CuT:ContainsListFrame(Frame1),"Frame does not exist.")
	UnitTest:AssertTrue(CuT:ContainsListFrame(Frame2),"Frame does not exist.")
	UnitTest:AssertFalse(CuT:ContainsListFrame(Frame3),"Frame does exist.")
end)

--[[
Tests the GetListFrames method.
--]]
NexusUnitTesting:RegisterUnitTest("GetListFrames",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add 2 of them.
	local Frame1,Frame2,Frame3 =  NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	CuT:AddListFrame(Frame2)
	
	--Assert the correct frames are in the constraint.
	local Frames = CuT:GetListFrames()
	UnitTest:AssertEquals(#Frames,2,"Amount of frames is incorrect.")
	UnitTest:AssertSame(Frames[1],Frame1,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[2],Frame2,"Frame is incorrect.")
	
	--Assert adding a third frame at the 2nd index.
	CuT:AddListFrame(Frame3,2)
	local Frames = CuT:GetListFrames()
	UnitTest:AssertEquals(#Frames,3,"Amount of frames is incorrect.")
	UnitTest:AssertSame(Frames[1],Frame1,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[2],Frame3,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[3],Frame2,"Frame is incorrect.")
end)

--[[
Tests the GetAllListFrames method.
--]]
NexusUnitTesting:RegisterUnitTest("GetAllListFrames",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add them.
	local Frame1,Frame2,Frame3 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	Frame1.Expanded = false
	Frame3.Parent = Frame1:GetCollapsableContainer()
	
	--Assert the frames are correct.
	local Frames = CuT:GetAllListFrames()
	UnitTest:AssertEquals(#Frames,3,"Amount of frames is incorrect.")
	UnitTest:AssertSame(Frames[1],Frame1,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[2],Frame3,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[3],Frame2,"Frame is incorrect.")
	
	--Assert the frames are correct.
	local Frames = CuT:GetAllListFrames(true)
	UnitTest:AssertEquals(#Frames,2,"Amount of frames is incorrect.")
	UnitTest:AssertSame(Frames[1],Frame1,"Frame is incorrect.")
	UnitTest:AssertSame(Frames[2],Frame2,"Frame is incorrect.")
end)

--[[
Tests the SortListFrames method.
--]]
NexusUnitTesting:RegisterUnitTest("SortListFrames",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add them.
	local Frame1,Frame2,Frame3 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	Frame1.Name = "Frame1"
	Frame2.Name = "Frame2"
	Frame3.Name = "Frame3"
	CuT:AddListFrame(Frame3)
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	
	--Sort the list frames.
	CuT:SortListFrames(function(a,b)
		return a.Name < b.Name
	end)
	
	--Assert the order is correct.
	UnitTest:AssertEquals(CuT:GetListFrames(),{Frame1,Frame2,Frame3},"Order is incorrect.")
end)

--[[
Tests the RemoveListFrame method.
--]]
NexusUnitTesting:RegisterUnitTest("RemoveListFrame",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add them.
	local Frame1,Frame2,Frame3 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	CuT:AddListFrame(Frame3)
	
	--Assert the frames are removed.
	CuT:RemoveListFrame(Frame1)
	CuT:RemoveListFrame(Frame3)
	CuT:RemoveListFrame(Frame3)
	
	local Frames = CuT:GetListFrames()
	UnitTest:AssertEquals(#Frames,1,"Amount of frames is incorrect.")
	UnitTest:AssertSame(Frames[1],Frame2,"Frame is incorrect.")
end)

--[[
Tests the ClearListFrames method.
--]]
NexusUnitTesting:RegisterUnitTest("ClearListFrames",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrameConstraint.new()
	
	--Create 3 list frames and add them.
	local Frame1,Frame2,Frame3 = NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame"),NexusPluginFramework.new("CollapsableListFrame")
	CuT:AddListFrame(Frame1)
	CuT:AddListFrame(Frame2)
	CuT:AddListFrame(Frame3)
	
	--Assert the frames are removed.
	CuT:ClearListFrames()
	local Frames = CuT:GetListFrames()
	UnitTest:AssertEquals(#Frames,0,"Amount of frames is incorrect.")
end)



return true