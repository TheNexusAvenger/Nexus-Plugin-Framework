--[[
TheNexusAvenger

Mirrors the API of Roblox Instances for containing children and being parented.
--]]

local CLASS_NAME = "NexusContainer"

local INFINITE_YEILD_DELAY = 5



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local OverridableIndexInstance = NexusPluginFramework:GetResource("Base.OverridableIndexInstance")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")
local NexusConnection = NexusPluginFramework:GetResource("NexusInstance.Event.NexusConnection")

local NexusContainer = OverridableIndexInstance:Extend()
NexusContainer:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusContainer)



--[[
Creates a Nexus Container object.
--]]
function NexusContainer:__new()
	self:InitializeSuper()
	
	self.__Children = {}
	self.__DescendantEvents = {}
	self.__EventsToClear = {}
	self.__ConnectionsToClear = {}
	self.Name = self.ClassName
	self.Archivable = true
	self.Hidden = false
	
	--Create the events.
	self.AncestryChanged = NexusEventCreator:CreateEvent()
	table.insert(self.__EventsToClear,self.AncestryChanged)
	self.ChildAdded = NexusEventCreator:CreateEvent()
	table.insert(self.__EventsToClear,self.ChildAdded)
	self.ChildRemoved = NexusEventCreator:CreateEvent()
	table.insert(self.__EventsToClear,self.ChildRemoved)
	self.DescendantAdded = NexusEventCreator:CreateEvent()
	table.insert(self.__EventsToClear,self.DescendantAdded)
	self.DescendantRemoving = NexusEventCreator:CreateEvent()
	table.insert(self.__EventsToClear,self.DescendantRemoving)
	
	--Set up changed property tracking.
	self.__ChangedProperties = {}
	table.insert(self.__ConnectionsToClear,self.Changed:Connect(function(Property)
		self.__ChangedProperties[Property] = self[Property]
	end))
	
	--Set up parent changes.
	self:__InitParentChanges()
end

--[[
Initializes changes to teh parent structure.
--]]
function NexusContainer:__InitParentChanges()
	--Set self as the root object.
	self = self.object
	
	--Set up changing the parent.
	local LastParent,LastAncestryChangedEvent
	table.insert(self.__ConnectionsToClear,self:GetPropertyChangedSignal("Parent"):Connect(function()
		local NewParent = self.Parent
		
		--Disconnect the last event.
		if LastAncestryChangedEvent then
			LastAncestryChangedEvent:Disconnect()
			LastAncestryChangedEvent = nil
		end
		
		--Register the new parent.
		if NewParent and NewParent:IsA(CLASS_NAME) then
			NewParent:__ChildAdded(self)
			
			LastAncestryChangedEvent = NewParent.AncestryChanged:Connect(function(Child,Parent)
				self.AncestryChanged:Fire(Child,Parent)
			end)
		end
		
		--Unregister the old parent.
		if LastParent and LastParent:IsA(CLASS_NAME) then
			LastParent:__ChildRemoved(self)
		end
		
		--Fire the ancestry changed event.
		self.AncestryChanged:Fire(self,NewParent)
		
		--Set the last parent as the new parent.
		LastParent = NewParent
	end))
end

--[[
Returns the object as a string.
--]]
function NexusContainer:__tostring()
	return tostring(self.Name)
end

--[[
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used.
--]]
function NexusContainer:__getindex(IndexName,OriginalReturn)
	--Return a child if one exists.
	if OriginalReturn == nil and IndexName ~= "__Children" and IndexName ~= "Name" then
		for _,Child in pairs(self.__Children or {}) do
			if Child.Name == IndexName then
				return Child
			end
		end
	end
	
	--Return the parent.
	return NexusContainer.super.__getindex(self.super,IndexName,OriginalReturn)
end

--[[
Clones the properties to another object.
--]]
function NexusContainer:__CloneProperties(TargetContainer,InstanceMap)
	for Name,Value in pairs(self.__ChangedProperties) do
		if Name ~= "Parent" and string.sub(Name,1,2) ~= "__" then
			if typeof(Value) == "table" and Value.IsA and Value:IsA(CLASS_NAME) then
				TargetContainer[Name] = InstanceMap[Value] or Value
			else
				TargetContainer[Name] = Value
			end
		end
	end
end

--[[
Returns a pre-initialized clone. Only the constructor
should be run with all properties added afterwards
except those starting with "__".
--]]
function NexusContainer:__PreInitializeClone()
	return NexusContainer.new()
end

--[[
Recursively clones the instance and
returns the new instance and a map of the
old instances to the new ones.
--]]
function NexusContainer:__RecursiveClone()
	--Return if Archivable is false.
	if self.Archivable == false then
		return nil,{}
	end
	
	--Clone the instance.
	local InstanceMap = {}
	local NewContainer = self:__PreInitializeClone()
	InstanceMap[self] = NewContainer
	
	--Clone the children.
	for _,Child in pairs(self:GetChildren()) do
		--Throw an error if the child already exists.
		if InstanceMap[Child] then
			error("Structure is recursive. Cloning will not work.")
		end
		
		--Add the clone.
		local Clone,CloneMap = Child:__RecursiveClone()
		if Clone then
			Clone.Parent = NewContainer 
		end
		
		--Add the mirror instances.
		for OldInstance,NewInstance in pairs(CloneMap) do
			InstanceMap[OldInstance] = NewInstance
		end
	end
	
	--Return the new instance and the map.
	return NewContainer,InstanceMap
end

--[[
Invoked when a child is added.
--]]
function NexusContainer:__ChildAdded(Child)
	--Return if the child exists.
	for i,OtherChild in pairs(self.__Children) do
		if Child == OtherChild then
			return
		end
	end
	
	--Add the child.
	table.insert(self.__Children,Child)
	
	--Fire the events.
	if not Child.Hidden then
		self.ChildAdded:Fire(Child)
		self.DescendantAdded:Fire(Child)
	end
	
	--Set up the descendant events for the child.
	local ChildDescendantAddedEvent = Child.DescendantAdded:Connect(function(OtherChild)
		if not Child.Hidden then
			self.DescendantAdded:Fire(OtherChild)
		end
	end)
	local ChildDescendantRemovingEvent = Child.DescendantRemoving:Connect(function(OtherChild)
		if not Child.Hidden then
			self.DescendantRemoving:Fire(OtherChild)
		end
	end)
	
	self.__DescendantEvents[Child] = {ChildDescendantAddedEvent,ChildDescendantRemovingEvent}
end

--[[
Invoked when a child is removed.
--]]
function NexusContainer:__ChildRemoved(Child)
	--Remove the child.
	local IndexToRemove 
	for i,OtherChild in pairs(self.__Children) do
		if Child == OtherChild then
			IndexToRemove = i
		end
	end
	if IndexToRemove then
		table.remove(self.__Children,IndexToRemove)
	end
	
	--Fire the events.
	if not Child.Hidden then
		self.ChildRemoved:Fire(Child)
		self.DescendantRemoving:Fire(Child)
		
		--Fire the DescendantRemoving for the children.
		for _,SubChild in pairs(Child:GetDescendants()) do
			self.DescendantRemoving:Fire(SubChild)
		end
	end
	
	--Disconnect the child descendant events.
	local ChildEvents = self.__DescendantEvents[Child]
	if ChildEvents then
		for _,Event in pairs(ChildEvents) do
			Event:Disconnect()
		end
		
		self.__DescendantEvents[Child] = nil
	end
end

--[[
This function destroys all of an NexusContainer's children.
--]]
function NexusContainer:ClearAllChildren()
	--Destroy the children.
	for _,Child in pairs(self:GetChildren()) do
		Child:Destroy()
	end
end

--[[
Create a deep copy of a NexusContainer and
descendants where Archivable = true.
--]]
function NexusContainer:Clone()
	--Return if Archivable is false.
	if self.Archivable == false then
		return
	end
	
	--Clone the instances.
	local NewInstance,InstanceMap = self:__RecursiveClone()
	
	--Apply the properties.
	for OldInstance,NewInstance in pairs(InstanceMap) do
		OldInstance:__CloneProperties(NewInstance,InstanceMap)
	end
	
	--Return the new container.
	return NewInstance
end

--[[
Sets the NexusContainer.Parent property to nil,
locks the NexusContainer.Parent property,
and calls Destroy on all children.
--]]
function NexusContainer:Destroy()
	--Set the parent to nil and lock the property.
	self.Parent = nil
	self:LockProperty("Parent")
	
	--Disconnect the events.
	for _,Event in pairs(self.__EventsToClear) do
		Event:Disconnect()
	end
	for _,Connection in pairs(self.__ConnectionsToClear) do
		Connection:Disconnect()
	end
	self.__EventsToClear = {}
	self.__ConnectionsToClear = {}
	
	--Destroy the children.
	self:ClearAllChildren()
end

--[[
Returns the first ancestor of the NexusContainer
whose NexusContainer.Name is equal to the given
name.
--]]
function NexusContainer:FindFirstAncestor(Name)
	--Return nil if the parent is nil.
	if self.Parent == nil then
		return nil
	end
	
	--Return the parent if the parent matches the name.
	local Parent = self.Parent
	if Parent.Name == Name then
		return Parent
	end
	
	--Return the parent.
	return Parent:FindFirstAncestor(Name)
end

--[[
Returns the first ancestor of the NexusContainer
whose NexusContainer.ClassName is equal to the
given className.
--]]
function NexusContainer:FindFirstAncestorOfClass(ClassName)
	--Return nil if the parent is nil.
	if self.Parent == nil then
		return nil
	end
	
	--Return the parent if the parent matches the class name.
	local Parent = self.Parent
	if Parent.ClassName == ClassName then
		return Parent
	end
	
	--Return the parent.
	return Parent:FindFirstAncestorOfClass(ClassName)
end

--[[
Returns the first ancestor of the NexusContainer for whom
NexusContainer:IsA returns true for the given ClassName.
--]]
function NexusContainer:FindFirstAncestorWhichIsA(ClassName)
	--Return nil if the parent is nil.
	if self.Parent == nil then
		return nil
	end
	
	--Return the parent if the parent matches the class name.
	local Parent = self.Parent
	if Parent:IsA(ClassName) then
		return Parent
	end
	
	--Return the parent.
	return Parent:FindFirstAncestorWhichIsA(ClassName)
end

--[[
Returns the first child of the NexusContainer found with
the given name.
--]]
function NexusContainer:FindFirstChild(Name,Recursive)
	--Return if a direct child has the name.
	for _,Child in pairs(self:GetChildren()) do
		if Child.Name == Name then
			return Child
		end
	end
	
	--If it is recursive, return a subchild.
	if Recursive then
		for _,Child in pairs(self:GetChildren()) do
			local Match = Child:FindFirstChild(Name,Recursive)
			if Match then
				return Match
			end
		end
	end
end

--[[
Returns the first child of the NexusContainer whose ClassName
is equal to the given ClassName.
--]]
function NexusContainer:FindFirstChildOfClass(ClassName)
	--Return if a direct child has the class name.
	for _,Child in pairs(self:GetChildren()) do
		if Child.ClassName == ClassName then
			return Child
		end
	end
end

--[[
Returns the first child of the NexusContainer for whom 
NexusContainer:IsA returns true for the given ClassName.
--]]
function NexusContainer:FindFirstChildWhichIsA(ClassName,Recursive)
	--Return if a direct child has the class.
	for _,Child in pairs(self:GetChildren()) do
		if Child:IsA(ClassName) then
			return Child
		end
	end
	
	--If it is recursive, return a subchild.
	if Recursive then
		for _,Child in pairs(self:GetChildren()) do
			local Match = Child:FindFirstChildWhichIsA(ClassName,Recursive)
			if Match then
				return Match
			end
		end
	end
end

--[[
Returns an array containing all of the NexusContainers's
children.
--]]
function NexusContainer:GetChildren()
	local Children = {}
	
	--Clone the non-hidden children table.
	for _,Child in pairs(self.__Children) do
		if not Child.Hidden then
			table.insert(Children,Child)
		end
	end
	
	--Return the children.
	return Children
end

--[[
Returns an array containing all of the descendants of the
NexusContainer.
--]]
function NexusContainer:GetDescendants()
	local Children = {}
	
	--Add the children and descendants.
	for _,Child in pairs(self.__Children) do
		if not Child.Hidden then
			table.insert(Children,Child)
			for _,SubChild in pairs(Child:GetDescendants()) do
				table.insert(Children,SubChild)
			end
		end
	end
	
	--Return the children.
	return Children
end

--[[
Returns a string describing the NexusContainer's ancestry.
--]]
function NexusContainer:GetFullName()
	if self.Parent then
		return self.Parent:GetFullName().."."..self.Name
	else
		return self.Name
	end
end

--[[
Returns true if an NexusContainer is an ancestor of the given
descendant.
--]]
function NexusContainer:IsAncestorOf(OtherContainer)
	--Return false if the parent is nil.
	if not OtherContainer or not OtherContainer.Parent then
		return false
	end
	
	--Return true if the parent is the false.
	if OtherContainer.Parent == self then
		return true
	end
	
	--Return if the parent is an ancestor.
	return self:IsAncestorOf(OtherContainer.Parent)
end

--[[
Returns true if an NexusContainer is a descendant of the given
ancestor.
--]]
function NexusContainer:IsDescendantOf(OtherContainer)
	--Return false if the parent is nil.
	if not OtherContainer or not self.Parent then
		return false
	end
	
	--Return true if the parent is the false.
	if self.Parent == OtherContainer then
		return true
	end
	
	--Return if the parent is an ancestor.
	return self.Parent:IsDescendantOf(OtherContainer)
end

--[[
Returns the child of the NexusContainer with the given name.
If the child does not exist, it will yield the current thread
until it does.
--]]
function NexusContainer:WaitForChild(Name,TimeOut)
	local StartTime = tick()
	local WarningDisplayed = false
	
	--Run the loop until it returns.
	while true do
		--Return if the patch exists.
		local Child = self:FindFirstChild(Name)
		if Child then
			return Child
		end
		
		--Handle a timeout or infinite yield.
		if TimeOut then
			if tick() - StartTime >= TimeOut then
				return nil
			end
		elseif not WarningDisplayed and tick() - StartTime >= INFINITE_YEILD_DELAY then
			WarningDisplayed = true
			warn("Infinite yield possible on '"..self:GetFullName()..":WaitForChild(\""..Name.."\")'")
		end
		wait()
	end
end

--[[
Connects an event to the highest parent. If the ancestry
changes, the connected event changes. Returns a connection. 
--]]
function NexusContainer:ConnectToHighestParent(EventName,ConnectionFunction)
	--Create the connection.
	local Connection = NexusConnection.new(nil,ConnectionFunction)
	local CurrentConnection
	
	--[[
	Attempts to connect the event to the object.
	--]]
	local function AttemptConnection(Object)
		--Connect the event.
		local Worked,Return = pcall(function()
			local Event = Object[EventName]
			if not Event then
				return false
			else
				CurrentConnection = Event:Connect(ConnectionFunction)
				return true
			end
		end)
		if Worked then return Return end
			
		--Return false (failed).
		return false
	end
	
	--[[
	Returns true if the parent was connected.
	--]]
	local function ConnectParent(Object)
		--Return false if the event is disconnected.
		if not Connection.Connected then
			return false
		end
		
		--Return false, attempt connecting.
		local Parent = Object.Parent
		if not Parent then
			return AttemptConnection(Object)
		end
		
		--Return if the parent was connected.
		if Parent and ConnectParent(Parent) then
			return true
		end
		
		--Connect the event.
		return AttemptConnection(Object)
	end
	
	self.AncestryChanged:Connect(function()
		--Disconnect the current connection.
		if CurrentConnection then
			CurrentConnection:Disconnect()
			CurrentConnection = nil
		end
		
		--Reconnect the event.
		ConnectParent(self)
	end)
	ConnectParent(self)
	
	--Return the connection.
	return Connection
end



return NexusContainer