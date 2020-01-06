--[[
TheNexusAvenger

Tests the NexusEnum class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusEnumCollection = NexusPluginFramework:GetResource("Data.Enum.NexusEnumCollection")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusEnumCollection.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusEnumCollection","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusEnum","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusEnum","Name is incorrect.")
end)


--[[
Tests that indexing is correct.
--]]
NexusUnitTesting:RegisterUnitTest("Indexing",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusEnumCollection.new()
	
	--Create 4 enums.
	local TestEnum1 = CuT:CreateEnum("TestEnum1")
	local TestEnum2 = CuT:CreateEnum("TestEnum1","TestEnum2")
	local TestEnum3 = CuT:CreateEnum("TestEnum1","TestEnum2","TestEnum3")
	local TestEnum4 = CuT:CreateEnum("TestEnum1","TestEnum2","TestEnum4")
	
	--Assert the tostrings are correct.
	UnitTest:AssertEquals(tostring(TestEnum1),"NexusEnum.TestEnum1","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum2),"NexusEnum.TestEnum1.TestEnum2","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum3),"NexusEnum.TestEnum1.TestEnum2.TestEnum3","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum4),"NexusEnum.TestEnum1.TestEnum2.TestEnum4","Enum name is incorrect.")
	
	--Assert the indexes are correct.
	UnitTest:AssertEquals(CuT.TestEnum1,TestEnum1,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT.TestEnum1.TestEnum2,TestEnum2,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT.TestEnum1.TestEnum2.TestEnum3,TestEnum3,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT.TestEnum1.TestEnum2.TestEnum4,TestEnum4,"Indexed enum is incorrect.")
	
	--Assert Roblox enums are indexed correctly.
	UnitTest:AssertEquals(CuT.NormalId,Enum.NormalId,"Roblox Enum index is incorrect.")
	UnitTest:AssertEquals(CuT.NormalId.Left,Enum.NormalId.Left,"Roblox Enum index is incorrect.")
end)



return true