--[[
TheNexusAvenger

Tests the NexusCollapsableListFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusCollapsableListFrame = NexusPluginFramework:GetResource("UI.CollapsableList.NexusCollapsableListFrame")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusCollapsableListFrame.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusCollapsableListFrame","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusCollapsableListFrame","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusCollapsableListFrame","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
end)

--[[
Tests that the structure is valid.
--]]
NexusUnitTesting:RegisterUnitTest("Structure",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Container,CollapsableContainer = CuT:GetMainContainer(),CuT:GetCollapsableContainer()
	
	local Frame1,Frame2 = NexusPluginFramework.new("Frame"),NexusPluginFramework.new("Frame")
	local Frame3,Frame4 = NexusPluginFramework.new("Frame"),NexusPluginFramework.new("Frame")
	Frame1.Parent = CuT:GetMainContainer()
	Frame2.Parent = Frame1
	Frame3.Parent = CuT:GetCollapsableContainer()
	Frame4.Parent = Frame3
	
	--Assert the structure is correct.
	UnitTest:AssertSame(Frame1:GetWrappedInstance().Parent,Container:GetWrappedInstance(),"Parent is incorrect.")
	UnitTest:AssertSame(Frame2:GetWrappedInstance().Parent,Frame1:GetWrappedInstance(),"Parent is incorrect.")
	UnitTest:AssertSame(Frame3:GetWrappedInstance().Parent,CollapsableContainer:GetWrappedInstance(),"Parent is incorrect.")
	UnitTest:AssertSame(Frame4:GetWrappedInstance().Parent,Frame3:GetWrappedInstance(),"Parent is incorrect.")
end)

--[[
Tests the arrow visibility with nested visible frames.
--]]
NexusUnitTesting:RegisterUnitTest("ValidArrowVisibility",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Arrow = CuT.__Arrow
	
	--Add 3 frames.
	local Frame1,Frame2 = NexusPluginFramework.new("Frame"),NexusPluginFramework.new("Frame")
	local Frame3 = NexusPluginFramework.new("Frame")
	Frame1.Parent = CuT:GetCollapsableContainer()
	Frame2.Parent = Frame1
	Frame3.Parent = Frame2
	
	--Assert the arrow is visible.
	UnitTest:AssertTrue(Arrow.Visible,"Arrow is not visible.")
	
	--Hide frame 3 and assert it is not hidden.
	Frame3.Visible = false
	UnitTest:AssertTrue(Arrow.Visible,"Arrow is not visible.")
	
	--Hide frame 1 and assert it is hidden.
	Frame1.Visible = false
	UnitTest:AssertFalse(Arrow.Visible,"Arrow is visible.")
end)

--[[
Tests that the bounding size is valid.
--]]
NexusUnitTesting:RegisterUnitTest("BoundingSize",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	CuT.Size = UDim2.new(0,200,0,20)
	local WrappedInstance,CollapsableContainer = CuT:GetWrappedInstance(),CuT:GetCollapsableContainer()
	local Frame1,Frame2 = NexusPluginFramework.new("Frame"),NexusPluginFramework.new("Frame")
	Frame1.Size = UDim2.new(0,25,0,50)
	Frame2.Size = UDim2.new(0,-10,0,-10)
	
	--Assert the base size is correct.
	UnitTest:AssertEquals(CollapsableContainer.Size.Y,UDim.new(0,0),"Initial size is incorrect.")
	
	--Assert adding a frame changes the size correctly.
	Frame1.Parent = CuT:GetCollapsableContainer()
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,50),"Initial size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,70),"Container size is incorrect.")
	
	--Assert changing a frame changes the size correctly.
	Frame1.Size = UDim2.new(0,75,0,100)
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,100),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,120),"Container size is incorrect.")
	Frame1.Position = UDim2.new(0,25,0,50)
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,150),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,170),"Container size is incorrect.")
	
	--Assert adding and changing a child frame changes the size correctly.
	Frame2.Position = UDim2.new(0,50,0,150)
	Frame2.Parent = Frame1
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,200),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,220),"Container size is incorrect.")
	Frame2.Position = UDim2.new(0,50,0,200)
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,250),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,270),"Container size is incorrect.")
	Frame2.Size = UDim2.new(0,50,0,50)
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,300),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,320),"Container size is incorrect.")
	
	--Assert that re-parenting then deleteing frames changes the size correctly.
	Frame2.Parent = CuT:GetCollapsableContainer()
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,250),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,270),"Container size is incorrect.")
	Frame2:Destroy()
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,150),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,170),"Container size is incorrect.")
	Frame1:Destroy()
	UnitTest:AssertEquals(CuT.Size,UDim2.new(0,200,0,20),"Size was mutated.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-20,0,0),"Size is incorrect.")
	UnitTest:AssertEquals(WrappedInstance.Size,UDim2.new(0,200,0,20),"Container size is incorrect.")
end)

--[[
Tests the Disabled property.
--]]
NexusUnitTesting:RegisterUnitTest("Disabled",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Container,Arrow = CuT:GetMainContainer(),CuT.__Arrow
	local BaseColor = Arrow.ImageColor3
	CuT.Selected = true
	
	--Assert disabling the frame changes the arrow color and hides the selection color.
	CuT.Disabled = true
	UnitTest:AssertNotEquals(Arrow.ImageColor3,BaseColor,"Arrow color is not disabled.")
	UnitTest:AssertEquals(Container.BackgroundTransparency,1,"Transparency is incorrect.")
	
	--Assert enabling the frame changes the arrow color and hides the selection color.
	CuT.Disabled = false
	UnitTest:AssertEquals(Arrow.ImageColor3,BaseColor,"Arrow color is not disabled.")
	UnitTest:AssertEquals(Container.BackgroundTransparency,0,"Transparency is incorrect.")
end)

--[[
Tests the HighlightColor3 and Selected properties.
--]]
NexusUnitTesting:RegisterUnitTest("HighlightColor3AndSelected",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Container = CuT:GetMainContainer()
	
	--Assert the container doesn't have the background set.
	UnitTest:AssertEquals(Container.BackgroundTransparency,1,"Background is not hidden.")
	
	--Assert selecting the background changes the color and transparency.
	Container.BackgroundColor3 = Color3.new(1,0,0)
	CuT.Selected = true
	UnitTest:AssertEquals(Container.BackgroundTransparency,0,"Background is hidden.")
	UnitTest:AssertNotEquals(Container.BackgroundColor3,Color3.new(1,0,0),"Color was not changed.")
	
	--Assert changing the highlight color changes the background.
	CuT.HighlightColor3 = Color3.new(0,1,0)
	UnitTest:AssertEquals(Container.BackgroundColor3,Color3.new(0,1,0),"Color was not changed.")
	
	--Assert unselecting the frame hides the background.
	CuT.Selected = false
	UnitTest:AssertEquals(Container.BackgroundTransparency,1,"Background is not hidden.")
end)

--[[
Tests the ArrowVisible property.
--]]
NexusUnitTesting:RegisterUnitTest("ArrowVisible",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Arrow = CuT.__Arrow
	
	--Assert the arrow is hidden
	UnitTest:AssertFalse(Arrow.Visible,"Arrow is not hidden.")
	
	--Assert adding a frame doesn't make the arrow visible.
	local Frame = NexusPluginFramework.new("Frame")
	Frame.Parent = CuT
	UnitTest:AssertFalse(Arrow.Visible,"Arrow is not hidden.")
	
	--Assert adding a frame does makes the arrow visible.
	Frame.Parent = CuT:GetCollapsableContainer()
	UnitTest:AssertTrue(Arrow.Visible,"Arrow is hidden.")
	
	--Assert disabling arrow visibility hides the arrow.
	CuT.ArrowVisible = false
	UnitTest:AssertFalse(Arrow.Visible,"Arrow is not hidden.")
	
	--Assert enablign arrow visible shows the arrow.
	CuT.ArrowVisible = true
	UnitTest:AssertTrue(Arrow.Visible,"Arrow is hidden.")
	
	--Assert removing all children hides the arrow.
	CuT:GetCollapsableContainer():ClearAllChildren()
	UnitTest:AssertFalse(Arrow.Visible,"Arrow is not hidden.")
end)

--[[
Tests the Selectable property.
--]]
NexusUnitTesting:RegisterUnitTest("Selectable",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local Container = CuT:GetMainContainer()
	
	--Assert the container doesn't have the background set.
	UnitTest:AssertEquals(Container.BackgroundTransparency,1,"Background is not hidden.")
	
	--Assert making the frame unselectable doesn't change the colors.
	CuT.HighlightColor3 = Color3.new(0,1,0)
	CuT.Selectable = false
	CuT.Selected = true
	UnitTest:AssertEquals(Container.BackgroundTransparency,1,"Background is not hidden.")
	UnitTest:AssertNotEquals(Container.BackgroundColor3,Color3.new(0,1,0),"Color was changed.")
	
	--Assert making the frame selectable changes the colors.
	CuT.Selectable = true
	UnitTest:AssertEquals(Container.BackgroundTransparency,0,"Background is hidden.")
	UnitTest:AssertEquals(Container.BackgroundColor3,Color3.new(0,1,0),"Color was not changed.")
end)

--[[
Tests the Expanded property.
--]]
NexusUnitTesting:RegisterUnitTest("Expanded",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusCollapsableListFrame.new()
	local CollapsableContainer = CuT:GetCollapsableContainer()
	CollapsableContainer.Size = UDim2.new(1,-16,0,20)
	
	--Assert the frame is initially expanded.
	UnitTest:AssertTrue(CuT.Expanded,"Frame is not expanded.")
	UnitTest:AssertTrue(CollapsableContainer.Visible,"Frame is not expanded.")
	UnitTest:AssertEquals(CollapsableContainer.Size,UDim2.new(1,-16,0,20),"CollapsableContainer size changed (following assertions will fail).")
	UnitTest:AssertEquals(CuT:GetWrappedInstance().Size,UDim2.new(0,200,0,36),"Container size is incorrect.")
	
	--Assert the frame is collapsed when not expanded.
	CuT.Expanded = false
	UnitTest:AssertFalse(CuT.Expanded,"Frame is not expanded.")
	UnitTest:AssertFalse(CollapsableContainer.Visible,"Frame is not expanded.")
	UnitTest:AssertEquals(CuT:GetWrappedInstance().Size,UDim2.new(0,200,0,16),"Container size is incorrect.")
	
	--Assert the frame is expanded when expanded.
	CuT.Expanded = true
	UnitTest:AssertTrue(CuT.Expanded,"Frame is not expanded.")
	UnitTest:AssertTrue(CollapsableContainer.Visible,"Frame is not expanded.")
	UnitTest:AssertEquals(CuT:GetWrappedInstance().Size,UDim2.new(0,200,0,36),"Container size is incorrect.")
end)

--[[
Creates a series of list frames.
Disabled unless needed.
--]]
--[[
NexusUnitTesting:RegisterUnitTest("ManualTesting",function(UnitTest)
	--Create the screen gui.
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("StarterGui")
	
	--Create the background frame.
	local Frame = NexusPluginFramework.new("Frame")
	Frame.Size = UDim2.new(0,500,0,100)
	Frame.Parent = ScreenGui
	
	--Create the first list frame.
	local CuT1 = NexusCollapsableListFrame.new()
	CuT1.Size = UDim2.new(0,500,0,16)
	CuT1.Expanded = false
	CuT1.Parent = Frame
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 1 (Collapsed by default)"
	TextLabel.Parent = CuT1:GetMainContainer()
	
	--Create the second list frame.
	local CuT2 = NexusCollapsableListFrame.new()
	CuT2.Size = UDim2.new(1,0,0,16)
	CuT2.Disabled = true
	CuT2.Parent = CuT1:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 2 (Disabled)"
	TextLabel.Disabled = true
	TextLabel.Parent = CuT2:GetMainContainer()
	
	--Create the third list frame.
	local CuT3 = NexusCollapsableListFrame.new()
	CuT3.Size = UDim2.new(1,0,0,16)
	CuT3.ArrowVisible = false
	CuT3.Parent = CuT2:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 3 (Arrow not visible)"
	TextLabel.Parent = CuT3:GetMainContainer()
	
	--Create the fourth list frame.
	local CuT4 = NexusCollapsableListFrame.new()
	CuT4.Size = UDim2.new(1,0,0,30)
	CuT4.Selectable = false
	CuT4.Parent = CuT3:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 4 (Taller, unselectable)"
	TextLabel.Parent = CuT4:GetMainContainer()
	
	--Create the fifth list frame.
	local CuT5 = NexusCollapsableListFrame.new()
	CuT5.Size = UDim2.new(1,0,0,16)
	CuT5.Parent = CuT4:GetCollapsableContainer()
	
	local TextLabel = NexusPluginFramework.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.Text = "Frame 5 (No children)"
	TextLabel.Parent = CuT5:GetMainContainer()
	
	--Set up the events.
	CuT1.DoubleClicked:Connect(function() print("Frame 1 double clicked.") end)
	CuT1.DelayClicked:Connect(function() print("Frame 1 delayed clicked.") end)
	CuT2.DoubleClicked:Connect(function() print("Frame 2 double clicked.") end)
	CuT2.DelayClicked:Connect(function() print("Frame 2 delayed clicked.") end)
	CuT3.DoubleClicked:Connect(function() print("Frame 3 double clicked.") end)
	CuT3.DelayClicked:Connect(function() print("Frame 3 delayed clicked.") end)
	CuT4.DoubleClicked:Connect(function() print("Frame 4 double clicked.") end)
	CuT4.DelayClicked:Connect(function() print("Frame 4 delayed clicked.") end)
	CuT5.DoubleClicked:Connect(function() print("Frame 5 double clicked.") end)
	CuT5.DelayClicked:Connect(function() print("Frame 5 delayed clicked.") end)
	
	--Wait for the screen gui to be deleted.
	while ScreenGui.Parent do wait() end
end)
--]]



return true