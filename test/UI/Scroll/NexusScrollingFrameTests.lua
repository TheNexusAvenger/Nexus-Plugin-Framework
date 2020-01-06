--[[
TheNexusAvenger

Tests the NexusScrollBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusScrollingFrame = NexusPluginFramework:GetResource("UI.Scroll.NexusScrollingFrame")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusScrollingFrame.new("Native")
	UnitTest:AssertEquals(CuT.ClassName,"NexusScrollingFrame","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusScrollingFrame","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusScrollingFrame","Name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Children aren't hidden.")
end)

--[[
Tests that the scrollbars are set up correctly for the Qt5 theme.
--]]
NexusUnitTesting:RegisterUnitTest("Qt5ThemeSetup",function(UnitTest)
	--Create a container frame and the component under testing.
	local Frame = Instance.new("Frame")
	local WrappedFrame = NexusPluginFramework.new(Frame)
	local CuT = NexusScrollingFrame.new("Qt5")
	CuT.Size = UDim2.new(0,200,0,200)
	CuT.Parent = WrappedFrame
	
	--Assert the scroll bar adorn is hidden.
	UnitTest:AssertEquals(#Frame:GetChildren(),2,"Scroll bar adorn doesn't exist.")
	UnitTest:AssertEquals(#WrappedFrame:GetChildren(),1,"Scroll bar adorn isn't hidden.")
	
	--Get the scroll bars.
	local ScrollBarAdorn = Frame:FindFirstChild("ScrollBarAdorn")
	local HorizontalScrollBar = ScrollBarAdorn:FindFirstChild("HorizontalScrollBar")
	local VerticalScrollBar = ScrollBarAdorn:FindFirstChild("VerticalScrollBar")
	
	--Assert the scroll bars are not shown for a canvas size less than frame size.
	CuT.CanvasSize = UDim2.new(0,150,0,150)
	UnitTest:AssertFalse(HorizontalScrollBar.Visible,"Scroll bar is visible.")
	UnitTest:AssertFalse(VerticalScrollBar.Visible,"Scroll bar is visible.")
	
	--Assert the scroll bars are correct for only the horizontal scroll bar.
	CuT.CanvasSize = UDim2.new(0,300,0,150)
	UnitTest:AssertTrue(HorizontalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertFalse(VerticalScrollBar.Visible,"Scroll bar is visible.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsoluteSize,Vector2.new(198,16),"Size is incorrect.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsolutePosition,Vector2.new(1,184),"Position is incorrect.")
	
	--Assert the scroll bars are correct for only the vertical scroll bar on the right.
	CuT.CanvasSize = UDim2.new(0,150,0,300)
	CuT.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	UnitTest:AssertFalse(HorizontalScrollBar.Visible,"Scroll bar is visible.")
	UnitTest:AssertTrue(VerticalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsoluteSize,Vector2.new(16,198),"Size is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsolutePosition,Vector2.new(184,1),"Position is incorrect.")
	
	--Assert the scroll bars are correct for only the vertical scroll bar on the left.
	CuT.CanvasSize = UDim2.new(0,150,0,300)
	CuT.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
	UnitTest:AssertFalse(HorizontalScrollBar.Visible,"Scroll bar is visible.")
	UnitTest:AssertTrue(VerticalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsoluteSize,Vector2.new(16,198),"Size is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsolutePosition,Vector2.new(0,1),"Position is incorrect.")
	
	--Assert that both scroll bars are correct for both with vertical on the right.
	CuT.CanvasSize = UDim2.new(0,300,0,300)
	CuT.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	UnitTest:AssertTrue(HorizontalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertTrue(VerticalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsoluteSize,Vector2.new(182,16),"Size is incorrect.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsolutePosition,Vector2.new(1,184),"Position is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsoluteSize,Vector2.new(16,182),"Size is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsolutePosition,Vector2.new(184,1),"Position is incorrect.")
	
	--Assert that both scroll bars are correct for both with vertical on the left.
	CuT.CanvasSize = UDim2.new(0,300,0,300)
	CuT.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
	UnitTest:AssertTrue(HorizontalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertTrue(VerticalScrollBar.Visible,"Scroll bar isn't visible.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsoluteSize,Vector2.new(182,16),"Size is incorrect.")
	UnitTest:AssertEquals(HorizontalScrollBar.AbsolutePosition,Vector2.new(17,184),"Position is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsoluteSize,Vector2.new(16,182),"Size is incorrect.")
	UnitTest:AssertEquals(VerticalScrollBar.AbsolutePosition,Vector2.new(0,1),"Position is incorrect.")
end)

--[[
Creates a scrolling frame in StarterGui.
Disabled unless needed.
--]]
--[[
NexusUnitTesting:RegisterUnitTest("ManualTesting",function(UnitTest)
	--Create the screen gui.
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("StarterGui")
	
	--Create the frame.
	local ScrollingFrame = NexusScrollingFrame.new("Qt5")
	ScrollingFrame.CanvasSize = UDim2.new(0,800,0,800)
	ScrollingFrame.Size = UDim2.new(0,420,0,420)
	ScrollingFrame.Parent = ScreenGui
	
	--Create a grid.
	for i = 0,7 do
		for j = 0,7 do
			local Frame = NexusPluginFramework.new("Frame")
			Frame.BackgroundColor3 = Color3.new(math.random(),math.random(),math.random())
			Frame.Size = UDim2.new(0,80,0,80)
			Frame.Position = UDim2.new(0,(i * 100) + 10,0,(j * 100) + 10)
			Frame.Parent = ScrollingFrame
		end
	end
	
	--Wait for the screen gui to be deleted.
	while ScreenGui.Parent do wait() end
end)
--]]



return true