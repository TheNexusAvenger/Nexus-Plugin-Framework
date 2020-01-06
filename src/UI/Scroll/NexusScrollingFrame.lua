--[[
TheNexusAvenger

Frame that allows for scrolling. Can have one of multiple themes.
--]]

local CLASS_NAME = "NexusScrollingFrame"

local SCROLL_BUTTON_HOLD_TIME = 0.5
local SCROLL_BUTTON_HOLD_STEPS_PER_SECOND = 10



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusObject = NexusPluginFramework:GetResource("NexusInstance.NexusObject")
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusSettings = NexusPluginFramework:GetResource("Plugin.NexusSettings")
local NexusScrollBar = NexusPluginFramework:GetResource("UI.Scroll.NexusScrollBar")
local NexusEnums = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection").GetBuiltInEnums()

local NexusScrollingFrame = NexusWrappedInstance:Extend()
NexusScrollingFrame:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusScrollingFrame)



--[[
Creates a Nexus Scrolling Frame object.
--]]
function NexusScrollingFrame:__new(Theme)
	self:InitializeSuper("ScrollingFrame")
	
	--Modify the theme.
	if not Theme then
		Theme = NexusEnums.NexusScrollTheme.Native
	end
	
	--Initialize the super class.
	if NexusEnums.NexusScrollTheme.Native:Equals(Theme) then
		self:__InitializeNativeScrollingFrame()
	elseif NexusEnums.NexusScrollTheme.Qt5:Equals(Theme) then
		self:__InitializeQt5ScrollingFrame()
	end
	
	--Set the name.
	self.Name = CLASS_NAME
	
	--Set the colors.
	self.BackgroundColor3 = "MainBackground"
	self.BorderColor3 = "Border"
	self.ScrollColor3 = "ScrollBar"
	self.ScrollBackgroundColor3 = "ScrollBarBackground"
	self.ScrollArrowColor3 = "TitlebarText"
	self:__SetChangedOverride("ScrollBarButtonIncrement",function() end)
	self.ScrollBarButtonIncrement = 16
end

--[[
Initializes the scrolling frame as a native one.
--]]
function NexusScrollingFrame:__InitializeNativeScrollingFrame()
	--Set up the color change overrides.
	self:__SetChangedOverride("ScrollColor3",function()
		self.ScrollBarImageColor3 = self.ScrollColor3
	end)
	self:__SetChangedOverride("ScrollBackgroundColor3",function() end)
	self:__SetChangedOverride("ScrollArrowColor3",function() end)
	
	--Set the default properties.
	self.BottomImage = "rbxasset://textures/StudioToolbox/ScrollBarBottom.png"
	self.MidImage = "rbxasset://textures/StudioToolbox/ScrollBarMiddle.png"
	self.TopImage = "rbxasset://textures/StudioToolbox/ScrollBarTop.png"
	self.ScrollBarThickness = 8
end

--[[
Initializes the scrolling frame as a Qt5 one.
--]]
function NexusScrollingFrame:__InitializeQt5ScrollingFrame()
	--Create the adorn.
	local ScrollBarAdorn = NexusWrappedInstance.GetInstance("Frame")
	ScrollBarAdorn.Name = "ScrollBarAdorn"
	ScrollBarAdorn.BackgroundTransparency = 1
	ScrollBarAdorn.Hidden = true
	
	--[[
	Sets up changes to the scroll bar adorn from the frame.
	--]]
	local function MirrorChanges(PropertyName)
		self:GetPropertyChangedSignal(PropertyName):Connect(function()
			ScrollBarAdorn[PropertyName] = self[PropertyName]
		end)
	end
	MirrorChanges("Size")
	MirrorChanges("Position")
	MirrorChanges("Rotation")
	MirrorChanges("Parent")
	
	--Create the side scrollbars.
	local BottomScrollBar = NexusScrollBar.new(NexusEnums.NexusScrollTheme.Qt5,Enum.Axis.X)
	BottomScrollBar.Name = "HorizontalScrollBar"
	BottomScrollBar.Parent = ScrollBarAdorn
	local SideScrollBar = NexusScrollBar.new(NexusEnums.NexusScrollTheme.Qt5,Enum.Axis.Y)
	SideScrollBar.Name = "VerticalScrollBar"
	SideScrollBar.Parent = ScrollBarAdorn
	
	self:GetPropertyChangedSignal("ZIndex"):Connect(function()
		ScrollBarAdorn.ZIndex = self.ZIndex + 1
		BottomScrollBar.ZIndex = self.ZIndex + 1
		SideScrollBar.ZIndex = self.ZIndex + 1
	end)
	ScrollBarAdorn.ZIndex = self.ZIndex + 1
	BottomScrollBar.ZIndex = self.ZIndex + 1
	SideScrollBar.ZIndex = self.ZIndex + 1
	
	--Set up input for the scrollbars.
	--[[
	Returns the absolute size of the canvas.
	--]]
	local function GetAbsoluteCanvasSize()
		--Return 0,0 if there is no parent.
		local Parent = self.Parent
		if not Parent then
			return Vector2.new(0,0)
		end
		
		--Return the absolute size.
		local CanvasSize = self.CanvasSize
		local ParentAbsoluteSize = Parent.AbsoluteSize
		return Vector2.new((CanvasSize.X.Scale * ParentAbsoluteSize.X) + CanvasSize.X.Offset,(CanvasSize.Y.Scale * ParentAbsoluteSize.Y) + CanvasSize.Y.Offset)
	end
	
	--[[
	Updates the position of the scroll bar when the position changes.
	--]]
	local function UpdatePosition()
		local AbsoluteWindowSize = self.AbsoluteWindowSize
		local AbsoluteCanvasSize = GetAbsoluteCanvasSize()
		local ExistingCanvasPosition = self.CanvasPosition
		
		BottomScrollBar.RelativePosition = ExistingCanvasPosition.X / (AbsoluteCanvasSize.X - AbsoluteWindowSize.X)
		SideScrollBar.RelativePosition = ExistingCanvasPosition.Y / (AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y)
	end
	self:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdatePosition)
	self:GetPropertyChangedSignal("CanvasSize"):Connect(UpdatePosition)
	self:GetPropertyChangedSignal("CanvasPosition"):Connect(UpdatePosition)
	
	--Set up button press events.
	BottomScrollBar.Button1Pressed:Connect(function()
		local ExistingCanvasPosition = self.CanvasPosition
		local ScrollBarButtonIncrement = self.ScrollBarButtonIncrement
		
		self.CanvasPosition = Vector2.new(math.max(0,ExistingCanvasPosition.X - ScrollBarButtonIncrement),ExistingCanvasPosition.Y)
	end)
	
	BottomScrollBar.Button2Pressed:Connect(function()
		local ExistingCanvasPosition = self.CanvasPosition
		local ScrollBarButtonIncrement = self.ScrollBarButtonIncrement
		local AbsoluteWindowSize = self.AbsoluteWindowSize
		local AbsoluteCanvasSize = GetAbsoluteCanvasSize()
		
		self.CanvasPosition = Vector2.new(math.min(ExistingCanvasPosition.X + ScrollBarButtonIncrement,AbsoluteCanvasSize.X - AbsoluteWindowSize.X),ExistingCanvasPosition.Y)
	end)
	
	SideScrollBar.Button1Pressed:Connect(function()
		local ExistingCanvasPosition = self.CanvasPosition
		local ScrollBarButtonIncrement = self.ScrollBarButtonIncrement
		
		self.CanvasPosition = Vector2.new(ExistingCanvasPosition.X,math.max(0,ExistingCanvasPosition.Y - ScrollBarButtonIncrement,0))
	end)
	
	SideScrollBar.Button2Pressed:Connect(function()
		local ExistingCanvasPosition = self.CanvasPosition
		local ScrollBarButtonIncrement = self.ScrollBarButtonIncrement
		local AbsoluteWindowSize = self.AbsoluteWindowSize
		local AbsoluteCanvasSize = GetAbsoluteCanvasSize()
		
		self.CanvasPosition = Vector2.new(ExistingCanvasPosition.X,math.min(ExistingCanvasPosition.Y + ScrollBarButtonIncrement,AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y))
	end)
	
	--Set up resizing and enabling of scroll bars.
	local function Resize()
		local AbsoluteSize,CanvasAbsoluteSize = self.AbsoluteSize,GetAbsoluteCanvasSize()
		local ScrollBarThickness = self.ScrollBarThickness
		local ScrollBarXEnabled,ScrollBarYEnabled = CanvasAbsoluteSize.X > AbsoluteSize.X,CanvasAbsoluteSize.Y > AbsoluteSize.Y
		local BorderSizePixel = self.BorderSizePixel
		
		--Show or hide the scroll bars.
		BottomScrollBar.Visible = ScrollBarXEnabled
		BottomScrollBar.RelativeSize = CanvasAbsoluteSize.X/AbsoluteSize.X
		SideScrollBar.Visible = ScrollBarYEnabled
		SideScrollBar.RelativeSize = CanvasAbsoluteSize.Y/AbsoluteSize.Y
		
		--Move the vertical scroll bar.
		if self.VerticalScrollBarPosition == "Left" or self.VerticalScrollBarPosition == Enum.VerticalScrollBarPosition.Left then
			BottomScrollBar.AnchorPoint = Vector2.new(1,1)
			BottomScrollBar.Position = UDim2.new(1,-BorderSizePixel,1,0)
			SideScrollBar.AnchorPoint = Vector2.new(0,0)
			SideScrollBar.Position = UDim2.new(0,0,0,BorderSizePixel)
		else
			BottomScrollBar.AnchorPoint = Vector2.new(0,1)
			BottomScrollBar.Position = UDim2.new(0,BorderSizePixel,1,0)
			SideScrollBar.AnchorPoint = Vector2.new(1,0)
			SideScrollBar.Position = UDim2.new(1,0,0,BorderSizePixel)
		end
		
		--Resize the scroll bars.
		if ScrollBarXEnabled and not ScrollBarYEnabled then
			BottomScrollBar.Size = UDim2.new(1,-(2 * BorderSizePixel),0,ScrollBarThickness)
		elseif not ScrollBarXEnabled and ScrollBarYEnabled then
			SideScrollBar.Size = UDim2.new(0,ScrollBarThickness,1,-(2 * BorderSizePixel))
		else
			BottomScrollBar.Size = UDim2.new(1,-ScrollBarThickness - (2 * BorderSizePixel),0,ScrollBarThickness)
			SideScrollBar.Size = UDim2.new(0,ScrollBarThickness,1,-ScrollBarThickness - (2 * BorderSizePixel))
		end
	end
	self:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
	self:GetPropertyChangedSignal("CanvasSize"):Connect(Resize)
	self:GetPropertyChangedSignal("ScrollBarThickness"):Connect(Resize)
	self:GetPropertyChangedSignal("VerticalScrollBarPosition"):Connect(Resize)
	
	--Set up the color change overrides.
	self:__SetChangedOverride("ScrollColor3",function()
		BottomScrollBar.ScrollColor3 = self.ScrollColor3
		SideScrollBar.ScrollColor3 = self.ScrollColor3
	end)
	self:__SetChangedOverride("ScrollBackgroundColor3",function()
		BottomScrollBar.BackgroundColor3 = self.ScrollBackgroundColor3
		SideScrollBar.BackgroundColor3 = self.ScrollBackgroundColor3
	end)
	self:__SetChangedOverride("ScrollArrowColor3",function()
		BottomScrollBar.ScrollArrowColor3 = self.ScrollArrowColor3
		SideScrollBar.ScrollArrowColor3 = self.ScrollArrowColor3
	end)
	
	--Set the default properties.
	self.BottomImage = ""
	self.MidImage = ""
	self.TopImage = ""
	self.ScrollBarThickness = 16
end



return NexusScrollingFrame