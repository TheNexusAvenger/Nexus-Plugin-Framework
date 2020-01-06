--[[
TheNexusAvenger

Custom enum that contains a set of items, including Enums.
--]]

local CLASS_NAME = "NexusEnum"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local OverridableIndexInstance = NexusPluginFramework:GetResource("Base.OverridableIndexInstance")

local NexusEnum = OverridableIndexInstance:Extend()
NexusEnum:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusEnum)



--[[
Creates an NexusEnum object.
--]]
function NexusEnum:__new(Name)
	self:InitializeSuper()
	
	self.Name = Name
	self.CustomEnums = {}
end

--[[
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used.
--]]
function NexusEnum:__getindex(IndexName,OriginalReturn)
	--Return the base case for CustomEnums.
	if IndexName == "CustomEnums" then
		return OriginalReturn
	end
	
	--Return an enum item.
	local CustomEnums = self.CustomEnums
	if CustomEnums then
		local CustomEnum = CustomEnums[IndexName]
		if CustomEnum then
			return CustomEnum,true
		end
	end
	
	--Return the super.
	return NexusEnum.super.__getindex(self,IndexName,OriginalReturn)
end

--[[
Returns the Enum as a string.
--]]
function NexusEnum:__tostring()
	--Create the base.
	local Base = ""
	if self.ParentEnum ~= nil then
		Base = tostring(self.ParentEnum).."."
	end
	
	--Return the string.
	return Base..self.Name
end

--[[
Returns an enum for the name.
--]]
function NexusEnum:GetEnum(EnumName)
	return self.CustomEnums[EnumName]
end

--[[
Returns a list of the sub-enums.
--]]
function NexusEnum:GetEnumItems()
	--Clone the enum items.
	local ClonedSubEnums = {}
	for _,SubEnum in pairs(self.CustomEnums) do
		table.insert(ClonedSubEnums,SubEnum)
	end
	
	--Return the enum items.
	return ClonedSubEnums
end

--[[
Adds an Enum.
--]]
function NexusEnum:AddEnum(EnumInstance)
	self.CustomEnums[EnumInstance.Name] = EnumInstance
	EnumInstance.ParentEnum = self
end

--[[
Creates an Enum.
--]]
function NexusEnum:CreateEnum(...)
	local Names = {...}
	
	--Add or create the enum.
	local CurrentEnum = self
	for _,Name in pairs(Names) do
		--Create a new enum.
		if not CurrentEnum:GetEnum(Name) then
			local NewEnum = NexusEnum.new(Name)
			CurrentEnum:AddEnum(NewEnum)
		end
		
		--Move the current enum.
		CurrentEnum = CurrentEnum:GetEnum(Name)
	end
	
	--Return the enum.
	return CurrentEnum
end

--[[
Returns if another enum item is equal.
--]]
function NexusEnum:Equals(OtherEnum)
	return self == OtherEnum or self.Name == OtherEnum or tostring(self) == tostring(OtherEnum)
end



return NexusEnum