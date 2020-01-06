--[[
TheNexusAvenger

Frame that can be expanded or collapsed to show additional information.
Intended to contain additional list frames.
--]]

local CLASS_NAME = "NexusCollapsableListFrame"

local DOUBLE_CLICK_MAX_TIME = 0.5
local EXPANDED_ARROW_IMAGE = "rbxasset://textures/StudioToolbox/ArrowDownIconWhite.png"
local COLLAPSED_ARROW_IMAGE = "rbxasset://textures/ui/LuaApp/icons/ic-arrow-right.png"
local ARROW_RELATIVE_SIZE = (10/20) * (54/38)



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusWrappedInstance = NexusPluginFramework:GetResource("Base.NexusWrappedInstance")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")
local NexusSettings = NexusPluginFramework:GetResource("Plugin.NexusSettings")
local NexusBoundingSizeConstraint = NexusPluginFramework:GetResource("UI.Constraint.NexusBoundingSizeConstraint")

local Settings = NexusSettings.GetSettings()

local NexusCollapsableListFrame = NexusWrappedInstance:Extend()
NexusCollapsableListFrame:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusCollapsableListFrame)



--[[
Creates a Nexus Collapsable List Frame object.
--]]
function NexusCollapsableListFrame:__new()
	self:InitializeSuper("Frame")
	self.Name = CLASS_NAME
	
	--Create the subframes.
	local Arrow = NexusWrappedInstance.GetInstance("ImageButton")
	Arrow.Hidden = true
	Arrow.Name = "Arrow"
	Arrow.BackgroundTransparency = 1
	Arrow.SizeConstraint = "RelativeYY"
	Arrow.Size = UDim2.new(0.9,0,0.9,0)
	Arrow.ImageColor3 = Color3.new(151/255,151/255,151/255)
	Arrow.Parent = self
	self.__Arrow = Arrow
	
	local Container = NexusWrappedInstance.GetInstance("Frame")
	Container.Hidden = true
	Container.BackgroundTransparency = 1
	Container.Name = "Container"
	Container.Size = UDim2.new(1,-16,1,0)
	Container.Position = UDim2.new(1,0,0,0)
	Container.AnchorPoint = Vector2.new(1,0)
	Container.Parent = self
	self.__Container = Container
	
	local CollapsableContainer = NexusWrappedInstance.GetInstance("Frame")
	CollapsableContainer.Hidden = true
	CollapsableContainer.BackgroundTransparency = 1
	CollapsableContainer.Name = "CollapsableContainer"
	CollapsableContainer.Position = UDim2.new(1,0,1,0)
	CollapsableContainer.Size = UDim2.new(1,-16,0,0)
	CollapsableContainer.AnchorPoint = Vector2.new(1,0)
	CollapsableContainer.Parent = self
	self.__CollapsableContainer = CollapsableContainer
	
	--Create the events.
	self:__SetChangedOverride("DoubleClicked",function() end)
	self.DoubleClicked = NexusEventCreator:CreateEvent()
	self:__SetChangedOverride("DelayClicked",function() end)
	self.DelayClicked = NexusEventCreator:CreateEvent()
	
	--Create the constraint.
	local BoundingSizeConstraint = NexusBoundingSizeConstraint.new(CollapsableContainer)
	BoundingSizeConstraint.SizeXOverride = UDim.new(1,-Container.AbsoluteSize.Y)
	self:__SetChangedOverride("__BoundingSizeConstraint",function() end)
	self.__BoundingSizeConstraint = BoundingSizeConstraint
	
	--[[
	Updates the size of everything.
	--]]
	local LastSize,LastCollapsableContainerSize
	local function UpdateSize()
		local DesiredSize = self.Size
		local CollapsableContainerSize = self.Size
		local SizeX,SizeY = DesiredSize.X,DesiredSize.Y
		
		--Return if the size is the same.
		if LastSize == DesiredSize and LastCollapsableContainerSize == CollapsableContainerSize then
			--return
		end
		LastSize = DesiredSize
		
		--Calculate the absolute size Y.
		local Parent = self.Parent
		local AbsoluteDesiredSizeY = (Parent and Parent.AbsoluteSize.Y or 0) * SizeY.Scale + SizeY.Offset
		local ArrowSize = AbsoluteDesiredSizeY * ARROW_RELATIVE_SIZE
		
		--Set the sizes and positions.
		Arrow.Position = UDim2.new(0,(AbsoluteDesiredSizeY - ArrowSize)/2,0,(AbsoluteDesiredSizeY - ArrowSize)/2)
		Arrow.Size = UDim2.new(0,ArrowSize,0,ArrowSize)
		Container.Size = UDim2.new(1,-AbsoluteDesiredSizeY,0,AbsoluteDesiredSizeY)
		BoundingSizeConstraint.SizeXOverride = UDim.new(1,-AbsoluteDesiredSizeY)
		CollapsableContainer.Position = UDim2.new(1,0,0,AbsoluteDesiredSizeY)
		if self.Expanded then
			self:GetWrappedInstance().Size = UDim2.new(SizeX,UDim.new(SizeY.Scale,SizeY.Offset + CollapsableContainer.Size.Y.Offset))
		else
			self:GetWrappedInstance().Size = DesiredSize
		end
	end
	
	--Set up the size changing.
	self.__NoBackwardsReplicationProperties["Size"] = true
	self:__SetChangedOverride("Size",UpdateSize)
	CollapsableContainer:GetPropertyChangedSignal("Size"):Connect(UpdateSize)
	
	--[[
	Returns if a visible frame exists.
	--]]
	local function HasVisibleFrame(Frame)
		--Return true if a frame exists.
		for _,SubFrame in pairs(Frame:GetChildren()) do
			if SubFrame:IsA("Frame") then
				if SubFrame.Visible then --or HasVisibleFrame(SubFrame) then
					return true
				end
			end
		end
		
		--Return false (no frame found).
		return false
	end
	
	--[[
	Updates the visibility of the arrow.
	--]]
	local function UpdateArrowVisibility()
		local ArrowVisible = (self.ArrowVisible == true)
		local HasChildren = HasVisibleFrame(CollapsableContainer)
		
		--Update the visibility.
		Arrow.Visible = ArrowVisible and HasChildren
	end
	
	--[[
	Updates the colors and transparency depending
	on if it is selected or hovered.
	--]]
	local Hovering = false
	local function UpdateContainerColor()
		local Disabled = self.Disabled
		local Selectable = self.Selectable
		local Selected = self.Selected
		
		--Hide the frame if it is not selected or hovering.
		if not Selectable or Disabled or (not Selected and not Hovering) then
			Container.BackgroundTransparency = 1
			return
		end
		
		--Determine the modifier.
		local Modifier = "Hover"
		if Selected then
			Modifier = "Selected"
		end
	
		--Update the color.
		local HighlightColor = self.HighlightColor3
		Container.BackgroundTransparency = 0
		if typeof(HighlightColor) == "Color3" then
			Container.BackgroundColor3 = HighlightColor
		else
			local Theme = Settings:GetSetting("Studio","Theme")
			Container.BackgroundColor3 = Theme:GetColor(HighlightColor,Modifier)
		end
	end
	
	--Connect change events.
	local VisibleChangedEvents = {}
	self:__SetChangedOverride("ArrowVisible",UpdateArrowVisibility)
	CollapsableContainer.ChildAdded:Connect(function(Ins)
		--Connect the visibility changes.
		if Ins:IsA("Frame") then
			VisibleChangedEvents[Ins] = Ins:GetPropertyChangedSignal("Visible"):Connect(UpdateArrowVisibility)
		end
		
		--Update the arrow visiblity.
		UpdateArrowVisibility()
	end)
	CollapsableContainer.ChildRemoved:Connect(function(Ins)
		--Disconnect the visibility changes.
		if VisibleChangedEvents[Ins] then
			VisibleChangedEvents[Ins]:Disconnect()
			VisibleChangedEvents[Ins] = nil
			UpdateArrowVisibility()
		end
	end)
	self:__SetChangedOverride("Disabled",function()
		local Disabled = self.Disabled
		Arrow.Disabled = Disabled
		
		--Update the arrow color.
		if not Disabled then
			Arrow.ImageColor3 = Color3.new(151/255,151/255,151/255)
		else
			Arrow.ImageColor3 = Color3.new(0.3,0.3,0.3)
		end
		
		--Update the container color.
		UpdateContainerColor()
	end)
	Settings:GetSettingsChangedSignal("Studio","UI Theme"):Connect(UpdateContainerColor)
	self:__SetChangedOverride("HighlightColor3",UpdateContainerColor)
	self:__SetChangedOverride("Selectable",UpdateContainerColor)
	self:__SetChangedOverride("Selected",UpdateContainerColor)
	self:__SetChangedOverride("Expanded",function()
		--Update the arrow texture.
		local Expanded = self.Expanded
		if Expanded then
			Arrow.Image = EXPANDED_ARROW_IMAGE
		else
			Arrow.Image = COLLAPSED_ARROW_IMAGE
		end
		
		--Update the container visibility.
		CollapsableContainer.Visible = Expanded
		
		--Update the size.
		UpdateSize()
	end)
	
	--Set up hovering.
	Container.MouseEnter:Connect(function()
		Hovering = true
		UpdateContainerColor()
	end)
	Container.MouseLeave:Connect(function()
		Hovering = false
		UpdateContainerColor()
	end)
	
	--Set up the expanding.
	local DB = true
	local LastClickTime
	Arrow.MouseButton1Down:Connect(function()
		if DB and not self.Disabled then
			DB = false
			self.Expanded = not self.Expanded
			
			wait()
			DB = true
		end
	end)
	
	--Set up selecting.
	Container.InputBegan:Connect(function(Input)
		if DB and self.Selectable and not self.Disabled and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DB = false
			if self.Selected then
				--Handle double clicking and delayed clicking.
				if LastClickTime ~= nil then
					if tick() - LastClickTime < DOUBLE_CLICK_MAX_TIME then
						self.DoubleClicked:Fire()
					else
						self.DelayClicked:Fire()
					end
					LastClickTime = nil
				else
					LastClickTime = tick()
				end
				
				wait()
			else
				self.Selected = true
				LastClickTime = tick()
			end
			
			wait()
			DB = true
		end
	end)
	
	--Set up pressing enter.
	self:ConnectToHighestParent("InputBegan",function(Input)
		if self.Selected and Input.KeyCode == Enum.KeyCode.Return then
			self.DoubleClicked:Fire()
		end
	end)
	
	--Set the defaults.
	self.Size = UDim2.new(0,200,0,16)
	self.HighlightColor3 = "TableItem"
	self.BackgroundTransparency = 1
	self.ArrowVisible = true
	self.Selectable = true
	self.Selected = false
	self.Expanded = true
end

--[[
Returns the container that is next to the arrow and
is not collapsed.
--]]
function NexusCollapsableListFrame:GetMainContainer()
	return self.__Container
end

--[[
Returns the collapsable container frame. Frames
parented to this will be shown or hidden based on
if the frame is expanded or collapsed.
--]]
function NexusCollapsableListFrame:GetCollapsableContainer()
	return self.__CollapsableContainer
end



return NexusCollapsableListFrame