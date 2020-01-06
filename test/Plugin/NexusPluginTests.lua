--[[
TheNexusAvenger

Tests the NexusPlugin class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusPlugin = NexusPluginFramework:GetResource("Plugin.NexusPlugin")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusPlugin.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusPlugin","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusPlugin","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusPlugin","Name is incorrect.")
end)



return true