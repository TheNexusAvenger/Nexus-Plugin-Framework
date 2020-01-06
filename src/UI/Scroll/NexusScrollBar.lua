--[[
TheNexusAvenger

Frame that adds scroll frame functionality
--]]

local CLASS_NAME = "NexusScrollBar"

local SCROLL_BUTTON_HOLD_TIME = 0.5
local SCROLL_BUTTON_HOLD_STEPS_PER_SECOND = 20

local SCROLL_BUTTON_IMAGE_UP = "rbxasset://textures/ui/Lobby/Buttons/scroll_up.png"
local SCROLL_BUTTON_IMAGE_DOWN = "rbxasset://textures/ui/Lobby/Buttons/scroll_down.png"
local SCROLL_BUTTON_IMAGE_LEFT = "rbxasset://textures/ui/Lobby/Buttons/scroll_left.png"
local SCROLL_BUTTON_IMAGE_RIGHT = "rbxasset://textures/ui/Lobby/Buttons/scroll_right.png"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")
local NexusObject = NexusPluginFramework:GetResource("NexusInstance.NexusObject")
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusEnums = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection").GetBuiltInEnums()

local NexusScrollBar = NexusWrappedInstance:Extend()
NexusScrollBar:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusScrollBar)



--[[
Returns if a position is in a frame.
--]]
local function PointInFrame(X,Y,Frame)
	local AbsoluteSize,AbsolutePosition = Frame.AbsoluteSize,Frame.AbsolutePosition
	return X >= AbsolutePosition.X and X <= AbsolutePosition.X + AbsoluteSize.X and Y >= AbsolutePosition.Y and Y <= AbsolutePosition.Y + AbsoluteSize.Y
end



--[[
Creates a Nexus Scrolling Bar object.
--]]
function NexusScrollBar:__new(Theme,Axis)
	self:InitializeSuper("Frame")
	self.Name = CLASS_NAME
	self.__StartPosition = 0
	self.__EndPosition = 0
	
	--Create the events.
	self:__SetChangedOverride("Button1Pressed",function() end)
	self.Button1Pressed = NexusEventCreator:CreateEvent()
	self:__SetChangedOverride("Button2Pressed",function() end)
	self.Button2Pressed = NexusEventCreator:CreateEvent()
	
	--Create the scroll bar.
	local ScrollBar = NexusWrappedInstance.GetInstance("Frame")
	ScrollBar.BorderSizePixel = 1
	ScrollBar.Name = "ScrollBar"
	ScrollBar.Hidden = true
	ScrollBar.Parent = self
	self.__ScrollBar = ScrollBar
	
	--Create the buttons.
	local Button1 = NexusWrappedInstance.GetInstance("TextButton")
	Button1.Hidden = true
	Button1.Name = "Button1"
	Button1.Text = ""
	Button1.Parent = self
	self.__Button1 = Button1
	
	local Button2 = NexusWrappedInstance.GetInstance("TextButton")
	Button2.Hidden = true
	Button2.Name = "Button2"
	Button2.Text = ""
	Button2.Parent = self
	self.__Button2 = Button2
	
	--Apply the themes.
	self:__ApplyQt5Theme(Axis)
	
	--Set up updating the size.
	local UpdateScrollBar
	if Axis == Enum.Axis.X then
		function UpdateScrollBar()
			--Get the sizes and positions.
			local AbsoluteSize = self.AbsoluteSize
			local StartPosition,EndPosition = self.__StartPosition,self.__EndPosition
			local RelativePosition,RelativeSize = self.RelativePosition or 0,self.RelativeSize or 1
	 
			--Adjust the size.
			if RelativeSize < 1 then
				RelativeSize = 1
			end
			
			--Determine the scroll bar size and position.
			local ScrollBarSize = (EndPosition - StartPosition)/RelativeSize
			local ScrollBarOffset = RelativePosition * ((EndPosition - StartPosition) - ScrollBarSize)
			
			--Set the size and position of the scroll bar.
			ScrollBar.Size = UDim2.new(0,ScrollBarSize,1,0)
			ScrollBar.Position = UDim2.new(0,StartPosition + ScrollBarOffset,0,0)
		end
	elseif Axis == Enum.Axis.Y then
		function UpdateScrollBar()
			--Get the sizes and positions.
			local AbsoluteSize = self.AbsoluteSize
			local StartPosition,EndPosition = self.__StartPosition,self.__EndPosition
			local RelativePosition,RelativeSize = self.RelativePosition or 0,self.RelativeSize or 1
	 
			--Adjust the size.
			if RelativeSize < 1 then
				RelativeSize = 1
			end
			
			--Determine the scroll bar size and position.
			local ScrollBarSize = (EndPosition - StartPosition)/RelativeSize
			local ScrollBarOffset = RelativePosition * ((EndPosition - StartPosition) - ScrollBarSize)
			
			--Set the size and position of the scroll bar.
			ScrollBar.Size = UDim2.new(1,0,0,ScrollBarSize)
			ScrollBar.Position = UDim2.new(0,0,0,StartPosition + ScrollBarOffset)
		end
	end
	self:__SetChangedOverride("RelativePosition",UpdateScrollBar)
	self:__SetChangedOverride("RelativeSize",UpdateScrollBar)
	self:GetPropertyChangedSignal("__StartPosition"):Connect(UpdateScrollBar)
	self:GetPropertyChangedSignal("__EndPosition"):Connect(UpdateScrollBar)
	
	--Set up the buttons.
	local Button1Start,Button2Start
	local Button1LastInvoke,Button2LastInvoke
	Button1.MouseButton1Down:Connect(function()
		--Fire the first invoke.
		self.Button1Pressed:Fire()
		Button1Start = tick()
		Button1LastInvoke = tick()
		
		--Run the loop until the mouse button is released.
		while Button1Start do
			local CurrentTime = tick()
			if CurrentTime - Button1Start >= SCROLL_BUTTON_HOLD_TIME and CurrentTime - Button1LastInvoke >= 1/SCROLL_BUTTON_HOLD_STEPS_PER_SECOND then
				self.Button1Pressed:Fire()
				Button1LastInvoke = CurrentTime
			end
			wait()
		end
	end)

	Button1.MouseButton1Up:Connect(function()
		Button1Start = nil
	end)
	
	Button2.MouseButton1Down:Connect(function()
		--Fire the first invoke.
		self.Button2Pressed:Fire()
		Button2Start = tick()
		Button2LastInvoke = tick()
		
		--Run the loop until the mouse button is released.
		while Button2Start do
			local CurrentTime = tick()
			if CurrentTime - Button2Start >= SCROLL_BUTTON_HOLD_TIME and CurrentTime - Button2LastInvoke >= 1/SCROLL_BUTTON_HOLD_STEPS_PER_SECOND then
				self.Button2Pressed:Fire()
				Button2LastInvoke = CurrentTime
			end
			wait()
		end
	end)

	Button2.MouseButton1Up:Connect(function()
		Button2Start = nil
	end)
	
	--Set up dragging.
	local StartPosition,LastPosition
	local MoveScrollBar
	if Axis == Enum.Axis.X then
		function MoveScrollBar(CurrentPosition)
			--Determine the delta.
			local DeltaX = CurrentPosition.X - LastPosition.X
			local ScrollBarSize = self.__EndPosition - self.__StartPosition
			local EmptySpace = ScrollBarSize * (1 - (1/self.RelativeSize))
			
			--Add the delta.
			self.RelativePosition = math.clamp(self.RelativePosition + (DeltaX/EmptySpace),0,1)
			
			--Set the last position as the next position.
			LastPosition = CurrentPosition
		end
	elseif Axis == Enum.Axis.Y then
		function MoveScrollBar(CurrentPosition)
			--Determine the delta.
			local DeltaY = CurrentPosition.Y - LastPosition.Y
			local ScrollBarSize = self.__EndPosition - self.__StartPosition
			local EmptySpace = ScrollBarSize * (1 - (1/self.RelativeSize))
			
			--Add the delta.
			self.RelativePosition = math.clamp(self.RelativePosition + (DeltaY/EmptySpace),0,1)
			
			--Set the last position as the next position.
			LastPosition = CurrentPosition
		end
	end
	
	ScrollBar:ConnectToHighestParent("InputBegan",function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 and PointInFrame(Input.Position.X,Input.Position.Y,ScrollBar) then
			StartPosition = Input.Position
			LastPosition = StartPosition
		end
	end)
	
	ScrollBar:ConnectToHighestParent("InputChanged",function(Input)
		if StartPosition and Input.UserInputType == Enum.UserInputType.MouseMovement then
			MoveScrollBar(Input.Position)
		end
	end)
	
	ScrollBar:ConnectToHighestParent("InputEnded",function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			StartPosition = nil
			LastPosition = nil
		end
	end)
	
	--Set the default colors.
	self.BackgroundColor3 = "ScrollBarBackground"
	self.BorderColor3 = "Border"
	self.ScrollColor3 = "ScrollBar"
	self.ScrollArrowColor3 = "TitlebarText"
	self.BorderSizePixel = 1
	
	--Set the size.
	self.RelativePosition = 0
	self.RelativeSize = 2
	if Axis == Enum.Axis.X then
		self.Size = UDim2.new(0,200,0,50)
	elseif Axis == Enum.Axis.Y then
		self.Size = UDim2.new(0,50,0,200)
	end
end

--[[
Applies the Qt5 theme to the scroll bar.
--]]
function NexusScrollBar:__ApplyQt5Theme(Axis)
	--Modify the scroll frame.
	local ScrollBar = self.__ScrollBar
	ScrollBar.BorderSizePixel = 1
	
	--Modify the buttons.
	local Button1 = self.__Button1
	Button1.BorderColor3 = "Border"
	Button1.Size = UDim2.new(1,0,1,0)
	if Axis == Enum.Axis.X then
		Button1.SizeConstraint = Enum.SizeConstraint.RelativeYY
	elseif Axis == Enum.Axis.Y then
		Button1.SizeConstraint = Enum.SizeConstraint.RelativeXX
	end
	
	local Arrow1 = NexusWrappedInstance.GetInstance("ImageLabel")
	Arrow1.Hidden = true
	Arrow1.BackgroundTransparency = 1
	Arrow1.Position = UDim2.new(0.5,0,0.5,0)
	Arrow1.AnchorPoint = Vector2.new(0.5,0.5)
	Arrow1.Parent = Button1
	if Axis == Enum.Axis.X then
		Arrow1.Image = SCROLL_BUTTON_IMAGE_LEFT
		Arrow1.Size = UDim2.new(6/16,0,10/16,0)
	elseif Axis == Enum.Axis.Y then
		Arrow1.Image = SCROLL_BUTTON_IMAGE_UP
		Arrow1.Size = UDim2.new(10/16,0,6/16,0)
	end
	
	local Button2 = self.__Button2
	Button2.BorderColor3 = "Border"
	Button2.Size = UDim2.new(1,0,1,0)
	Button2.AnchorPoint = Vector2.new(1,1)
	Button2.Position = UDim2.new(1,0,1,0)
	if Axis == Enum.Axis.X then
		Button2.SizeConstraint = Enum.SizeConstraint.RelativeYY
	elseif Axis == Enum.Axis.Y then
		Button2.SizeConstraint = Enum.SizeConstraint.RelativeXX
	end
	
	local Arrow2 = NexusWrappedInstance.GetInstance("ImageLabel")
	Arrow2.Hidden = true
	Arrow2.BackgroundTransparency = 1
	Arrow2.Position = UDim2.new(0.5,0,0.5,0)
	Arrow2.AnchorPoint = Vector2.new(0.5,0.5)
	Arrow2.Parent = Button2
	if Axis == Enum.Axis.X then
		Arrow2.Image = SCROLL_BUTTON_IMAGE_RIGHT
		Arrow2.Size = UDim2.new(6/16,0,10/16,0)
	elseif Axis == Enum.Axis.Y then
		Arrow2.Image = SCROLL_BUTTON_IMAGE_DOWN
		Arrow2.Size = UDim2.new(10/16,0,6/16,0)
	end
	
	--Set up colors.
	self:GetPropertyChangedSignal("BorderColor3"):Connect(function()
		ScrollBar.BorderColor3 = self.BorderColor3
		Button1.BorderColor3 = self.BorderColor3
		Button2.BorderColor3 = self.BorderColor3
	end)
	
	self:GetPropertyChangedSignal("BorderSizePixel"):Connect(function()
		ScrollBar.BorderSizePixel = self.BorderSizePixel
		Button1.BorderSizePixel = self.BorderSizePixel
		Button2.BorderSizePixel = self.BorderSizePixel
	end)
	
	self:__SetChangedOverride("ScrollColor3",function()
		ScrollBar.BackgroundColor3 = self.ScrollColor3
		Button1.BackgroundColor3 = self.ScrollColor3
		Button1.BackgroundColor3 = self.ScrollColor3
	end)
	
	self:__SetChangedOverride("ScrollArrowColor3",function()
		Arrow1.ImageColor3 = self.ScrollArrowColor3
		Arrow2.ImageColor3 = self.ScrollArrowColor3
	end)
	
	--Set up z-indexing.
	self:GetPropertyChangedSignal("ZIndex"):Connect(function()
		local ZIndex = self.ZIndex
		ScrollBar.ZIndex = ZIndex
		Button1.ZIndex = ZIndex
		Button2.ZIndex = ZIndex
		Arrow1.ZIndex = ZIndex
		Arrow2.ZIndex = ZIndex
	end)
	
	--Set up resizing.
	local ResizeFunction
	if Axis == Enum.Axis.X then
		function ResizeFunction()
			--Get the size.
			local AbsoluteSize = self.AbsoluteSize
			local FullLength = AbsoluteSize.X
			local ButtonSizeRequirement = AbsoluteSize.Y + self.BorderSizePixel
			
			--Update the buttons.
			local RemainingLength = FullLength - (2 * ButtonSizeRequirement)
			if RemainingLength > 0 then
				Button1.Visible = true
				Button2.Visible = true
				
				self.__StartPosition = ButtonSizeRequirement
				self.__EndPosition = ButtonSizeRequirement + RemainingLength
			else
				Button1.Visible = false
				Button2.Visible = false
				
				self.__StartPosition = 0
				self.__EndPosition = FullLength
			end
		end
	elseif Axis == Enum.Axis.Y then
		function ResizeFunction()
			--Get the size.
			local AbsoluteSize = self.AbsoluteSize
			local FullLength = AbsoluteSize.Y
			local ButtonSizeRequirement = AbsoluteSize.X + self.BorderSizePixel
			
			--Update the buttons.
			local RemainingLength = FullLength - (2 * ButtonSizeRequirement)
			if RemainingLength > 0 then
				Button1.Visible = true
				Button2.Visible = true
				
				self.__StartPosition = ButtonSizeRequirement
				self.__EndPosition = ButtonSizeRequirement + RemainingLength
			else
				Button1.Visible = false
				Button2.Visible = false
				
				self.__StartPosition = 0
				self.__EndPosition = FullLength
			end
		end
	end
	self:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeFunction)
	self:GetPropertyChangedSignal("BorderSizePixel"):Connect(ResizeFunction)
end



return NexusScrollBar