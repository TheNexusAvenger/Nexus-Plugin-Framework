--[[
TheNexusAvenger

Constraint that is applied to a frame to set the
size as a bounding size.
--]]

local CLASS_NAME = "NexusBoundingSizeConstraint"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")

local NexusBoundingSizeConstraint = NexusContainer:Extend()
NexusBoundingSizeConstraint:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusBoundingSizeConstraint)



--[[
Creates a Nexus Bounding Size Constraint object.
--]]
function NexusBoundingSizeConstraint:__new(Frame)
	self:InitializeSuper()
	self.Name = CLASS_NAME
	
	local FrameConnections = {}
	self.FrameConnections = FrameConnections
	local SizeXOverride,SizeYOverride
	local BoundingFrameX,BoundingFrameY
	local SecondaryBoundingFrameX,SecondaryBoundingFrameY
	local BoundingSizeX,BoundingSizeY = 0,0
	local SecondBoundingSizeX,SecondBoundingSizeY = 0,0
	
	--Unwrap the frame.
	if Frame:IsA(NexusContainer.ClassName) then
		Frame = Frame:GetWrappedInstance()
	end
	
	--[[
	Returns the corner position of the frame.
	--]]
	local function GetCornerPosition(Frame)
		local AbsoluteSize,AbsolutePosition = Frame.AbsoluteSize,Frame.AbsolutePosition
		local SizeX,SizeY = AbsoluteSize.X,AbsoluteSize.Y
		local PosX,PosY = AbsolutePosition.X,AbsolutePosition.Y
		
		--Add to the PosX and PosY.
		if SizeX > 0 then
			PosX = PosX + SizeX
		end
		if SizeY > 0 then
			PosY = PosY + SizeY
		end
		
		--Return the corner.
		return PosX,PosY
	end
	
	--[[
	Returns the visible frames.
	--]]
	local function GetVisibleFrames(ReferenceFrame,IgnoreFirstCheck)
		local Frames = {}
		
		--Return if the frame is invisible.
		if IgnoreFirstCheck ~= true and not ReferenceFrame.Visible then
			return {}
		end
		
		--Get the frames.
		table.insert(Frames,ReferenceFrame)
		for _,SubFrame in pairs(ReferenceFrame:GetChildren()) do
			if SubFrame:IsA("Frame") and SubFrame.Visible then
				for _,ChildFrame in pairs(GetVisibleFrames(SubFrame)) do
					table.insert(Frames,ChildFrame)
				end
			end
		end
		
		--Return the frames.
		return Frames
	end
	
	--[[
	Recalculates the bounding size of the frame.
	--]]
	local function RecalculateBoundingSize()
		--Return the size if both overrides are set.
		if SizeXOverride and SizeYOverride then
			return
		end
		
		--Get the starting position.
		local StartingPosX,StartingPosY = Frame.AbsolutePosition.X,Frame.AbsolutePosition.Y
		local MaxPosX,MaxPosY = StartingPosX,StartingPosY
		local SecondMaxPosX,SecondMaxPosY = StartingPosX,StartingPosY
		local NewBoundingFrameX,NewBoundingFrameY
		
		--Set the max position.
		for _,SubFrame in pairs(GetVisibleFrames(Frame,true)) do
			if SubFrame.Visible and SubFrame ~= Frame then
				local CornerPosX,CornerPosY = GetCornerPosition(SubFrame)
				
				--Update the max size X.
				if not SizeXOverride then
					if CornerPosX > MaxPosX then
						if MaxPosX > SecondMaxPosX then
							SecondMaxPosX = MaxPosX
							SecondaryBoundingFrameX = BoundingFrameX
						end
						MaxPosX = CornerPosX
						BoundingFrameX = SubFrame
					elseif CornerPosX > SecondMaxPosX then
						SecondMaxPosX = CornerPosX
					end
				end
				
				--Update the max size Y.
				if not SizeYOverride then
					if CornerPosY > MaxPosY then
						if MaxPosY > SecondMaxPosY then
							SecondMaxPosY = MaxPosY
							SecondaryBoundingFrameY = BoundingFrameY
						end
						MaxPosY = CornerPosY
					elseif CornerPosY > SecondMaxPosY then
						SecondMaxPosY = CornerPosY
						BoundingFrameY = SubFrame
					end
				end
			end
		end
		
		--Set the bounding size.
		SecondBoundingSizeX,SecondBoundingSizeY = SecondMaxPosX - StartingPosX,SecondMaxPosY - StartingPosY
		BoundingSizeX,BoundingSizeY = MaxPosX - StartingPosX,MaxPosY - StartingPosY
	end
	
	--[[
	Updates the bounding size.
	--]]
	local function UpdateBoundingSize()
		Frame.Size = UDim2.new(SizeXOverride or UDim.new(0,BoundingSizeX),SizeYOverride or UDim.new(0,BoundingSizeY))
	end
	
	--[[
	Disconnects the events when a frame is removed.
	--]]
	local function FrameRemoved(SubFrame)
		--Disconnect the connections.
		local Connections = FrameConnections[SubFrame]
		if Connections then
			for _,Connection in pairs(Connections) do
				Connection:Disconnect()
			end
			FrameConnections[SubFrame] = nil
		end
		
		--Update the bounding size.
		RecalculateBoundingSize()
		UpdateBoundingSize()
	end
	
	--[[
	Adds a new frame to track.
	--]]
	local function FrameAdded(SubFrame)
		if SubFrame:IsA("Frame") and not FrameConnections[SubFrame] then
			local LastSizeX,LastSizeY
			local LastPosX,LastPosY
			
			--[[
			Updates the size if it changes.
			--]]
			local function UpdateSize()
				--Get the current size.
				local Size,Position = SubFrame.Size,SubFrame.Position
				local SizeX,SizeY = Size.X,Size.Y
				local PosX,PosY = Position.X,Position.Y
				
				--Return if the non-overriden size hasn't changed.
				if (SizeXOverride and SizeYOverride) or (SizeX == LastSizeX and PosX == LastPosX and SizeYOverride) or (SizeY == LastSizeY and PosY == LastPosY and SizeXOverride) then
					return
				end
				
				--Update the last size.
				LastSizeX = SizeX
				LastSizeY = SizeY
				LastPosX = PosX
				LastPosY = PosY
				
				--Change the bounding size.
				local CornerPosX,CornerPosY = GetCornerPosition(SubFrame)
				local AbsoluteSizeX,AbsoluteSizeY = CornerPosX - Frame.AbsolutePosition.X,CornerPosY - Frame.AbsolutePosition.Y
				local RecalculateX,RecalculateY = false,false
				if SubFrame == BoundingFrameX then
					if AbsoluteSizeX > SecondBoundingSizeX then
						BoundingSizeX = AbsoluteSizeX
					else
						RecalculateX = true
					end
				elseif SubFrame == SecondaryBoundingFrameX then
					if AbsoluteSizeX > BoundingSizeX then
						SecondBoundingSizeX = BoundingSizeX
						BoundingSizeX = AbsoluteSizeX
					elseif AbsoluteSizeX < SecondBoundingSizeX then
						RecalculateX = true
					end
				elseif AbsoluteSizeX > BoundingSizeX then
					RecalculateX = true
				end
				
				if SubFrame == BoundingFrameY then
					if AbsoluteSizeY > SecondBoundingSizeY then
						BoundingSizeY = AbsoluteSizeY
					else
						RecalculateY = true
					end
				elseif SubFrame == SecondaryBoundingFrameY then
					if AbsoluteSizeY > BoundingSizeY then
						SecondBoundingSizeY = BoundingSizeY
						BoundingSizeY = AbsoluteSizeY
					elseif AbsoluteSizeY < SecondBoundingSizeY then
						RecalculateY = true
					end
				elseif AbsoluteSizeY > BoundingSizeY then
					RecalculateY = true
				end
				
				--Recalculate the bounding size if needed.
				if RecalculateX or RecalculateY then
					RecalculateBoundingSize()
				end
				
				--Update the bouding size.
				RecalculateBoundingSize()
				UpdateBoundingSize()
			end
			
			--[[
			Force-recalculates the size.
			--]]
			local function ForceRecalculateSize()
				RecalculateBoundingSize()
				UpdateBoundingSize()
			end
			
			--Add the connections.
			local Connections = {}
			local SizeManuallyChanged = false
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("Visible"):Connect(ForceRecalculateSize))
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("AbsoluteRotation"):Connect(UpdateSize)) --Hack that allows for updates with List Constraints
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("AnchorPoint"):Connect(UpdateSize))
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("Position"):Connect(UpdateSize))
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if not SizeManuallyChanged then
					UpdateSize()
				else
					SizeManuallyChanged = true
				end
			end))
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("Size"):Connect(function()
				SizeManuallyChanged = true
				UpdateSize()
			end))
			table.insert(Connections,SubFrame:GetPropertyChangedSignal("Parent"):Connect(function()
				if not SubFrame:IsDescendantOf(Frame) then
					FrameRemoved(SubFrame)
				else
					ForceRecalculateSize()
				end
			end))
			
			--Store the connections.
			FrameConnections[SubFrame] = Connections
		end
	end
	
	--Set up the connections for adding/removing frames.
	self.DescendantAddedConnection = Frame.DescendantAdded:Connect(function(Frame)
		FrameAdded(Frame)
		RecalculateBoundingSize()
		UpdateBoundingSize()
	end)
	
	--Set up the connections for overrides.
	self.SizeXOverrideConnection = self:GetPropertyChangedSignal("SizeXOverride"):Connect(function()
		SizeXOverride = self.SizeXOverride
		RecalculateBoundingSize()
		UpdateBoundingSize()
	end)
	self.SizeYOverrideConnection = self:GetPropertyChangedSignal("SizeYOverride"):Connect(function()
		SizeYOverride = self.SizeYOverride
		RecalculateBoundingSize()
		UpdateBoundingSize()
	end)
	
	--Add the frames.
	for _,Frame in pairs(Frame:GetDescendants()) do
		FrameAdded(Frame)
	end
	
	--Resize the frame.
	RecalculateBoundingSize()
	UpdateBoundingSize()
end

--[[
Destroys the constraint.
--]]
function NexusBoundingSizeConstraint:Destroy()
	--Disconnect the connections.
	self.DescendantAddedConnection:Disconnect()
	self.SizeXOverrideConnection:Disconnect()
	self.SizeYOverrideConnection:Disconnect()
	local Frames = {}
	for Frame,FrameConnections in pairs(self.FrameConnections) do
		table.insert(Frames,Frame)
		for _,Connection in pairs(FrameConnections) do
			Connection:Disconnect()
		end
	end
	
	--Clear the connections.
	for _,Frame in pairs(Frames) do
		self.FrameConnections[Frame] = nil
	end
end



return NexusBoundingSizeConstraint