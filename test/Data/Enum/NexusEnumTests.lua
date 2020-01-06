--[[
TheNexusAvenger

Tests the NexusEnum class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusEnum = NexusPluginFramework:GetResource("Data.Enum.NexusEnum")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusEnum.new("TestEnum")
	UnitTest:AssertEquals(CuT.ClassName,"NexusEnum","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"TestEnum","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"TestEnum","Name is incorrect.")
end)


--[[
Tests the GetEnum method.
--]]
NexusUnitTesting:RegisterUnitTest("GetEnum",function(UnitTest)
	--Create 4 components under testing.
	local CuT1 = NexusEnum.new("TestEnum1")
	local CuT2 = NexusEnum.new("TestEnum2")
	local CuT3 = NexusEnum.new("TestEnum3")
	local CuT4 = NexusEnum.new("TestEnum4")
	
	--Add the enums.
	CuT1:AddEnum(CuT2)
	CuT2:AddEnum(CuT3)
	CuT2:AddEnum(CuT4)
	
	--Assert the get methods are correct.
	UnitTest:AssertEquals(CuT1:GetEnum("TestEnum1"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT1:GetEnum("TestEnum2"),CuT2,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT1:GetEnum("TestEnum3"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT1:GetEnum("TestEnum4"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT2:GetEnum("TestEnum1"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT2:GetEnum("TestEnum2"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT2:GetEnum("TestEnum3"),CuT3,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT2:GetEnum("TestEnum4"),CuT4,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT3:GetEnum("TestEnum1"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT3:GetEnum("TestEnum2"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT3:GetEnum("TestEnum3"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT3:GetEnum("TestEnum4"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT4:GetEnum("TestEnum1"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT4:GetEnum("TestEnum2"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT4:GetEnum("TestEnum3"),nil,"Enum is inccorrect.")
	UnitTest:AssertEquals(CuT4:GetEnum("TestEnum4"),nil,"Enum is inccorrect.")
end)

--[[
Tests the AddEnum method.
--]]
NexusUnitTesting:RegisterUnitTest("AddEnum",function(UnitTest)
	--Create 4 components under testing.
	local CuT1 = NexusEnum.new("TestEnum1")
	local CuT2 = NexusEnum.new("TestEnum2")
	local CuT3 = NexusEnum.new("TestEnum3")
	local CuT4 = NexusEnum.new("TestEnum4")
	
	--Add the enums.
	CuT1:AddEnum(CuT2)
	CuT2:AddEnum(CuT3)
	CuT2:AddEnum(CuT4)
	
	--Assert the names are correct.
	UnitTest:AssertEquals(tostring(CuT1),"TestEnum1","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT2),"TestEnum1.TestEnum2","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT3),"TestEnum1.TestEnum2.TestEnum3","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT4),"TestEnum1.TestEnum2.TestEnum4","Enum name is incorrect.")
	
	--Assert the lists are correct.
	local CuT2EnumItems = CuT2:GetEnumItems()
	if not (CuT2EnumItems[1] == CuT3 and CuT2EnumItems[2] == CuT4) and not (CuT2EnumItems[1] == CuT4 and CuT2EnumItems[2] == CuT3) then
		UnitTest:Fail("Enum items list is incorrect.")
	end
	UnitTest:AssertEquals(CuT1:GetEnumItems(),{CuT2},"Enum item list is incorrect.")
	UnitTest:AssertEquals(CuT3:GetEnumItems(),{},"Enum item list is incorrect.")
	UnitTest:AssertEquals(CuT4:GetEnumItems(),{},"Enum item list is incorrect.")
end)

--[[
Tests the CreateEnum method.
--]]
NexusUnitTesting:RegisterUnitTest("CreateEnum",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusEnum.new("TestEnum1")
	
	--Create several enums.
	local TestEnum2 = CuT:CreateEnum("TestEnum2")
	local TestEnum3 = CuT:CreateEnum("TestEnum3")
	local TestEnum3Duplicate = CuT:CreateEnum("TestEnum3")
	local TestEnum4 = CuT:CreateEnum("TestEnum2","TestEnum4")
	local TestEnum5 = CuT:CreateEnum("TestEnum2","TestEnum5")
	local TestEnum6 = CuT:CreateEnum("TestEnum3","TestEnum6")
	
	--Assert the duplicate create isn't duplicate.
	UnitTest:AssertSame(TestEnum3,TestEnum3Duplicate,"Duplicate enums created.")
	
	--Assert the enums are correct.
	UnitTest:AssertEquals(tostring(TestEnum2),"TestEnum1.TestEnum2","Enum name is incorrect.")
	UnitTest:AssertEquals(TestEnum2,CuT.TestEnum2,"Enum is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum3),"TestEnum1.TestEnum3","Enum name is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum3Duplicate),"TestEnum1.TestEnum3","Enum name is incorrect.")
	UnitTest:AssertEquals(TestEnum3,CuT.TestEnum3,"Enum is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum4),"TestEnum1.TestEnum2.TestEnum4","Enum name is incorrect.")
	UnitTest:AssertEquals(TestEnum4,CuT.TestEnum2.TestEnum4,"Enum is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum5),"TestEnum1.TestEnum2.TestEnum5","Enum name is incorrect.")
	UnitTest:AssertEquals(TestEnum5,CuT.TestEnum2.TestEnum5,"Enum is incorrect.")
	UnitTest:AssertEquals(tostring(TestEnum6),"TestEnum1.TestEnum3.TestEnum6","Enum name is incorrect.")
	UnitTest:AssertEquals(TestEnum6,CuT.TestEnum3.TestEnum6,"Enum is incorrect.")
end)

--[[
Tests the Equals method.
--]]
NexusUnitTesting:RegisterUnitTest("Equals",function(UnitTest)
	--Create the components under testing.
	local CuT1 = NexusEnum.new("TestEnum1")
	local CuT2 = CuT1:CreateEnum("TestEnum2")
	local CuT3 = CuT1:CreateEnum("TestEnum3")
	
	--Run the assertions.
	UnitTest:AssertTrue(CuT1:Equals(CuT1),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT1:Equals(CuT2),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT1:Equals(CuT3),"Enum equality is incorrect.")
	UnitTest:AssertTrue(CuT1:Equals("TestEnum1"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT1:Equals("TestEnum2"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT1:Equals("TestEnum3"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT2:Equals(CuT1),"Enum equality is incorrect.")
	UnitTest:AssertTrue(CuT2:Equals(CuT2),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT2:Equals(CuT3),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT2:Equals("TestEnum1"),"Enum equality is incorrect.")
	UnitTest:AssertTrue(CuT2:Equals("TestEnum2"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT2:Equals("TestEnum3"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT3:Equals(CuT1),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT3:Equals(CuT2),"Enum equality is incorrect.")
	UnitTest:AssertTrue(CuT3:Equals(CuT3),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT3:Equals("TestEnum1"),"Enum equality is incorrect.")
	UnitTest:AssertFalse(CuT3:Equals("TestEnum2"),"Enum equality is incorrect.")
	UnitTest:AssertTrue(CuT3:Equals("TestEnum3"),"Enum equality is incorrect.")
end)

--[[
Tests that indexing is correct.
--]]
NexusUnitTesting:RegisterUnitTest("Indexing",function(UnitTest)
	--Create 4 components under testing.
	local CuT1 = NexusEnum.new("TestEnum1")
	local CuT2 = NexusEnum.new("TestEnum2")
	local CuT3 = NexusEnum.new("TestEnum3")
	local CuT4 = NexusEnum.new("TestEnum4")
	
	--Add the enums.
	CuT1:AddEnum(CuT2)
	CuT2:AddEnum(CuT3)
	CuT2:AddEnum(CuT4)
	
	--Assert the indexes are correct.
	UnitTest:AssertEquals(CuT1.TestEnum2,CuT2,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT1.TestEnum2.TestEnum3,CuT3,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT1.TestEnum2.TestEnum4,CuT4,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT2.TestEnum3,CuT3,"Indexed enum is incorrect.")
	UnitTest:AssertEquals(CuT2.TestEnum4,CuT4,"Indexed enum is incorrect.")
end)



return true