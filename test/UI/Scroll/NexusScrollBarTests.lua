--[[
TheNexusAvenger

Tests the NexusScrollBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusScrollBar = NexusPluginFramework:GetResource("UI.Scroll.NexusScrollBar")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusScrollBar.new("Qt5",Enum.Axis.X)
	UnitTest:AssertEquals(CuT.ClassName,"NexusScrollBar","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusScrollBar","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusScrollBar","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
end)

--[[
Test that the structure is valid for a Qt5 X-axis scroll bar.
--]]
NexusUnitTesting:RegisterUnitTest("Qt5XAxis",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusScrollBar.new("Qt5",Enum.Axis.X)
	CuT:__SetChangedOverride("AbsoluteSize",function() end)
	CuT.Size = UDim2.new(0,400,0,20)
	CuT.AbsoluteSize = Vector2.new(400,20)
	
	local WrappedFrame = CuT:GetWrappedInstance()
	local ScrollFrame = WrappedFrame:FindFirstChild("ScrollBar")
	local LeftButton,RightButton = WrappedFrame:FindFirstChild("Button1"),WrappedFrame:FindFirstChild("Button2")
	
	--Assert the buttons are correct.
	UnitTest:AssertEquals(LeftButton.AbsoluteSize,Vector2.new(20,20),"Button size is incorrect.")
	UnitTest:AssertEquals(LeftButton.AbsolutePosition,Vector2.new(0,0),"Button position is incorrect.")
	UnitTest:AssertEquals(RightButton.AbsoluteSize,Vector2.new(20,20),"Button size is incorrect.")
	UnitTest:AssertEquals(RightButton.AbsolutePosition,Vector2.new(380,0),"Button position is incorrect.")
	
	--Assert the scroll bar is correct.
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,179,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,21,0,0),"Scroll bar position is incorrect.")
	
	--Set the border size pixel and assert the scroll bar is correct.
	CuT.BorderSizePixel = 5
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,175,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,25,0,0),"Scroll bar position is incorrect.")
	CuT.BorderSizePixel = 0
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,180,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,20,0,0),"Scroll bar position is incorrect.")
	
	--Set the relative position and assert the scroll bar is correct.
	CuT.RelativePosition = 1/3
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,180,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,80,0,0),"Scroll bar position is incorrect.")
	
	--Set the relative size and assert the scroll bar is correct.
	CuT.RelativeSize = 0.5
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,360,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,20,0,0),"Scroll bar position is incorrect.")
	CuT.RelativeSize = 4
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,90,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,110,0,0),"Scroll bar position is incorrect.")
	
	--Set the size to be too small.
	CuT.Size = UDim2.new(0,30,0,20)
	CuT.AbsoluteSize = Vector2.new(30,20)
	UnitTest:AssertFalse(LeftButton.Visible,"Button is visible")
	UnitTest:AssertFalse(RightButton.Visible,"Button is visible")
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(0,7,1,0),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,7,0,0),"Scroll bar position is incorrect.")
end)

--[[
Test that the structure is valid for a Qt5 Y-axis scroll bar.
--]]
NexusUnitTesting:RegisterUnitTest("Qt5YAxis",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusScrollBar.new("Qt5",Enum.Axis.Y)
	CuT:__SetChangedOverride("AbsoluteSize",function() end)
	CuT.Size = UDim2.new(0,20,0,400)
	CuT.AbsoluteSize = Vector2.new(20,400)
	
	local WrappedFrame = CuT:GetWrappedInstance()
	local ScrollFrame = WrappedFrame:FindFirstChild("ScrollBar")
	local LeftButton,RightButton = WrappedFrame:FindFirstChild("Button1"),WrappedFrame:FindFirstChild("Button2")
	
	--Assert the buttons are correct.
	UnitTest:AssertEquals(LeftButton.AbsoluteSize,Vector2.new(20,20),"Button size is incorrect.")
	UnitTest:AssertEquals(LeftButton.AbsolutePosition,Vector2.new(0,0),"Button position is incorrect.")
	UnitTest:AssertEquals(RightButton.AbsoluteSize,Vector2.new(20,20),"Button size is incorrect.")
	UnitTest:AssertEquals(RightButton.AbsolutePosition,Vector2.new(0,380),"Button position is incorrect.")
	
	--Assert the scroll bar is correct.
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,179),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,21),"Scroll bar position is incorrect.")
	
	--Set the border size pixel and assert the scroll bar is correct.
	CuT.BorderSizePixel = 5
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,175),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,25),"Scroll bar position is incorrect.")
	CuT.BorderSizePixel = 0
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,180),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,20),"Scroll bar position is incorrect.")
	
	--Set the relative position and assert the scroll bar is correct.
	CuT.RelativePosition = 1/3
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,180),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,80),"Scroll bar position is incorrect.")
	
	--Set the relative size and assert the scroll bar is correct.
	CuT.RelativeSize = 0.5
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,360),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,20),"Scroll bar position is incorrect.")
	CuT.RelativeSize = 4
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,90),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,110),"Scroll bar position is incorrect.")
	
	--Set the size to be too small.
	CuT.Size = UDim2.new(0,20,0,30)
	CuT.AbsoluteSize = Vector2.new(20,30)
	UnitTest:AssertFalse(LeftButton.Visible,"Button is visible")
	UnitTest:AssertFalse(RightButton.Visible,"Button is visible")
	UnitTest:AssertEquals(ScrollFrame.Size,UDim2.new(1,0,0,7),"Scroll bar size is incorrect.")
	UnitTest:AssertEquals(ScrollFrame.Position,UDim2.new(0,0,0,7),"Scroll bar position is incorrect.")
end)

--[[
Creates 2 scroll bars in StarterGui.
Disabled unless needed.
--]]
--[[
NexusUnitTesting:RegisterUnitTest("ManualTesting",function(UnitTest)
	--Create the screen gui.
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("StarterGui")
	
	--Create the frame.
	local Frame = NexusPluginFramework.new("Frame")
	Frame.Size = UDim2.new(0,420,0,420)
	Frame.Parent = ScreenGui
	
	--Create the scroll bars.
	local CuT1 = NexusScrollBar.new("Qt5",Enum.Axis.X)
	CuT1.Size = UDim2.new(0,400,0,20)
	CuT1.Position = UDim2.new(0,0,0,400)
	CuT1.Parent = Frame
	
	local CuT2 = NexusScrollBar.new("Qt5",Enum.Axis.Y)
	CuT2.Size = UDim2.new(0,20,0,400)
	CuT2.Position = UDim2.new(0,400,0,0)
	CuT2.Parent = Frame
	
	--Print the events.
	CuT1.Button1Pressed:Connect(function() print("Left invoked.") end)
	CuT1.Button2Pressed:Connect(function() print("Right invoked.") end)
	CuT2.Button1Pressed:Connect(function() print("Up invoked.") end)
	CuT2.Button2Pressed:Connect(function() print("Down invoked.") end)
	
	--Wait for the screen gui to be deleted.
	while ScreenGui.Parent do wait() end
end)
--]]


return true