--[[
TheNexusAvenger

Tests the NexusBoundingSizeConstraint class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusBoundingSizeConstraint = NexusPluginFramework:GetResource("UI.Constraint.NexusBoundingSizeConstraint")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Assert a wrapped instance works.
	local CuT = NexusBoundingSizeConstraint.new(NexusWrappedInstance.GetInstance("Frame"))
	UnitTest:AssertEquals(CuT.ClassName,"NexusBoundingSizeConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusBoundingSizeConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusBoundingSizeConstraint","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
	
	--Assert a Roblox instance works.
	local CuT = NexusBoundingSizeConstraint.new(Instance.new("Frame"))
	UnitTest:AssertEquals(CuT.ClassName,"NexusBoundingSizeConstraint","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusBoundingSizeConstraint","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusBoundingSizeConstraint","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
end)

--[[
Tests that the bounding size with regular frames is correct.
--]]
NexusUnitTesting:RegisterUnitTest("BoundingSize",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = ContainerFrame
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = NexusWrappedInstance.GetInstance("Frame")
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size not correct.")
	
	--Assert adding a new frame changes the size.
	SubFrame3.Parent = ContainerFrame
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,250,0,250),"Size not correct.")
	
	--Assert changing the size changes the bounding size.
	SubFrame1.Size = UDim2.new(0,250,0,250)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0,290),"Size not correct.")
	
	--Assert changing the position changes the bounding size.
	SubFrame2.Position = UDim2.new(0,400,0,400)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,500,0,450),"Size not correct.")
	
	--Assert removing a frame changes the bounding size.
	SubFrame2.Parent = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0,290),"Size not correct.")
	
	--Assert hiding a frame changes the bounding size.
	SubFrame1.Visible = false
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,250,0,250),"Size not correct.")
end)

--[[
Tests the bounding size with visible frames in inivisble frames
--]]
NexusUnitTesting:RegisterUnitTest("BoundingSizeNestedVisibleFrames",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = SubFrame1
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = SubFrame2
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,290,0,340),"Size not correct.")
	
	--Assert hiding frame 2 changes the bounding size.
	SubFrame2.Visible = false
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,70,0,140),"Size not correct.")
end)

--[[
Tests the Destroy method.
--]]
NexusUnitTesting:RegisterUnitTest("Destroy",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = ContainerFrame
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = NexusWrappedInstance.GetInstance("Frame")
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size not correct.")
	CuT:Destroy()
	
	--Assert adding a new frame after destorying doesn't change the size.
	SubFrame3.Parent = ContainerFrame
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size changed.")
	
	--Assert changing the size after destorying doesn't change the bounding size.
	SubFrame1.Size = UDim2.new(0,250,0,250)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size changed.")
	
	--Assert changing the position after destorying doesn't change the bounding size.
	SubFrame2.Position = UDim2.new(0,400,0,400)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size changed.")
	
	--Assert removing a frame after destorying doesn't change the bounding size.
	SubFrame2.Parent = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size changed.")
end)

--[[
Tests the SizeXOverride property.
--]]
NexusUnitTesting:RegisterUnitTest("SizeXOverride",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = ContainerFrame
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = NexusWrappedInstance.GetInstance("Frame")
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size not correct.")
	
	--Assert setting the SizeXOverride overrides the size.
	CuT.SizeXOverride = UDim.new(0.2,240)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.2,240,0,140),"Size not correct.")
	
	--Assert adding a new frame after destorying doesn't change the size.
	SubFrame3.Parent = ContainerFrame
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.2,240,0,250),"Size not correct.")
	
	--Assert changing the size after destorying doesn't change the bounding size.
	SubFrame1.Size = UDim2.new(0,250,0,250)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.2,240,0,290),"Size not correct.")
	
	--Assert changing the position after destorying doesn't change the bounding size.
	SubFrame2.Position = UDim2.new(0,400,0,400)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.2,240,0,450),"Size not correct.")
	
	--Assert removing a frame after destorying doesn't change the bounding size.
	SubFrame2.Parent = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.2,240,0,290),"Size not correct.")
	
	--Assert unsetting the SizeXOverride changes the size.
	CuT.SizeXOverride = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0,290),"Size not correct.")
end)

--[[
Tests the SizeYOverride property.
--]]
NexusUnitTesting:RegisterUnitTest("SizeYOverride",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = ContainerFrame
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = NexusWrappedInstance.GetInstance("Frame")
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size not correct.")
	
	--Assert setting the SizeYOverride overrides the size.
	CuT.SizeYOverride = UDim.new(0.2,240)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0.2,240),"Size not correct.")
	
	--Assert adding a new frame changes the size.
	SubFrame3.Parent = ContainerFrame
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,250,0.2,240),"Size not correct.")
	
	--Assert changing the size changes the bounding size.
	SubFrame1.Size = UDim2.new(0,250,0,250)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0.2,240),"Size not correct.")
	
	--Assert changing the position changes the bounding size.
	SubFrame2.Position = UDim2.new(0,400,0,400)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,500,0.2,240),"Size not correct.")
	
	--Assert removing a frame changes the bounding size.
	SubFrame2.Parent = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0.2,240),"Size not correct.")
	
	--Assert unsetting the SizeYOverride changes the size.
	CuT.SizeYOverride = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0,290),"Size not correct.")
end)

--[[
Tests the SizeXOverride and SizeYOverride properties together.
--]]
NexusUnitTesting:RegisterUnitTest("SizeXOverrideAndSizeYOverride",function(UnitTest)
	--Create a test frame with contents.
	local ContainerFrame = NexusWrappedInstance.GetInstance("Frame")
	local SubFrame1,SubFrame2,SubFrame3 = NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame"),NexusWrappedInstance.GetInstance("Frame")
	SubFrame1.Size = UDim2.new(0,50,0,100)
	SubFrame1.Position = UDim2.new(0,20,0,40)
	SubFrame1.Parent = ContainerFrame
	SubFrame2.Size = UDim2.new(0,100,0,50)
	SubFrame2.Position = UDim2.new(0,20,0,50)
	SubFrame2.Parent = ContainerFrame
	SubFrame3.Size = UDim2.new(0,50,0,50)
	SubFrame3.Position = UDim2.new(0,200,0,200)
	SubFrame3.Parent = NexusWrappedInstance.GetInstance("Frame")
	
	--Create the constraint and assert the size is correct.
	local CuT = NexusBoundingSizeConstraint.new(ContainerFrame)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,120,0,140),"Size not correct.")
	
	--Assert setting the SizeXOverride and SizeYOverride overrides the size.
	CuT.SizeXOverride = UDim.new(0.1,120)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0,140),"Size not correct.")
	CuT.SizeYOverride = UDim.new(0.2,240)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0.2,240),"Size not correct.")
	
	--Assert adding a new frame changes the size.
	SubFrame3.Parent = ContainerFrame
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0.2,240),"Size not correct.")
	
	--Assert changing the size changes the bounding size.
	SubFrame1.Size = UDim2.new(0,250,0,250)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0.2,240),"Size not correct.")
	
	--Assert changing the position changes the bounding size.
	SubFrame2.Position = UDim2.new(0,400,0,400)
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0.2,240),"Size not correct.")
	
	--Assert removing a frame changes the bounding size.
	SubFrame2.Parent = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0.1,120,0.2,240),"Size not correct.")
	
	--Assert unsetting the SizeYOverride and SizeYOverride changes the size.
	CuT.SizeXOverride = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0.2,240),"Size not correct.")
	CuT.SizeYOverride = nil
	UnitTest:AssertEquals(ContainerFrame.Size,UDim2.new(0,270,0,290),"Size not correct.")
end)



return true