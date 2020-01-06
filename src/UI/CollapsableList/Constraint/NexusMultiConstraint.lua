--[[
TheNexusAvenger

Helper class that applies multiple constraints as one
constraint.
--]]

local CLASS_NAME = "NexusMultiConstraint"



local NexusPluginFramework = require(script.Parent.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusCollapsableListFrameConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusCollapsableListFrameConstraint")

local NexusMultiConstraint = NexusCollapsableListFrameConstraint:Extend()
NexusMultiConstraint:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusMultiConstraint)



--[[
Creates a Nexus Collapsable List Frame Multi Constraint object.
--]]
function NexusMultiConstraint:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	self.__Constraints = {}
end

--[[
Adds a constraint.
--]]
function NexusMultiConstraint:AddConstraint(Constraint)
	--Add the constraint.
	table.insert(self.__Constraints,Constraint)
	
	--Add the existing frames.
	for i,Frame in pairs(self:GetListFrames()) do
		Constraint:AddListFrame(Frame,i)
	end
end

--[[
Adds a list frame to the constraint.
--]]
function NexusMultiConstraint:AddListFrame(ListFrame,Index)
	self.super:AddListFrame(ListFrame,Index)
	
	--Add the frame to the constraints.
	for _,Constraint in pairs(self.__Constraints) do
		Constraint:AddListFrame(ListFrame,Index)
	end
end

--[[
Removes a list frame to the constraint.
--]]
function NexusMultiConstraint:RemoveListFrame(ListFrame)
	self.super:RemoveListFrame(ListFrame)
	
	--Remove the frame from the constraints.
	for _,Constraint in pairs(self.__Constraints) do
		Constraint:RemoveListFrame(ListFrame)
	end
end

--[[
Removes all of the list frames to the constraint.
--]]
function NexusMultiConstraint:ClearListFrames()
	self.super:ClearListFrames()
	
	--Clear the frames from the constraints.
	for _,Constraint in pairs(self.__Constraints) do
		Constraint:ClearListFrames()
	end
end



return NexusMultiConstraint