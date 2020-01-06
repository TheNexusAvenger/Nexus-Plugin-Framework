--[[
TheNexusAvenger

Tests the NexusWrappedInstance class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")



--[[
Tests that the constructors work without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructors",function(UnitTest)
	--Create a frame.
	local Frame1 = Instance.new("Frame")
	Frame1.Name = "TestFrame"
	
	--Create a compontent under of testing using the main constructor.
	local CuT1 = NexusWrappedInstance.new(Frame1)
	UnitTest:AssertEquals(CuT1.ClassName,"NexusWrappedInstance","Class name is incorrect.")
	UnitTest:AssertEquals(CuT1.Name,"TestFrame","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT1),"TestFrame","Name is incorrect.")
	UnitTest:AssertEquals(CuT1:IsA("Frame"),true,"Wrapped instance isn't a frame.")
	UnitTest:AssertEquals(CuT1:IsA("TextLabel"),false,"Wrapped instance is a TextLabel.")
	UnitTest:AssertEquals(CuT1.IsA(CuT1,"NexusWrappedInstance"),true,"Wrapped instance isn't a NexusWrappedInstance.")
	UnitTest:AssertEquals(CuT1:GetWrappedInstance(),Frame1,"Wrapped instance is incorrect.")
	
	--Create 2 more components under testing from the caching builder.
	local CuT2 = NexusWrappedInstance.GetInstance(Frame1)
	local CuT3 = NexusWrappedInstance.GetInstance(Frame1)
	UnitTest:AssertSame(CuT2,CuT3,"Cached wrapped instance not used.")
	
	--Create a Frame by the string.
	local CuT4 = NexusWrappedInstance.GetInstance("Frame")
	UnitTest:AssertEquals(CuT4.Name,"Frame","Name is incorrect.")
	UnitTest:AssertEquals(CuT4.BackgroundColor3,"MainBackground","BackgroundColor3 is incorrect.")
	
	--Create 2 more components under testing from the main and caching builder.
	local Frame2 = Instance.new("Frame")
	local CuT5 = NexusWrappedInstance.new(Frame2)
	local CuT6 = NexusWrappedInstance.GetInstance(Frame2)
	UnitTest:AssertSame(CuT5,CuT6,"Cached wrapped instance not used.")
	
	--Test the main constructor with a string.
	local CuT7 = NexusWrappedInstance.new("Frame")
	UnitTest:AssertEquals(CuT7.Name,"Frame","Name is incorrect.")
	UnitTest:AssertEquals(CuT7.BackgroundColor3,"MainBackground","BackgroundColor3 is incorrect.")
end)

--[[
Tests that the wrapped instances are garbage collected.
--]]
NexusUnitTesting:RegisterUnitTest("GarbageCollection",function(UnitTest)
	--Require a new copy.
	local NexusPluginFramework = NexusUnitTesting.Util.DependencyInjector.Require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
	local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
	
	--[[
	Returns the amount of stored instances.
	--]]
	local function GetInstanceCount()
		local Count,CountWithReferences = 0,0
		for Ins,WrappedIns in pairs(NexusWrappedInstance.CachedInstances) do
			Count = Count + 1
			if Ins == WrappedIns:GetWrappedInstance() then
				CountWithReferences = CountWithReferences + 1
			end
		end
		
		return Count,CountWithReferences
	end
	
	--Assert nothing is cached (empty version).
	local WrappedInstanceCount,_ = GetInstanceCount()
	UnitTest:AssertEquals(WrappedInstanceCount,0,"Cache is empty (test is invalid.)")
	
	--Create and store 10 instances.
	local InstanceReferences = {}
	for i = 1,10 do
		local Ins = Instance.new("Frame")
		local WrappedIns = NexusWrappedInstance.new(Ins)
		table.insert(InstanceReferences,WrappedIns)
	end
	
	--Assert the instances are cached.
	local WrappedInstanceCount,WrappedInstanceCountWithReferences = GetInstanceCount()
	UnitTest:AssertEquals(WrappedInstanceCount,10,"Cache is incorrect size.")
	UnitTest:AssertEquals(WrappedInstanceCountWithReferences,10,"Cache is incorrect size.")
	
	--Clear the references except the first and second.
	local FirstReference = InstanceReferences[1]
	local SecondReference = InstanceReferences[2]
	for i = 2,10 do
		InstanceReferences[i]:Destroy()
	end
	InstanceReferences = {}
	
	--Wait up to 60 seconds for the cache to garbage collect.
	for i = 1,600 do
		local WrappedInstanceCount,WrappedInstanceCountWithReferences = GetInstanceCount()
		if WrappedInstanceCount <= 2 and WrappedInstanceCountWithReferences <= 2 then break end
		wait(0.1)
	end
	
	--Assert the cache was correctly garbage collected.
	local WrappedInstanceCount,WrappedInstanceCountWithReferences = GetInstanceCount()
	UnitTest:AssertNotNil(SecondReference:GetWrappedInstance(),"Wrapped instance was garbage collected.")
	UnitTest:AssertEquals(WrappedInstanceCount,2,"Cache is incorrect size (Garbage collection may not have ran).")
	UnitTest:AssertEquals(WrappedInstanceCountWithReferences,2,"Cache is incorrect size (Garbage collection may not have ran).")
	UnitTest:AssertSame(NexusWrappedInstance.GetInstance(FirstReference:GetWrappedInstance()),FirstReference,"Cache object is incorrect.")
end)

--[[
Tests adding children.
--]]
NexusUnitTesting:RegisterUnitTest("Children",function(UnitTest)
	--Create the components under testing.
	local Frame1,Frame2 = Instance.new("Frame"),Instance.new("Frame")
	local CuT1,CuT2 = NexusWrappedInstance.new(Frame1),NexusWrappedInstance.new(Frame2)
	CuT2.Parent = CuT1
	
	--Assert the class names are correct.
	UnitTest:AssertEquals(CuT1.ClassName,"NexusWrappedInstance","ClassName not correct.")
	UnitTest:AssertEquals(CuT2.ClassName,"NexusWrappedInstance","ClassName not correct.")
	UnitTest:AssertEquals(CuT1.Frame.ClassName,"NexusWrappedInstance","ClassName not correct.")
	UnitTest:AssertEquals(CuT1:GetChildren()[1].ClassName,"NexusWrappedInstance","ClassName not correct.")
end)

--[[
Tests that indexing is passed through from the wrapped instance.
--]]
NexusUnitTesting:RegisterUnitTest("IndexPassthrough",function(UnitTest)
	--Create the component under testing.
	local Frame = Instance.new("Frame")
	local CuT = NexusWrappedInstance.new(Frame)
	
	--Assert the indexes are passed through.
	UnitTest:AssertEquals(CuT.Selectable,Frame.Selectable,"Selectable not passed through.")
end)

--[[
Tests that changes are replicated to the wrapped instance.
--]]
NexusUnitTesting:RegisterUnitTest("ReplicatingToInstance",function(UnitTest)
	--Create the component under testing.
	local Frame1 = Instance.new("Frame")
	local Frame2 = Instance.new("Frame")
	local CuT1,CuT2 = NexusWrappedInstance.new(Frame1),NexusWrappedInstance.new(Frame2)
	
	--Assert the changes are passed through.
	CuT1.Name = "TestFrame"
	CuT1.Selectable = true
	CuT1.Parent = CuT2
	UnitTest:AssertEquals(CuT1.Name,"TestFrame","Name not set.")
	UnitTest:AssertEquals(Frame1.Name,"TestFrame","Name not replicated.")
	UnitTest:AssertEquals(CuT1.Selectable,true,"Selectable not set.")
	UnitTest:AssertEquals(Frame1.Selectable,true,"Selectable not replicated.")
	UnitTest:AssertEquals(CuT1.Parent,CuT2,"Parent not set.")
	UnitTest:AssertEquals(Frame1.Parent,Frame2,"Parent not replicated.")
	
	--Assert changing the parent to nil is passed through.
	CuT1.Parent = nil
	UnitTest:AssertEquals(CuT1.Parent,nil,"Parent not unset.")
	UnitTest:AssertEquals(Frame1.Parent,nil,"Parent unsetting not replicated.")
end)


--[[
Tests backwards replication for wrapped instances to the NexusWrappedInstance.
--]]
NexusUnitTesting:RegisterUnitTest("ReplicatingFromInstance",function(UnitTest)
	--Create the component under testing.
	local NameChanged,SelectableChanged = false,false
	local Frame = Instance.new("Frame")
	local CuT = NexusWrappedInstance.new(Frame)
	
	--Set up the changed events.
	CuT:GetPropertyChangedSignal("Name"):Connect(function()
		NameChanged = true
	end)
	CuT:GetPropertyChangedSignal("Selectable"):Connect(function()
		SelectableChanged = true
	end)
	
	--Change the variables.
	Frame.Name = "TestFrame"
	Frame.Selectable = true
	
	--Assert the change signals were fired.
	UnitTest:AssertTrue(NameChanged,"Changed signal for name not fired.")
	UnitTest:AssertTrue(SelectableChanged,"Changed signal for selectable not fired.")
	
	--Assert the changes are passed through.
	UnitTest:AssertEquals(CuT.Name,"TestFrame","Name not set.")
	UnitTest:AssertEquals(Frame.Name,"TestFrame","Name not replicated.")
	UnitTest:AssertEquals(CuT.Selectable,true,"Selectable not set.")
	UnitTest:AssertEquals(Frame.Selectable,true,"Selectable not replicated.")
end)


--[[
Tests that the instance structure is correct for parenting.
--]]
NexusUnitTesting:RegisterUnitTest("InstanceStructure",function(UnitTest)
	--Create 4 frames.
	local Frame1,Frame2 = Instance.new("Frame"),Instance.new("Frame")
	local Frame3,Frame4 = Instance.new("Frame"),Instance.new("Frame")
	
	--Create 4 components under testing.
	local CuT1,CuT2 = NexusWrappedInstance.new(Frame1),NexusWrappedInstance.new(Frame2)
	local CuT3,CuT4 = NexusWrappedInstance.new(Frame3),NexusWrappedInstance.new(Frame4)
	
	--Set the parents.
	CuT2.Parent = CuT1
	CuT3.Parent = CuT1
	CuT4.Parent = CuT3
	
	--Assert the parents of the frames is correct.
	UnitTest:AssertEquals(Frame1.Parent,nil,"Parent is incorrect.")
	UnitTest:AssertEquals(Frame2.Parent,Frame1,"Parent is incorrect.")
	UnitTest:AssertEquals(Frame3.Parent,Frame1,"Parent is incorrect.")
	UnitTest:AssertEquals(Frame4.Parent,Frame3,"Parent is incorrect.")
end)

--[[
Tests index wrapping from properties and functions.
--]]
NexusUnitTesting:RegisterUnitTest("InstanceWrapping",function(UnitTest)
	--Create 2 frames.
	local Frame1,Frame2 = Instance.new("Frame"),Instance.new("Frame")
	Frame2.Parent = Frame1
	
	--Create the main component under testing.
	local CuT = NexusWrappedInstance.new(Frame1)
	
	--Assert the children are index and are wrapped instances.
	UnitTest:AssertNotNil(CuT.Frame,"Frame not indexable.")
	UnitTest:AssertEquals(CuT.Frame.ClassName,"NexusWrappedInstance","Frame not wrapped.")
	
	--Assert a function returns a wrapped instance.
	UnitTest:AssertNotEquals(CuT:__getindex("GetChildren",nil),CuT.GetChildren,"Built-in GetChildren method returned (unit test invalid).")
	UnitTest:AssertEquals(CuT:__getindex("GetChildren",nil)(CuT)[1].ClassName,"NexusWrappedInstance","Wrapped instance not returned.")
end)

--[[
Tests index unwrapping to properties and functions.
--]]
NexusUnitTesting:RegisterUnitTest("InstanceUnwrapping",function(UnitTest)
	--Create 2 frames.
	local Frame1,Frame2 = Instance.new("Frame"),Instance.new("Frame")
	Frame2.Parent = Frame1
	
	--Create the components under testing.
	local CuT1,CuT2 = NexusWrappedInstance.GetInstance(Frame1),NexusWrappedInstance.GetInstance(Frame2)
	
	--Assert unwrapping an instance as a property.
	CuT1.NextSelectionUp = CuT2
	UnitTest:AssertEquals(Frame1.NextSelectionUp,Frame2,"Property not set.")
	
	--Assert unwrapping an instance as a function.
	UnitTest:AssertNotEquals(CuT1:__getindex("IsAncestorOf",nil),CuT1.IsAncestorOf,"Built-in IsAncestorOf method returned (unit test invalid).")
	UnitTest:AssertTrue(CuT1:__getindex("IsAncestorOf",nil)(CuT1,CuT2),"Frame 2 is not an ancestor of Frame 1.")
end)

--[[
Tests string Color3 propreties being set.
--]]
NexusUnitTesting:RegisterUnitTest("StringColors",function(UnitTest)
	--Create the component under testing.
	local Frame = Instance.new("Frame")
	local CuT = NexusWrappedInstance.new(Frame)
	
	--Set the colors of the border and background.
	CuT.BackgroundColor3 = Color3.new(1,0,0)
	CuT.BorderColor3 = "LinkText"
	
	--Assert the colors are correct.
	UnitTest:AssertClose(Frame.BackgroundColor3,Color3.new(1,0,0),"Colors aren't close.")
	UnitTest:AssertClose(Frame.BorderColor3,Color3.new(0.207843,0.709804,1),0.001,"Colors aren't close.")
	
	--Assert selecting the frame changes the colors.
	CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.ButtonText
	local StartColor = Frame.BackgroundColor3
	CuT.Selected = true
	UnitTest:AssertNotEquals(Frame.BackgroundColor3,StartColor,"Colors not changed.")
	
	--Assert disabling the frame changes the colors.
	CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.ButtonText
	local StartColor = Frame.BackgroundColor3
	CuT.Selected = false
	CuT.Disabled = true
	UnitTest:AssertNotEquals(Frame.BackgroundColor3,StartColor,"Colors not changed.")
	
	--Assert selecting the frame doesn't change the colors when disabled.
	CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.ButtonText
	local StartColor = Frame.BackgroundColor3
	CuT.Selected = true
	UnitTest:AssertEquals(Frame.BackgroundColor3,StartColor,"Colors was changed.")
end)

--[[
Tests the Clone method.
--]]
NexusUnitTesting:RegisterUnitTest("Clone",function(UnitTest)
	--Create 3 frames.
	local Frame1,Frame2,Frame3 = Instance.new("Frame"),Instance.new("Frame"),Instance.new("Frame")
	
	--Create the components under testing.
	local CuT1,CuT2,CuT3 = NexusWrappedInstance.GetInstance(Frame1),NexusWrappedInstance.GetInstance(Frame2),NexusWrappedInstance.GetInstance(Frame3)
	CuT2.Parent = CuT1
	CuT2.NextSelectionLeft = CuT1
	CuT3.NextSelectionLeft = CuT3
	CuT3.Parent = CuT2
	
	--Clone the second component under testing.
	local CuT4 = CuT2:Clone()
	UnitTest:AssertNotEquals(CuT4:GetWrappedInstance(),Frame2,"Wrapped instance not cloned.")
	UnitTest:AssertNotEquals(CuT4:FindFirstChild("Frame"),Frame3,"Child not cloned.")
	UnitTest:AssertNotNil(CuT4:FindFirstChild("Frame"),"Child not cloned.")
	UnitTest:AssertNotEquals(CuT4:FindFirstChild("Frame"):GetWrappedInstance(),Frame3,"Wrapped instance not cloned.")
end)



return true