--[[
TheNexusAvenger

Extends Nexus Instance to allow lower level overriding of indexing.
--]]

local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusInstance = NexusPluginFramework:GetResource("NexusInstance.NexusInstance")

local OverridableIndexInstance = NexusInstance:Extend()
OverridableIndexInstance:SetClassName("OverridableIndexInstance")
NexusPluginFramework:SetContextResource(OverridableIndexInstance)



--[[
Creates an instance of a Nexus Instance.
--]]
function OverridableIndexInstance:__new()
	--Set up the base object.
	self:InitializeSuper()
	
	--Get the base index method.
	local Metatable = getmetatable(self.object)
	local ExistingNewIndex = Metatable.__newindex
	
	--Get the new index method.
	local CustomNewIndexFunction = self.object["__setindex"]
	
	--Set up custom new indexing.
	Metatable.__newindex = function(_,Index,NewValue)
		--Get the new value.
		if CustomNewIndexFunction then
			NewValue = CustomNewIndexFunction(self.object,Index,NewValue)
		end
		
		--Set the value.
		ExistingNewIndex(self.object,Index,NewValue)
	end
end

--[[
Creates an __index metamethod for an object.
--]]
function OverridableIndexInstance:__createindexmethod(Object,Class,RootClass)
	if not RootClass then RootClass = Class end
	
	--Get the base method.
	local BaseIndexMethod = NexusInstance:__createindexmethod(Object,Class,RootClass)
	local CustomIndexFunction = RootClass.__getindex
	
	--Return a wrapped method.
	return function(MethodObject,Index)
		--Return the base meta method.
		if Index == "BaseIndexMetaMethod" then
			return BaseIndexMethod
		end
		
		--Return a custom index.
		local BaseIndex = BaseIndexMethod(self,Index)
		if CustomIndexFunction and Index ~= "super" then
			local CustomIndex,ForceNil = CustomIndexFunction(Object,Index,BaseIndex)
			if ForceNil == true or CustomIndex ~= nil then
				return CustomIndex
			end
		end
		
		--Return the base index.
		return BaseIndex
	end
end

--[[
Returns the raw index of the object (bypasses __getindex).
--]]
function OverridableIndexInstance:__rawget(Index)
	return self.BaseIndexMetaMethod(self,Index)
end

--[[
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used.
--]]
function OverridableIndexInstance:__getindex(IndexName,OriginalReturn)
	return nil,false
end

--[[
Returns the value for an index to be set. This is
run before the value of the object is set.
--]]
function OverridableIndexInstance:__setindex(IndexName,NewValue)
	return NewValue
end



return OverridableIndexInstance