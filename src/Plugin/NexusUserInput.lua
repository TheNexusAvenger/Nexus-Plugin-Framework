--[[
TheNexusAvenger

Static class for user input. Recommended to only use it
for key presses since the key presses are from all PluginGuis
and main viewport.
--]]

local CLASS_NAME = "NexusUserInput"

local INPUT_DELAY_TIME = 0.05



local UserInputService = game:GetService("UserInputService")
local PluginGuiService = game:GetService("PluginGuiService")

local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")

local NexusUserInput = NexusContainer:Extend()
NexusUserInput:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusUserInput)



--Create the events.
NexusUserInput.LastInputBeganTimes = {}
NexusUserInput.LastInputChangedTimes = {}
NexusUserInput.LastInputEndedTimes = {}
NexusUserInput.InputBegan = NexusEventCreator:CreateEvent()
NexusUserInput.InputChanged = NexusEventCreator:CreateEvent()
NexusUserInput.InputEnded = NexusEventCreator:CreateEvent()



--[[
Creates a User Input object.
--]]
function NexusUserInput:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	
	--Set up the context events.
	self.__ContextEvents = {}
	
	--Create the time checkers.
	self.LastInputBeganTimes = {}
	self.LastInputChangedTimes = {}
	self.LastInputEndedTimes = {}

	--Create the events.
	self.InputBegan = NexusEventCreator:CreateEvent()
	self.InputChanged = NexusEventCreator:CreateEvent()
	self.InputEnded = NexusEventCreator:CreateEvent()
end

--[[
Invoked when an input is began.
--]]
function NexusUserInput:OnInputBegan(InputObject,Processed)
	--Return if it was processed.
	if Processed then return end
	
	--Fire the event if it new.
	local LastTime = self.LastInputBeganTimes[InputObject] or 0
	local CurrentTime = tick()
	if CurrentTime - LastTime >= INPUT_DELAY_TIME then
		self.InputBegan:Fire(InputObject)
	end
	
	--Store the last time.
	self.LastInputBeganTimes[InputObject] = CurrentTime
end

--[[
Invoked when an input is changed.
--]]
function NexusUserInput:OnInputChanged(InputObject,Processed)
	--Return if it was processed.
	if Processed then return end
	
	--Fire the event if it new.
	local LastTime = self.LastInputChangedTimes[InputObject] or 0
	local CurrentTime = tick()
	if CurrentTime - LastTime >= INPUT_DELAY_TIME then
		self.InputChanged:Fire(InputObject)
	end
	
	--Store the last time.
	self.LastInputChangedTimes[InputObject] = CurrentTime
end

--[[
Invoked when an input is ended.
--]]
function NexusUserInput:OnInputEnded(InputObject,Processed)
	--Return if it was processed.
	if Processed then return end
	
	--Fire the event if it new.
	local LastTime = self.LastInputEndedTimes[InputObject] or 0
	local CurrentTime = tick()
	if CurrentTime - LastTime >= INPUT_DELAY_TIME then
		self.InputEnded:Fire(InputObject)
	end
	
	--Store the last time.
	self.LastInputEndedTimes[InputObject] = CurrentTime
end

--[[
Adds a context for getting inputs.
--]]
function NexusUserInput:AddContext(Frame)
	--Connect the events.
	local Events = {}
	table.insert(Events,Frame:ConnectToHighestParent("InputBegan",function(InputObject,Processed)
		self:OnInputBegan(InputObject,Processed)
	end))
	table.insert(Events,Frame:ConnectToHighestParent("InputChanged",function(InputObject,Processed)
		self:OnInputChanged(InputObject,Processed)
	end))
	table.insert(Events,Frame:ConnectToHighestParent("InputEnded",function(InputObject,Processed)
		self:OnInputEnded(InputObject,Processed)
	end))
	
	--Store the events.
	self.__ContextEvents[Frame] = Events
end

--[[
Removes a context for getting inputs.
--]]
function NexusUserInput:RemoveContext(Frame)
	--Disconnect the events.
	local Events = self.__ContextEvents[Frame]
	if Events then
		self.__ContextEvents[Frame] = nil
		for _,Event in pairs(Events) do
			Event:Disconnect()
		end
	end
end



--Connect the PluginGuis input events.
PluginGuiService.DescendantAdded:Connect(function(Frame)
	if Frame:IsA("GuiObject") then
		Frame.InputBegan:Connect(function(InputObject,Processed)
			NexusUserInput:OnInputBegan(InputObject,Processed)
		end)
		Frame.InputChanged:Connect(function(InputObject,Processed)
			NexusUserInput:OnInputChanged(InputObject,Processed)
		end)
		Frame.InputEnded:Connect(function(InputObject,Processed)
			NexusUserInput:OnInputEnded(InputObject,Processed)
		end)
	end
end)

--Connect the UserInputService.
UserInputService.InputBegan:Connect(function(InputObject,Processed)
	NexusUserInput:OnInputBegan(InputObject,Processed)
end)
UserInputService.InputChanged:Connect(function(InputObject,Processed)
	NexusUserInput:OnInputChanged(InputObject,Processed)
end)
UserInputService.InputEnded:Connect(function(InputObject,Processed)
	NexusUserInput:OnInputEnded(InputObject,Processed)
end)



return NexusUserInput