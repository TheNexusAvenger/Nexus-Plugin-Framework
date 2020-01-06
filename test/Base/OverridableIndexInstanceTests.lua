--[[
TheNexusAvenger

Tests the OverridableIndexInstance class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local OverridableIndexInstance = NexusPluginFramework:GetResource("Base.OverridableIndexInstance")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = OverridableIndexInstance.new()
	UnitTest:AssertEquals(CuT.ClassName,"OverridableIndexInstance","Class name is incorrect.")
end)

--[[
Test overriding the __getindex method.
--]]
NexusUnitTesting:RegisterUnitTest("__getindex",function(UnitTest)
	local Table1,Table2,Table3 = {},{},{}
	
	--Create the test class.
	local TestClass = OverridableIndexInstance:Extend()
	TestClass.Table5 = true
	TestClass.Table6 = true
	function TestClass:__getindex(Index,BaseIndex)
		if Index == "Table1" then
			return Table1
		elseif Index == "Table2" then
			return Table2
		elseif Index == "Table3" then
			return Table3
		elseif Index == "Table4" then
			return nil,true
		elseif Index == "Table5" then
			return nil
		elseif Index == "Table6" then
			return tostring(BaseIndex)
		end
	end
	
	--Assert the indexes are correct.
	local CuT = TestClass.new()
	UnitTest:AssertEquals(CuT.ClassName,"OverridableIndexInstance","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Table1,Table1,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Table2,Table2,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Table3,Table3,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Table4,nil,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Table5,true,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Table6,"true","Override is incorrect.")
end)

--[[
Tests the __setindex method.
--]]
NexusUnitTesting:RegisterUnitTest("__setindex",function(UnitTest)
	--Create the test class.
	local TestClass = OverridableIndexInstance:Extend()
	TestClass.ClassName = "Test"
	function TestClass:__setindex(IndexName,NewValue)
		return "String_"..tostring(IndexName).."_"..tostring(NewValue)
	end
	
	--Assert setting indexs are correct.
	local CuT = TestClass.new()
	CuT.Index1 = 1
	CuT.Index2 = 2
	CuT.Index3 = 3
	UnitTest:AssertEquals(CuT.Index1,"String_Index1_1","Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index2,"String_Index2_2","Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index3,"String_Index3_3","Override is incorrect.")
	CuT.Index1 = 4
	CuT.Index2 = 5
	CuT.Index3 = 6
	UnitTest:AssertEquals(CuT.Index1,"String_Index1_4","Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index2,"String_Index2_5","Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index3,"String_Index3_6","Override is incorrect.")
end)

--[[
Tests the __rawget method.
--]]
NexusUnitTesting:RegisterUnitTest("__rawget",function(UnitTest)
	--Create the test class.
	local TestClass = OverridableIndexInstance:Extend()
	TestClass.Index1 = 1
	TestClass.Index2 = 2
	function TestClass:__getindex(Index,BaseIndex)
		if Index == "Index1" then
			return 4
		elseif Index == "Index2" then
			return nil,true
		elseif Index == "Index3" then
			return 6
		end
	end
	
	--Assert the indexes are correct.
	local CuT = TestClass.new()
	UnitTest:AssertEquals(CuT.Index1,4,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index2,nil,"Override is incorrect.")
	UnitTest:AssertEquals(CuT.Index3,6,"Override is incorrect.")
	UnitTest:AssertEquals(CuT:__rawget("Index1"),1,"Raw get is incorrect.")
	UnitTest:AssertEquals(CuT:__rawget("Index2"),2,"Raw get is incorrect.")
	UnitTest:AssertEquals(CuT:__rawget("Index3"),nil,"Raw get is incorrect.")
end)

--[[
Tests extending the OverridableIndexInstance.
--]]
NexusUnitTesting:RegisterUnitTest("Extending",function(UnitTest)
	--Extend the class.
	local TestClass = OverridableIndexInstance:Extend()
	TestClass.TestProperty1 = "Test 1"
	
	function TestClass:__getindex(Index,BaseIndex)
		if Index == "TestProperty1" then
			UnitTest:AssertEquals(BaseIndex,"Test 1","Class test property is incorrect.")
		end
	end
	
	--Create the component under testing.
	local CuT = TestClass.new()
	CuT.TestProperty2 = "Test 2"
	UnitTest:AssertEquals(CuT.TestProperty1,"Test 1","Class property is incorrect.")
	UnitTest:AssertEquals(CuT.TestProperty2,"Test 2","Object property is incorrect.")
end)

--[[
Tests referencing self in __getindex.
--]]
NexusUnitTesting:RegisterUnitTest("ReferenceWithinGetindex",function(UnitTest)
	--Extend the class.
	local TextClass = OverridableIndexInstance:Extend()
	
	function TextClass:__getindex(IndexName,OriginalReturn)
		if IndexName == "TestProperty1" then
			return "Test 1"
		elseif IndexName == "TestProperty2" then
			return "Test 2"
		end
	end
	
	--Create the component under testing.
	local CuT = TextClass.new()
	UnitTest:AssertEquals(CuT.TestProperty1,"Test 1","Test property is incorrect.")
	UnitTest:AssertEquals(CuT.TestProperty2,"Test 2","Test property is incorrect.")
end)

--[[
Tests extending with super class initializing.
--]]
NexusUnitTesting:RegisterUnitTest("SuperClassInitialization",function(UnitTest)
	--Extend the class.
	local TestClass1 = OverridableIndexInstance:Extend()
	local TestClass2 = TestClass1:Extend()
	
	function TestClass1:__getindex(Index,BaseIndex)
		if Index == "TestProperty1" then
			return "Test 1"
		elseif Index == "TestProperty2" then
			return "Test 2"
		end
	end
	
	function TestClass1:__new()
		self:InitializeSuper()
		UnitTest:AssertEquals(self.TestProperty1,"Test 1","Super class property is incorrect.")
		UnitTest:AssertEquals(self.TestProperty2,"Test 2","Super class property is incorrect.")
	end
	
	function TestClass2:__new()
		self:InitializeSuper()
		UnitTest:AssertEquals(self.TestProperty1,"Test 1","Class property is incorrect.")
		UnitTest:AssertEquals(self.TestProperty2,"Test 2","Class property is incorrect.")
	end
	
	--Create the component under testing.
	local CuT = TestClass2.new()
	UnitTest:AssertEquals(CuT.TestProperty1,"Test 1","Object property is incorrect.")
	UnitTest:AssertEquals(CuT.TestProperty2,"Test 2","Object property is incorrect.")
end)



return true