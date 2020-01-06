--[[
TheNexusAvenger

Tests the NexusContainer class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")



--[[
Creates the components under testing.
--]]
local function Setup()
	local CuT1 = NexusContainer.new()
	local CuT2 = NexusContainer.new()
	local CuT3 = NexusContainer.new()
	local CuT4 = NexusContainer.new()
	
	CuT1.Name = "TestContainer1"
	CuT2.Name = "TestContainer2"
	CuT3.Name = "TestContainer3"
	CuT4.Name = "TestContainer4"
	
	return CuT1,CuT2,CuT3,CuT4
end

--[[
Asserts the contents of a table are the same.
--]]
local function AssertContentsSame(UnitTest,Expected,Actual,Message)
	--If the contents of the expected don't match, fail the test.
	for Key,Value in pairs(Expected) do
		if Value ~= Actual[Key] then
			UnitTest:Fail(Message)
		end
	end
	
	--If the contents of the actual don't match, fail the test.
	for Key,Value in pairs(Actual) do
		if Value ~= Expected[Key] then
			UnitTest:Fail(Message)
		end
	end
end



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusContainer.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusContainer","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusContainer","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusContainer","Name is incorrect.")
end)

--[[
Tests indexing children.
--]]
NexusUnitTesting:RegisterUnitTest("Indexing",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT3
	
	--Assert indexing is correct.
	UnitTest:AssertSame(CuT1.TestContainer2,CuT2,"Indexing is incorrect.")
	UnitTest:AssertSame(CuT1.TestContainer3,CuT3,"Indexing is incorrect.")
	UnitTest:AssertSame(CuT1.TestContainer3.TestContainer4,CuT4,"Indexing is incorrect.")
end)

--[[
Tests the Hidden property.
--]]
NexusUnitTesting:RegisterUnitTest("Hidden",function(UnitTest)
	local ChildAddedCount,DescendantAddedCount = 0,0
	
	--Create the components under testing.
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT1.ChildAdded:Connect(function(Child)
		ChildAddedCount = ChildAddedCount + 1
	end)
	CuT1.DescendantAdded:Connect(function(Child)
		DescendantAddedCount = DescendantAddedCount + 1
	end)
	CuT2.Hidden = true
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	
	--Assert indexing is correct.
	UnitTest:AssertEquals(ChildAddedCount,1,"ChildAdded fired an incorrect amount of times.")
	UnitTest:AssertEquals(DescendantAddedCount,1,"DescendantAdded fired an incorrect amount of times.")
	AssertContentsSame(UnitTest,CuT1:GetChildren(),{CuT3},"GetChildren is incorrect.")
	AssertContentsSame(UnitTest,CuT1:GetDescendants(),{CuT3},"GetDescendants is incorrect.")
end)

--[[
Test the AncestryChanged event.
--]]
NexusUnitTesting:RegisterUnitTest("AncestryChanged",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	local ChildChanges,ParentChanges = {},{}
	
	--Set up change tracking.
	CuT1.AncestryChanged:Connect(function(Child,Parent)
		table.insert(ChildChanges,Child)
		table.insert(ParentChanges,Parent)
	end)
	
	--Change the parents.
	CuT1.Parent = CuT2
	CuT2.Parent = CuT3
	CuT3.Parent = CuT4
	CuT1.Parent = CuT4
	CuT1.Parent = nil
	
	--Assert the event was fired correctly.
	UnitTest:AssertSame(ChildChanges[1],CuT1,"Change was incorrect.")
	UnitTest:AssertSame(ParentChanges[1],CuT2,"Change was incorrect.")
	UnitTest:AssertSame(ChildChanges[2],CuT2,"Change was incorrect.")
	UnitTest:AssertSame(ParentChanges[2],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(ChildChanges[3],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(ParentChanges[3],CuT4,"Change was incorrect.")
	UnitTest:AssertSame(ChildChanges[4],CuT1,"Change was incorrect.")
	UnitTest:AssertSame(ParentChanges[4],CuT4,"Change was incorrect.")
	UnitTest:AssertSame(ChildChanges[5],CuT1,"Change was incorrect.")
	UnitTest:AssertSame(ParentChanges[5],nil,"Change was incorrect.")
end)

--[[
Test the ChildAdded event.
--]]
NexusUnitTesting:RegisterUnitTest("ChildAdded",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	local AddedChildren = {}
	
	--Set up addition tracking.
	CuT1.ChildAdded:Connect(function(Child)
		table.insert(AddedChildren,Child)
	end)
	
	--Change the parents.
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	CuT4.Parent = CuT1
	
	--Assert the event was fired correctly.
	UnitTest:AssertSame(AddedChildren[1],CuT2,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[2],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[3],CuT4,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[4],nil,"Change was incorrect.")
end)

--[[
Test the ChildRemoved event.
--]]
NexusUnitTesting:RegisterUnitTest("ChildRemoved",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	local RemovedChildren = {}
	
	--Set up removing tracking.
	CuT1.ChildRemoved:Connect(function(Child)
		table.insert(RemovedChildren,Child)
	end)
	
	--Change the parents.
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	CuT3.Parent = CuT2
	CuT2.Parent = nil
	CuT3.Parent = nil
	CuT4.Parent = nil
	
	--Assert the event was fired correctly.
	UnitTest:AssertSame(RemovedChildren[1],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(RemovedChildren[2],CuT2,"Change was incorrect.")
end)

--[[
Test the DescendantAdded event.
--]]
NexusUnitTesting:RegisterUnitTest("DescendantAdded",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	local AddedChildren = {}
	
	--Set up addition tracking.
	CuT1.DescendantAdded:Connect(function(Child)
		table.insert(AddedChildren,Child)
	end)
	
	--Change the parents.
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	CuT4.Parent = CuT1
	
	--Assert the event was fired correctly.
	UnitTest:AssertSame(AddedChildren[1],CuT2,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[2],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[3],CuT4,"Change was incorrect.")
	UnitTest:AssertSame(AddedChildren[4],CuT4,"Change was incorrect.")
end)

--[[
Test the DescendantRemoving event.
--]]
NexusUnitTesting:RegisterUnitTest("DescendantRemoving",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	local RemovedChildren = {}
	
	--Set up removing tracking.
	CuT1.DescendantRemoving:Connect(function(Child)
		table.insert(RemovedChildren,Child)
	end)
	
	--Change the parents.
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	CuT2.Parent = nil
	CuT3.Parent = nil
	CuT4.Parent = nil
	
	--Assert the event was fired correctly.
	UnitTest:AssertSame(RemovedChildren[1],CuT2,"Change was incorrect.")
	UnitTest:AssertSame(RemovedChildren[2],CuT4,"Change was incorrect.")
	UnitTest:AssertSame(RemovedChildren[3],CuT3,"Change was incorrect.")
	UnitTest:AssertSame(RemovedChildren[4],nil,"Change was incorrect.")
end)

--[[
Tests the ClearAllChildren method.
--]]
NexusUnitTesting:RegisterUnitTest("ClearAllChildren",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT2
	
	--Clear the children.
	CuT1:ClearAllChildren()
	
	--Assert the parents are not set.
	UnitTest:AssertNil(CuT2.Parent,"Parent is still set.")
	UnitTest:AssertNil(CuT3.Parent,"Parent is still set.")
	UnitTest:AssertNil(CuT4.Parent,"Parent is still set.")
	
	--Assert the parents are locked.
	UnitTest:AssertErrors(function()
		CuT2.Parent = CuT1
	end,"Parent is not locked.")
	UnitTest:AssertErrors(function()
		CuT3.Parent = CuT1
	end,"Parent is not locked.")
	UnitTest:AssertErrors(function()
		CuT4.Parent = CuT1
	end,"Parent is not locked.")
end)

--[[
Tests the Clone method.
--]]
NexusUnitTesting:RegisterUnitTest("Clone",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	CuT3.CustomProperty1 = CuT3
	CuT3.CustomProperty2 = CuT4
	CuT3.CustomProperty3 = CuT2
	CuT3.CustomProperty4 = CuT1
	
	--Create a clone.
	local CuT5 = CuT2:Clone()
	UnitTest:AssertNotSame(CuT5,CuT2,"Instance not cloned.")
	UnitTest:AssertNil(CuT5.Parent,"Parent was set.")
	UnitTest:AssertNotNil(CuT5.TestContainer3,"No instance cloned.")
	UnitTest:AssertNotSame(CuT5.TestContainer3,CuT3,"Instance not cloned.")
	UnitTest:AssertNotNil(CuT5.TestContainer3.TestContainer4,"No instanced cloned.")
	UnitTest:AssertNotSame(CuT5.TestContainer3.TestContainer4,"Instance not cloned.")
	
	--Assert the copies aren't muted.
	CuT4.Name = "TestContainer5"
	UnitTest:AssertSame(CuT4.Name,"TestContainer5","Name was mutated.")
	UnitTest:AssertSame(CuT5.TestContainer3.TestContainer4.Name,"TestContainer4","Name was changed.")
	
	--Assert the original doesn't get mutated.
	CuT5.Name = "TestContainer6"
	UnitTest:AssertSame(CuT2.Name,"TestContainer2","Name was mutated.")
	UnitTest:AssertSame(CuT5.Name,"TestContainer6","Name wasn't changed.")
	
	--Assert the properties are properly set.
	UnitTest:AssertSame(CuT5.TestContainer3.CustomProperty1,CuT5.TestContainer3.CustomProperty1,"Property cloned incorrectly.")
	UnitTest:AssertSame(CuT5.TestContainer3.CustomProperty2,CuT5.TestContainer3.TestContainer4,"Property cloned incorrectly.")
	UnitTest:AssertSame(CuT5.TestContainer3.CustomProperty3,CuT5,"Property cloned incorrectly.")
	UnitTest:AssertSame(CuT5.TestContainer3.CustomProperty4,CuT1,"Property cloned incorrectly.")
end)

--[[
Tests the Destroy method.
--]]
NexusUnitTesting:RegisterUnitTest("Destroy",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Destroy CuT2.
	CuT2:Destroy()
	UnitTest:AssertSame(#CuT1:GetChildren(),0,"Children not cleared.")
	UnitTest:AssertSame(#CuT2:GetChildren(),0,"Children not cleared.")
	
	--Assert the instances are destroyed.
	UnitTest:AssertNil(CuT2.Parent,"Parent is not unset.")
	UnitTest:AssertNil(CuT3.Parent,"Parent is not unset.")
	UnitTest:AssertNil(CuT4.Parent,"Parent is not unset.")
	
	--Assert the parents are locked.
	UnitTest:AssertErrors(function()
		CuT2.Parent = CuT1
	end,"Parent is not locked.")
	UnitTest:AssertErrors(function()
		CuT3.Parent = CuT1
	end,"Parent is not locked.")
	UnitTest:AssertErrors(function()
		CuT4.Parent = CuT1
	end,"Parent is not locked.")
end)

--[[
Tests the FindFirstAncestor method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstAncestor",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the ancestory is correct.
	UnitTest:AssertSame(CuT1:FindFirstAncestor("TestContainer1"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstAncestor("TestContainer2"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstAncestor("TestContainer3"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstAncestor("TestContainer4"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestor("TestContainer1"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestor("TestContainer2"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestor("TestContainer3"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestor("TestContainer4"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestor("TestContainer1"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestor("TestContainer2"),CuT2,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestor("TestContainer3"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestor("TestContainer4"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestor("TestContainer1"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestor("TestContainer2"),CuT2,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestor("TestContainer3"),CuT3,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestor("TestContainer4"),nil,"Ancestor is incorrect.")
end)

--[[
Tests the FindFirstAncestorOfClass method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstAncestorOfClass",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the ancestory is correct.
	UnitTest:AssertSame(CuT1:FindFirstAncestorOfClass("NexusContainer"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestorOfClass("NexusContainer"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestorOfClass("NexusContainer"),CuT2,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestorOfClass("NexusContainer"),CuT3,"Ancestor is incorrect.")
end)

--[[
Tests the FindFirstAncestorWhichIsA method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstAncestorWhichIsA",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the ancestory is correct.
	UnitTest:AssertSame(CuT1:FindFirstAncestorWhichIsA("NexusContainer"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstAncestorWhichIsA("NexusInstance"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstAncestorWhichIsA("Part"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestorWhichIsA("NexusContainer"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestorWhichIsA("NexusInstance"),CuT1,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstAncestorWhichIsA("Part"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestorWhichIsA("NexusContainer"),CuT2,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestorWhichIsA("NexusInstance"),CuT2,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstAncestorWhichIsA("Part"),nil,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestorWhichIsA("NexusContainer"),CuT3,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestorWhichIsA("NexusInstance"),CuT3,"Ancestor is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstAncestorWhichIsA("Part"),nil,"Ancestor is incorrect.")
end)

--[[
Tests the FindFirstChild method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstChild",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer1"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer2"),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer3"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer4"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer1",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer2",true),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer3",true),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChild("TestContainer4",true),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer1"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer2"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer3"),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer4"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer1",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer2",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer3",true),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChild("TestContainer4",true),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer1"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer2"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer3"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer4"),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer1",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer2",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer3",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChild("TestContainer4",true),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer1"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer2"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer3"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer4"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer1",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer2",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer3",true),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChild("TestContainer4",true),nil,"Child is incorrect.")
end)

--[[
Tests the FindFirstChildOfClass method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstChildOfClass",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	UnitTest:AssertSame(CuT1:FindFirstChildOfClass("NexusContainer"),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChildOfClass("NexusContainer",true),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildOfClass("NexusContainer"),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildOfClass("NexusContainer",true),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildOfClass("NexusContainer"),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildOfClass("NexusContainer",true),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildOfClass("NexusContainer"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildOfClass("NexusContainer",true),nil,"Child is incorrect.")
end)

--[[
Tests the FindFirstChildOfClass method.
--]]
NexusUnitTesting:RegisterUnitTest("FindFirstChildWhichIsA",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	UnitTest:AssertSame(CuT1:FindFirstChildWhichIsA("NexusContainer"),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChildWhichIsA("NexusInstance"),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChildWhichIsA("Part"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT1:FindFirstChildWhichIsA("NexusContainer",true),CuT2,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildWhichIsA("NexusContainer"),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildWhichIsA("NexusInstance"),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildWhichIsA("Part"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT2:FindFirstChildWhichIsA("NexusContainer",true),CuT3,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildWhichIsA("NexusContainer"),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildWhichIsA("NexusInstance"),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildWhichIsA("Part"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT3:FindFirstChildWhichIsA("NexusContainer",true),CuT4,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildWhichIsA("NexusContainer"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildWhichIsA("NexusInstance"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildWhichIsA("Part"),nil,"Child is incorrect.")
	UnitTest:AssertSame(CuT4:FindFirstChildWhichIsA("NexusContainer",true),nil,"Child is incorrect.")
end)

--[[
Tests the GetChildren method.
--]]
NexusUnitTesting:RegisterUnitTest("GetChildren",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	AssertContentsSame(UnitTest,CuT1:GetChildren(),{CuT2},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT2:GetChildren(),{CuT3},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT3:GetChildren(),{CuT4},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT4:GetChildren(),{},"Children are incorrect.")
end)

--[[
Tests the GetDescendants method.
--]]
NexusUnitTesting:RegisterUnitTest("GetDescendants",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	AssertContentsSame(UnitTest,CuT1:GetDescendants(),{CuT2,CuT3,CuT4},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT2:GetDescendants(),{CuT3,CuT4},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT3:GetDescendants(),{CuT4},"Children are incorrect.")
	AssertContentsSame(UnitTest,CuT4:GetDescendants(),{},"Children are incorrect.")
end)

--[[
Tests the GetFullName method.
--]]
NexusUnitTesting:RegisterUnitTest("GetFullName",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the children are correct.
	UnitTest:AssertEquals(CuT1:GetFullName(),"TestContainer1","Name is incorrect.")
	UnitTest:AssertEquals(CuT2:GetFullName(),"TestContainer1.TestContainer2","Name is incorrect.")
	UnitTest:AssertEquals(CuT3:GetFullName(),"TestContainer1.TestContainer2.TestContainer3","Name is incorrect.")
	UnitTest:AssertEquals(CuT4:GetFullName(),"TestContainer1.TestContainer2.TestContainer3.TestContainer4","Name is incorrect.")
end)

--[[
Tests the IsAncestorOf method.
--]]
NexusUnitTesting:RegisterUnitTest("IsAncestorOf",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the ancestry is correct.
	UnitTest:AssertEquals(CuT1:IsAncestorOf(CuT1),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT1:IsAncestorOf(CuT2),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT1:IsAncestorOf(CuT3),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT1:IsAncestorOf(CuT4),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT2:IsAncestorOf(CuT1),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT2:IsAncestorOf(CuT2),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT2:IsAncestorOf(CuT3),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT2:IsAncestorOf(CuT4),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT3:IsAncestorOf(CuT1),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT3:IsAncestorOf(CuT2),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT3:IsAncestorOf(CuT3),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT3:IsAncestorOf(CuT4),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT4:IsAncestorOf(CuT1),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT4:IsAncestorOf(CuT2),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT4:IsAncestorOf(CuT3),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT4:IsAncestorOf(CuT4),false,"Ancestry is invalid.")
end)

--[[
Tests the IsDescendantOf method.
--]]
NexusUnitTesting:RegisterUnitTest("IsDescendantOf",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT3.Parent = CuT2
	CuT4.Parent = CuT3
	
	--Assert the ancestry is correct.
	UnitTest:AssertEquals(CuT1:IsDescendantOf(CuT1),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT1:IsDescendantOf(CuT2),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT1:IsDescendantOf(CuT3),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT1:IsDescendantOf(CuT4),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT2:IsDescendantOf(CuT1),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT2:IsDescendantOf(CuT2),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT2:IsDescendantOf(CuT3),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT2:IsDescendantOf(CuT4),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT3:IsDescendantOf(CuT1),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT3:IsDescendantOf(CuT2),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT3:IsDescendantOf(CuT3),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT3:IsDescendantOf(CuT4),false,"Ancestry is invalid.")
	UnitTest:AssertEquals(CuT4:IsDescendantOf(CuT1),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT4:IsDescendantOf(CuT2),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT4:IsDescendantOf(CuT3),true,"Ancestry is valid.")
	UnitTest:AssertEquals(CuT4:IsDescendantOf(CuT4),false,"Ancestry is invalid.")
end)

--[[
Tests the WaitForChild method.
--]]
NexusUnitTesting:RegisterUnitTest("WaitForChild",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	
	--Set the parents in a thread.
	delay(0.1,function()
		CuT3.Parent = CuT2
		CuT4.Parent = CuT3
	end)
	
	--Wait for the children or for the timeout.
	CuT1:WaitForChild("TestContainer2")
	CuT2:WaitForChild("TestContainer3")
	CuT3:WaitForChild("TestContainer4")
	CuT4:WaitForChild("TestContainer5",0.2)
end)

--[[
Tests the ConnectToHighestParent method.
--]]
NexusUnitTesting:RegisterUnitTest("ConnectToHighestParent",function(UnitTest)
	local CuT1,CuT2,CuT3,CuT4 = Setup()
	CuT2.Parent = CuT1
	CuT4.Parent = CuT2
	
	--Connect the event.
	local LastInvoke
	CuT4:ConnectToHighestParent("Changed",function(EventData)
		LastInvoke = EventData
	end)
	
	--Invoke the events and assert the event was connected.
	CuT1.Changed:Fire("Test1")
	CuT2.Changed:Fire("Test2")
	CuT3.Changed:Fire("Test3")
	CuT4.Changed:Fire("Test4")
	UnitTest:AssertEquals(LastInvoke,"Test1","Connected invoke was incorrect.")
	
	--Change the parent, invoke the events, and assert the event was connected.
	CuT4.Parent = CuT3
	CuT1.Changed:Fire("Test1")
	CuT2.Changed:Fire("Test2")
	CuT3.Changed:Fire("Test3")
	CuT4.Changed:Fire("Test4")
	UnitTest:AssertEquals(LastInvoke,"Test3","Connected invoke was incorrect.")
	
	--Unparent, invoke the events, and assert the event was connected.
	CuT4.Parent = nil
	CuT1.Changed:Fire("Test1")
	CuT2.Changed:Fire("Test2")
	CuT3.Changed:Fire("Test3")
	CuT4.Changed:Fire("Test4")
	UnitTest:AssertEquals(LastInvoke,"Test4","Connected invoke was incorrect.")
end)


return true