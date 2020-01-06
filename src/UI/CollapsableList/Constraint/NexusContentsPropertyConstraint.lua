--[[
TheNexusAvenger

Constraint that passes through certain properties (Disabled
and Selected) to the frames parented to the main contents frame
of list frames.
--]]

local CLASS_NAME = "NexusContentsPropertyConstraint"



local NexusPluginFramework = require(script.Parent.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")
local NexusCollapsableListFrameConstraint = NexusPluginFramework:GetResource("UI.CollapsableList.Constraint.NexusCollapsableListFrameConstraint")

local NexusContentsPropertyConstraint = NexusCollapsableListFrameConstraint:Extend()
NexusContentsPropertyConstraint:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusContentsPropertyConstraint)



--[[
Creates a Nexus Collapsable List Frame Contents Property Constraint object.
--]]
function NexusContentsPropertyConstraint:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	
	local GlobalListFrameConnections = {}
	
	--[[
	Updates the properties of the contents of the contents of a list frame.
	--]]
	local function UpdateListFrameContainerPrperties(ListFrame)
		local Selected,Disabled = ListFrame.Selected,ListFrame.Disabled
		for _,Frame in pairs(ListFrame:GetMainContainer():GetDescendants()) do
			if Frame:IsA("NexusWrappedInstance") then
				Frame.Selected = Selected
				Frame.Disabled = Disabled
			end
		end
	end
	
	--[[
	Handles a list frame being added.
	--]]
	local function ListFrameAdded(ListFrame)
		local ListFrameConnections = {}
		
		--Connect the events.
		local Events = {}
		table.insert(Events,ListFrame:GetCollapsableContainer().DescendantAdded:Connect(function(ListFrame)
			if ListFrame:IsA("NexusCollapsableListFrame") then
				--Connect the events.
				local Events = {}
				table.insert(Events,ListFrame:GetMainContainer().ChildAdded:Connect(function()
					UpdateListFrameContainerPrperties(ListFrame)
				end))
				table.insert(Events,ListFrame:GetPropertyChangedSignal("Disabled"):Connect(function()
					UpdateListFrameContainerPrperties(ListFrame)
				end))
				table.insert(Events,ListFrame:GetPropertyChangedSignal("Selected"):Connect(function()
					UpdateListFrameContainerPrperties(ListFrame)
				end))
				
				--Store the events.
				ListFrameConnections[ListFrame] = Events
				
				--Update the list frame properties.
				UpdateListFrameContainerPrperties(ListFrame)
			end
		end))
		table.insert(Events,ListFrame:GetCollapsableContainer().DescendantRemoving:Connect(function(ListFrame)
			local Events = ListFrameConnections[ListFrame]
			if Events then
				ListFrameConnections[ListFrame] = nil
				for _,Event in pairs(Events) do
					Event:Disconnect()
				end
			end
		end))
		table.insert(Events,ListFrame:GetMainContainer().ChildAdded:Connect(function()
			UpdateListFrameContainerPrperties(ListFrame)
		end))
		table.insert(Events,ListFrame:GetPropertyChangedSignal("Disabled"):Connect(function()
			UpdateListFrameContainerPrperties(ListFrame)
		end))
		table.insert(Events,ListFrame:GetPropertyChangedSignal("Selected"):Connect(function()
			UpdateListFrameContainerPrperties(ListFrame)
		end))
		
		--Store the events.
		GlobalListFrameConnections[ListFrame] = Events
		
		--Update the list frame properties.
		UpdateListFrameContainerPrperties(ListFrame)
	end
	
	--[[
	Handles a list frame being removed.
	--]]
	local function ListFrameRemoved(ListFrame)
		local Events = GlobalListFrameConnections[ListFrame]
		if Events then
			GlobalListFrameConnections[ListFrame] = nil
			for _,Event in pairs(Events) do
				Event:Disconnect()
			end
		end
	end
	
	--Connect the events.
	self.ListFrameAdded:Connect(ListFrameAdded)
	self.ListFrameRemoved:Connect(ListFrameRemoved)
end



return NexusContentsPropertyConstraint