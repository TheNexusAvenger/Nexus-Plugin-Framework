--[[
TheNexusAvenger

Wraps a Roblox Instance with the NexusContainer API.
--]]

local CLASS_NAME = "NexusWrappedInstance"

local INSTANCE_CREATION_PRESETS = {
	Frame = {
		BackgroundColor3 = "MainBackground",
		BorderColor3 = "Border",
		BorderSizePixel = 0,
	},
	TextLabel = {
		BackgroundTransparency = 1,
		TextColor3 = "MainText",
		TextXAlignment = "Left",
		Font = "SourceSans",
		TextSize = 14,
	},
	TextButton = {
		BackgroundColor3 = "Button",
		BorderColor3 = "ButtonBorder",
		BorderSizePixel = 1,
		TextColor3 = "ButtonText",
		Font = "SourceSans",
		TextSize = 14,
	},
	TextBox = {
		BackgroundColor3 = "InputFieldBackground",
		BorderColor3 = "InputFieldBorder",
		BorderSizePixel = 1,
		TextColor3 = "MainText",
		PlaceholderColor3 = "DimmedText",
		TextXAlignment = "Left",
		Font = "SourceSans",
		TextSize = 14,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
	}
}



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusDisablableContainer = NexusPluginFramework:GetResource("Base.NexusDisablableContainer")
local NexusPlugin = NexusPluginFramework:GetResource("Plugin.NexusPlugin")
local NexusSettings = NexusPluginFramework:GetResource("Plugin.NexusSettings")

local NexusWrappedInstance = NexusDisablableContainer:Extend()
NexusWrappedInstance:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusWrappedInstance)

local ReadOnlyProperties = {}
local Settings = NexusSettings.GetSettings()

local CachedInstances = {}
setmetatable(CachedInstances,{__mode="v"})
NexusWrappedInstance.CachedInstances = CachedInstances



--[[
Replaces an instance or table of instances with 
wrapped instances.
--]]
local function ReplaceInstances(InstanceOrTable)
	--Replace the Instance if it is an instance.
	if typeof(InstanceOrTable) == "Instance" then
		return NexusWrappedInstance.GetInstance(InstanceOrTable)
	end
	
	--Replace parts of the table if it is a table.
	if typeof(InstanceOrTable) == "table" then
		for Key,Value in pairs(InstanceOrTable) do
			InstanceOrTable[Key] = ReplaceInstances(Value)
		end
	end
	
	--Return the original type.
	return InstanceOrTable
end

--[[
Unwraps a NexusContainer or table of NexusContainers with 
unwrapped instances.
--]]
local function UnwrapInstances(ContainerOrTable)
	--Replace parts of the table if it is a table or unwrap the instance if it is a container.
	if typeof(ContainerOrTable) == "table" then
		if ContainerOrTable.IsA and ContainerOrTable:IsA(CLASS_NAME) then
			return ContainerOrTable:GetWrappedInstance()
		else
			for Key,Value in pairs(ContainerOrTable) do
				ContainerOrTable[Key] = UnwrapInstances(Value)
			end
		end
	end
	
	--Return the original type.
	return ContainerOrTable
end



--[[
Gets a Nexus Wrapped Instance.
--]]
function NexusWrappedInstance.GetInstance(ExistingInstance)
	--Create the string instance or create the cached instance if needed.
	local CachedInstance = CachedInstances[ExistingInstance]
	if typeof(ExistingInstance) == "string" then
		CachedInstance = NexusWrappedInstance.new(ExistingInstance)
		CachedInstances[CachedInstance:GetWrappedInstance()] = CachedInstance
	else
		if not CachedInstance then
			CachedInstance = NexusWrappedInstance.new(ExistingInstance)
			CachedInstances[ExistingInstance] = CachedInstance
		end
	end
	
	--Return the cached entry.
	return CachedInstance
end



--[[
Creates a Nexus Wrapped Instance object.
--]]
function NexusWrappedInstance:__new(ExistingInstance)
	self:InitializeSuper()
	
	--Convert the ExistingInstance if it is a string.
	local AddDefaults = false
	if typeof(ExistingInstance) == "string" then
		ExistingInstance = Instance.new(ExistingInstance)
		AddDefaults = true
	end
	
	--Initialize the class.
	self.__ReferenceInstance = ExistingInstance
	self.__ChangeFunctions = {}
	self.__ColorProperties = {}
	self.__IgnoreChangesQueue = {}
	self.__IgnoreReverseChangesQueue = {}
	self.__NoBackwardsReplicationProperties = {}
	self.Name = ExistingInstance.Name
	
	--Register the wrapped instance.
	if not CachedInstances[ExistingInstance] then
		CachedInstances[ExistingInstance] = self
	end
	
	--Set up changes to Hidden not affecting anything.
	self:__SetChangedOverride("Hidden",function() end)
	
	--[[
	Returns the current color modifier.
	--]]
	local function GetColorModifier()
		if not self:IsEnabled() then
			return Enum.StudioStyleGuideModifier.Disabled
		elseif self.Selected then
			return Enum.StudioStyleGuideModifier.Selected
		else
			return Enum.StudioStyleGuideModifier.Default
		end
	end
	
	--[[
	Updates a color property.
	--]]
	local function UpdateColorProperty(PropertyName)
		local Theme = Settings:GetSetting("Studio","Theme")
		local Color = self[PropertyName]
		
		--Set the color.
		self.__IgnoreChangesQueue[PropertyName] = true
		if type(Color) == "string" or typeof(Color) == "EnumItem" then
			local ColorModifier = GetColorModifier()
			ExistingInstance[PropertyName] = Theme:GetColor(Color,ColorModifier)
		else
			ExistingInstance[PropertyName] = Color
		end
	end
	
	--[[
	Updates all of the color properties.
	--]]
	local function UpdateAllColorProperties()
		for ColorPropertyName,_ in pairs(self.__ColorProperties) do
			UpdateColorProperty(ColorPropertyName)
		end
	end
	
	--Set up changing the colors when the setting changes.
	table.insert(self.__ConnectionsToClear,settings()["Studio"].ThemeChanged:Connect(UpdateAllColorProperties))
	
	--Set up changing colors when enabled/disabled and selected/deselected.
	self:__SetChangedOverride("Disabled",UpdateAllColorProperties)
	self:__SetChangedOverride("Selected",UpdateAllColorProperties)
	
	--Mirror changes to the wrapped object.
	local ChangedFunctions = self.__ChangeFunctions
	local ColorProperties = self.__ColorProperties
	local IgnoreReverseChangesQueue = self.__IgnoreReverseChangesQueue
	local IgnoreChangesQueue = self.__IgnoreChangesQueue
	local NoBackwardsReplicationProperties = self.__NoBackwardsReplicationProperties
	local RawGet = self.__rawget
	table.insert(self.__ConnectionsToClear,self.Changed:Connect(function(PropertyName)
		--If an overriden change function exists, call it.
		local ChangedFunction = ChangedFunctions[PropertyName]
		if ChangedFunction then
			ChangedFunction()
			return
		end
		
		--If a property was replicated to here, return.
		if IgnoreReverseChangesQueue[PropertyName] then
			IgnoreReverseChangesQueue[PropertyName] = nil
			return
		end
		
		--Mirror the property.
		if string.sub(PropertyName,1,2) ~= "__" then
			local NewProperty = RawGet(self,PropertyName)
			local ExistingProperty = ExistingInstance[PropertyName]
			local ExistingPropertyType = typeof(ExistingProperty)
			local NewPropertyType = typeof(NewProperty)
			
			if ExistingPropertyType == "Color3" then
				ColorProperties[PropertyName] = true
				UpdateColorProperty(PropertyName)
			elseif (ExistingPropertyType == "Instance" or ExistingProperty == nil) and (NewPropertyType == "table" and NewProperty.IsA and NewProperty:IsA(CLASS_NAME)) then
				IgnoreChangesQueue[PropertyName] = true
				ExistingInstance[PropertyName] = NewProperty:GetWrappedInstance()
			else
				IgnoreChangesQueue[PropertyName] = true
				ExistingInstance[PropertyName] = NewProperty
			end
		end
	end))
	
	--Mirror changes from the instance.
	table.insert(self.__ConnectionsToClear,ExistingInstance.Changed:Connect(function(PropertyName)
		if not ReadOnlyProperties[PropertyName] and not NoBackwardsReplicationProperties[PropertyName] then
			--Wrap the error.
			pcall(function()
				--Set the changed property or fire a changed signal.
				local ExistingValue,NewValue = self[PropertyName],ExistingInstance[PropertyName]
				if not IgnoreChangesQueue[PropertyName] or (ExistingValue ~= NewValue and typeof(ExistingValue) == typeof(NewValue)) then
					IgnoreChangesQueue[PropertyName] = nil
					IgnoreReverseChangesQueue[PropertyName] = true
					
					--Change the property or fire the changed signals if there is no changes.
					if ExistingValue ~= NewValue then
						self[PropertyName] = NewValue
					else
						self.Changed:Fire(PropertyName)
						self:GetPropertyChangedSignal(PropertyName):Fire()
					end
				end
			end)
		end
	end))
	
	--Set the selected property to be false.
	self.Selected = false
	
	--Set the defaults.
	if AddDefaults then
		local Defaults = INSTANCE_CREATION_PRESETS[ExistingInstance.ClassName]
		if Defaults then
			for Key,Property in pairs(Defaults) do
				self[Key] = Property
			end
		end
	end
end

--[[
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used.
--]]
function NexusWrappedInstance:__getindex(IndexName,OriginalReturn)
	--Return a passed-through property.
	if OriginalReturn == nil and IndexName ~= "__ReferenceInstance" then
		local Worked,Return = pcall(function()
			local ReferenceInstance = self.__ReferenceInstance
			local Return = ReferenceInstance[IndexName]
			local NewReturn = ReplaceInstances(Return)
			
			--Modify the return if it is a function or a Roblox Instance.
			if type(Return) == "function" then
				NewReturn = function(...)
					--Unwrap the instances.
					local Arguments = {...}
					Arguments = UnwrapInstances(Arguments)
					
					--Run the method and replace the instances.
					local MethodReturn = {Return(unpack(Arguments))}
					MethodReturn = ReplaceInstances(MethodReturn)
					
					--Unpack the return.
					return unpack(MethodReturn)
				end
			end
			
			--Return the Instance return.
			return NewReturn
		end)
		
		--Return the result if there was no error (was able to index the Instance).
		if Worked then
			return Return,true
		end
	end
	
	--Return the parent.
	return NexusWrappedInstance.super:__getindex(IndexName,OriginalReturn)
end

--[[
Returns a pre-initialized clone. Only the constructor
should be run with all properties added afterwards
except those starting with "__".
--]]
function NexusWrappedInstance:__PreInitializeClone()
	return NexusWrappedInstance.new(self:GetWrappedInstance():Clone())
end

--[[
Adds an change overrider that prevents mirroring to
the wrapped instance.
--]]
function NexusWrappedInstance:__SetChangedOverride(PropertyName,Function)
	self.__ChangeFunctions[PropertyName] = Function
end

--[[
Returns if the instance is or inherits from a class of that name.
--]]
function NexusWrappedInstance:IsA(ClassName)
	return self.ClassName == ClassName or self.super:IsA(ClassName) or self:GetWrappedInstance():IsA(ClassName)
end

--[[
Returns the wrapped instance.
--]]
function NexusWrappedInstance:GetWrappedInstance()
	return self.__ReferenceInstance
end

--[[
Sets the NexusContainer.Parent property to nil,
locks the NexusContainer.Parent property,
and calls Destroy on all children.
--]]
function NexusWrappedInstance:Destroy()
	self.super:Destroy()
	
	local Ins = self:GetWrappedInstance()
	if Ins then
		Ins:Destroy()
	end
end



return NexusWrappedInstance