--[[
TheNexusAvenger

Abstract class for a constraint on list frames.
--]]

local CLASS_NAME = "NexusCollapsableListFrameConstraint"



local NexusPluginFramework = require(script.Parent.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")

local NexusCollapsableListFrameConstraint = NexusContainer:Extend()
NexusCollapsableListFrameConstraint:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusCollapsableListFrameConstraint)



--[[
Creates a Nexus Collapsable List Frame Constraint object.
--]]
function NexusCollapsableListFrameConstraint:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	self.__ListFrames = {}
	
	--Create the events.
	self.ListFrameAdded = NexusEventCreator:CreateEvent()
	self.ListFrameRemoved = NexusEventCreator:CreateEvent()
	self.ListFramesUpdated = NexusEventCreator:CreateEvent()
end

--[[
Returns if the constraint contains the list frame.
--]]
function NexusCollapsableListFrameConstraint:ContainsListFrame(ListFrame)
	--Return true if the list frame exists.
	for Key,Value in pairs(self.__ListFrames) do
		if Value == ListFrame then
			return true
		end
	end
	
	--Return false (not contained).
	return false
end

--[[
Returns the list frames part of the constraint.
--]]
function NexusCollapsableListFrameConstraint:GetListFrames()
	--Clone the table.
	local ListFrames = {}
	for Key,Value in pairs(self.__ListFrames) do
		ListFrames[Key] = Value
	end
	
	--Return the table.
	return ListFrames
end

--[[
Returns all of the list frames in the constraint.
--]]
function NexusCollapsableListFrameConstraint:GetAllListFrames(OnlyShowVisible)
	local ListFrames = {}
	
	--[[
	Adds a child frame.
	--]]
	local function AddFrame(Frame)
		--Return if it isn't a frame.
		if not Frame:IsA("NexusCollapsableListFrame") then
			return
		end
		
		--Add the frame.
		if Frame.Visible then
			table.insert(ListFrames,Frame)
			
			--Add the children if it is expanded or all are added.
			if OnlyShowVisible ~= true or Frame.Expanded then
				for _,SubFrame in pairs(Frame:GetCollapsableContainer():GetChildren()) do
					AddFrame(SubFrame)
				end
			end
		end
	end
	
	--Add the frames.
	for _,Frame in pairs(self.__ListFrames) do
		AddFrame(Frame)
	end
	
	--Return the table.
	return ListFrames
end

--[[
Sorts the list frames using a given function.
--]]
function NexusCollapsableListFrameConstraint:SortListFrames(SortFunction)
	--Sort the list frames.
	table.sort(self.__ListFrames,SortFunction)
	
	--Fire the updated event.
	self.ListFramesUpdated:Fire()
end
--[[
Adds a list frame to the constraint.
--]]
function NexusCollapsableListFrameConstraint:AddListFrame(ListFrame,Index)
	--Return if the list frame is in the constraint.
	if self:ContainsListFrame(ListFrame) then
		return
	end
	
	--Insert the list frame.
	if Index then
		table.insert(self.__ListFrames,Index,ListFrame)
	else
		table.insert(self.__ListFrames,ListFrame)
	end
	
	--Fire the updated events.
	self.ListFrameAdded:Fire(ListFrame)
	self.ListFramesUpdated:Fire()
end

--[[
Removes a list frame to the constraint.
--]]
function NexusCollapsableListFrameConstraint:RemoveListFrame(ListFrame)
	--Get the index.
	local Index
	for Key,Value in pairs(self.__ListFrames) do
		if Value == ListFrame then
			Index = Key
			break
		end
	end
	
	--Remove the index if it exists and fire the events.
	if Index then
		table.remove(self.__ListFrames,Index)
		self.ListFrameRemoved:Fire(ListFrame)
		self.ListFramesUpdated:Fire()
	end
end

--[[
Removes all of the list frames to the constraint.
--]]
function NexusCollapsableListFrameConstraint:ClearListFrames()
	local ListFrames = self:GetListFrames()
	
	--Clear the list frames.
	self.__ListFrames = {}
	for _,ListFrame in pairs(ListFrames) do
		self.ListFrameRemoved:Fire(ListFrame)
	end
	
	--Fire the updated event.
	self.ListFramesUpdated:Fire()
end



return NexusCollapsableListFrameConstraint