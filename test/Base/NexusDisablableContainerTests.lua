--[[
TheNexusAvenger

Tests the NexusDisablableContainer class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusDisablableContainer = NexusPluginFramework:GetResource("Base.NexusDisablableContainer")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusDisablableContainer.new()
	UnitTest:AssertEquals(CuT.Disabled,false,"Disabled is incorrect.")
	UnitTest:AssertEquals(CuT:IsEnabled(),true,"Disabled is incorrect.")
	UnitTest:AssertEquals(CuT.ClassName,"NexusDisablableContainer","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusDisablableContainer","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusDisablableContainer","Name is incorrect.")
end)



return true