--[[
TheNexusAvenger

Contains a set of Enums and can reference Roblox enums.
--]]

local CLASS_NAME = "NexusEnumCollection"



local NexusPluginFramework = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusEnum = NexusPluginFramework:GetResource("Data.Enum.NexusEnum")

local NexusEnumCollection = NexusEnum:Extend()
NexusEnumCollection:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusEnumCollection)

local StaticInstance



--[[
Returns a static instance with a set of built-in
enums used by the framework.
--]]
function NexusEnumCollection.GetBuiltInEnums()
	--Create the static instance.
	if not StaticInstance then
		StaticInstance = NexusEnumCollection.new()
		
		--Add the enums.
		StaticInstance:CreateEnum("NexusScrollTheme","Native")
		StaticInstance:CreateEnum("NexusScrollTheme","Qt5")
		StaticInstance:CreateEnum("CheckBoxState","Checked")
		StaticInstance:CreateEnum("CheckBoxState","Unchecked")
		StaticInstance:CreateEnum("CheckBoxState","Mixed")
	end
	
	--Return the static instance.
	return StaticInstance
end

--[[
Creates an NexusEnumCollection object.
--]]
function NexusEnumCollection:__new()
	self:InitializeSuper("NexusEnum")
end

--[[
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used.
--]]
function NexusEnumCollection:__getindex(IndexName,OriginalReturn)
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
	
	--Return a Roblox enum.
	local Worked,Return = pcall(function()
		return Enum[IndexName]
	end)
	
	if Worked then
		return Return
	end
	
	--Return the super.
	return NexusEnumCollection.super.__getindex(self,IndexName,OriginalReturn)
end



return NexusEnumCollection