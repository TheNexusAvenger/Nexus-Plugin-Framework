--[[
TheNexusAvenger

Constraint that ensures only one list frame or certain
list frames based on the keys pressed are selected. Also
adds support for arrow keys.

TODO: The method for Shift isn't exactly correct compared
to the normal implementation.
--]]

local CLASS_NAME = "NexusSelectionConstraint"

local MIN_WAIT_TIME_FOR_ARROWS = 0.5
local INCREMENT_WAIT_TIME = 0.03



local NexusPluginFramework = require(script.Parent.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusUserInput = NexusPluginFramework:GetResource("Plugin.NexusUserInput")
local NexusCollapsableListFrameConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusCollapsableListFrameConstraint")

local NexusSelectionConstraint = NexusCollapsableListFrameConstraint:Extend()
NexusSelectionConstraint:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusSelectionConstraint)



--[[
Creates a Nexus Collapsable List Frame Selection Constraint object.
--]]
function NexusSelectionConstraint:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	
	--Set up checking for Control and Shift being pressed.
	local ControlPressed,ShiftPressed = false,false
	local KeyboardContext = NexusUserInput.new()
	local PressedEvents = {}
	
	--[[
	Sets up the inputs for a list frame.
	--]]
	local function ConnectPressedEvents(ListFrame)
		KeyboardContext:AddContext(ListFrame)
	end
	
	--[[
	Disconnects the events for a list frame.
	--]]
	local function DisconnectPressedEvents(ListFrame)
		KeyboardContext:RemoveContext(ListFrame)
	end
	self.ListFrameAdded:Connect(ConnectPressedEvents)
	self.ListFrameRemoved:Connect(DisconnectPressedEvents)
	
	--Connect the events for Control and Shift.
	NexusUserInput.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.LeftControl or Input.KeyCode == Enum.KeyCode.RightControl then
			ControlPressed = true
		elseif Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.RightShift then
			ShiftPressed = true
		end
	end)
	
	NexusUserInput.InputEnded:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.LeftControl or Input.KeyCode == Enum.KeyCode.RightControl then
			ControlPressed = false
		elseif Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.RightShift then
			ShiftPressed = false
		end
	end)
	
	--Connect the selection events.
	local UpPressStart,DownPressStart
	local SelectionOrder = {}
	local SelectionEvents = {}
	
	--[[
	Increments the selection.
	--]]
	local function IncrementSelection(IndexIncrement)
		--Get the base increment.
		local CurrentIndex
		local ListFrames = self:GetAllListFrames(true)
		local LastSelection = SelectionOrder[#SelectionOrder]
		if not LastSelection then
			LastSelection = ListFrames[1]
		end
		
		--Get the index of the first and new selection.
		for Index,Frame in pairs(ListFrames) do
			if Frame == LastSelection then
				CurrentIndex = Index
				break
			end
		end
		
		--Increment the selection.
		if CurrentIndex then
			local NextSelection = ListFrames[CurrentIndex + IndexIncrement]
			if NextSelection then
				if NextSelection.Selected then
					LastSelection.Selected = false
				else
					NextSelection.Selected = true
				end
			end
		end
	end
	
	--[[
	Updates the quick-increment direction.
	--]]
	local function UpdateIncrement()
		local Direction = 0
		
		--Determine the direction.
		if UpPressStart and tick() - UpPressStart > MIN_WAIT_TIME_FOR_ARROWS then
			Direction = Direction - 1
		end
		if DownPressStart and tick() - DownPressStart > MIN_WAIT_TIME_FOR_ARROWS then
			Direction = Direction + 1
		end
		
		--If the direction isn't 0, move the selection.
		if Direction ~= 0 then
			IncrementSelection(Direction)
		end
	end
	
	--Connect the events for up and down.
	KeyboardContext.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.Up then
			--Move the selection up.
			local StartTime = tick()
			UpPressStart = StartTime
			IncrementSelection(-1)
			wait(MIN_WAIT_TIME_FOR_ARROWS)
			
			--Start the loop for the up key.
			while UpPressStart == StartTime do
				UpdateIncrement()
				wait(INCREMENT_WAIT_TIME)
			end
		elseif Input.KeyCode == Enum.KeyCode.Down then
			--Move the selection down.
			local StartTime = tick()
			DownPressStart = StartTime
			IncrementSelection(1)
			wait(MIN_WAIT_TIME_FOR_ARROWS)
			
			--Start the loop for the down key.
			while DownPressStart == StartTime do
				UpdateIncrement()
				wait(INCREMENT_WAIT_TIME)
			end
		end
	end)
	
	KeyboardContext.InputEnded:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.Up then
			UpPressStart = nil
		elseif Input.KeyCode == Enum.KeyCode.Down then
			DownPressStart = nil
		end
	end)
	
	--[[
	Connects the events for a list frame.
	--]]
	local function ConnectSelectionChanged(ListFrame)
		local Events = {}
		
		--Unselect the frame.
		if ListFrame.Selected then
			if not self.AllowMultipleSelections and #SelectionOrder >= 1 then
				ListFrame.Selected = false
			else
				table.insert(SelectionOrder,ListFrame)
			end
		end
		
		--Connect the selection changed events.
		table.insert(Events,ListFrame:GetPropertyChangedSignal("Selected"):Connect(function()
			local Selected = ListFrame.Selected
			if Selected then
				--Set the selection.
				if self.AllowMultipleSelections and (ControlPressed or ShiftPressed) then
					--Add the selection.
					table.insert(SelectionOrder,ListFrame)
					
					--Select the range.
					if ShiftPressed and SelectionOrder[1] ~= ListFrame then
						local ListFrames = self:GetAllListFrames(true)
						local FirstSelection = SelectionOrder[1]
						
						--Get the index of the first and new selection.
						local FirstIndex,CurrentIndex
						for Index,Frame in pairs(ListFrames) do
							if Frame == FirstSelection then
								FirstIndex = Index
							elseif Frame == ListFrame then
								CurrentIndex = Index
							end
							
							if FirstIndex and CurrentIndex then
								break
							end
						end
						
						--Return if an index is missing.
						if not FirstIndex or not CurrentIndex or FirstIndex == CurrentIndex then
							return
						end
						
						--Swap the indexes if the current is less than the first.
						if FirstIndex > CurrentIndex then
							FirstIndex,CurrentIndex = CurrentIndex,FirstIndex
						end
						
						--Select the frames.
						for i = FirstIndex + 1,CurrentIndex - 1 do
							ListFrames[i].Selected = true
						end
					end
				else
					--Deselect the frames.
					local OldSelectionOrder = SelectionOrder
					SelectionOrder = {}
					for _,Frame in pairs(OldSelectionOrder) do
						if Frame ~= ListFrame then
							Frame.Selected = false
						end
					end
					
					--Select the frame.
					SelectionOrder = {ListFrame}
				end
			else
				--Remove the index.
				local IndexToRemove
				for i,Frame in pairs(SelectionOrder) do
					if Frame == ListFrame then
						IndexToRemove = i
						break
					end
				end
				
				if IndexToRemove then
					table.remove(SelectionOrder,IndexToRemove)
				end
			end
		end))
		
		--Store the events.
		SelectionEvents[ListFrame] = Events
	end
	
	--[[
	Connects the events for a list frame being added.
	--]]
	local function ConnectSelectionAdded(ListFrame)
		--Connect the events.
		ConnectSelectionChanged(ListFrame)
		
		--Connect the descendants.
		for _,Frame in pairs(ListFrame:GetCollapsableContainer():GetDescendants()) do
			ConnectSelectionChanged(Frame)
		end
		
		--Connect the descendant added and removed events.
		local Events = SelectionEvents[ListFrame]
		table.insert(Events,ListFrame:GetCollapsableContainer().DescendantAdded:Connect(function(Descendant)
			ConnectSelectionChanged(Descendant)
		end))
		
		table.insert(Events,ListFrame.DescendantRemoving:Connect(function(Descendant)
			local Events = SelectionEvents[Descendant]
			if Events then
				for _,Event in pairs(Events) do
					Event:Disconnect()
				end
				SelectionEvents[Descendant] = nil
			end
		end))
	end
	
	--[[
	Connects the events for a list frame being removed.
	--]]
	local function ConnectSelectionRemoved(ListFrame)
		--Disconnect the events.
		local Events = SelectionEvents[ListFrame]
		if Events then
			for _,Event in pairs(Events) do
				Event:Disconnect()
			end
			SelectionEvents[ListFrame] = nil
		end
		
		--Disconnect the events of the descendants.
		for _,Frame in pairs(ListFrame:GetDescendants()) do
			if Frame:IsA("NexusCollapsableListFrame") then
				local Events = SelectionEvents[Frame]
				if Events then
					for _,Event in pairs(Events) do
						Event:Disconnect()
					end
					SelectionEvents[Frame] = nil
				end
			end
		end
	end
	self.ListFrameAdded:Connect(ConnectSelectionAdded)
	self.ListFrameRemoved:Connect(ConnectSelectionRemoved)
	
	--Connect the property changes.
	self:GetPropertyChangedSignal("AllowMultipleSelections"):Connect(function()
		--If allowing multiple selections was disabled, disable all but the first selection.
		if not self.AllowMultipleSelections then
			--Deselect the frames.
			local OldSelectionOrder = SelectionOrder
			SelectionOrder = {SelectionOrder[1]}
			for i,Frame in pairs(OldSelectionOrder) do
				if i ~= 1 then
					Frame.Selected = false
				end
			end
		end
	end)
	
	--Set the default properties.
	self.AllowMultipleSelections = false
end



return NexusSelectionConstraint