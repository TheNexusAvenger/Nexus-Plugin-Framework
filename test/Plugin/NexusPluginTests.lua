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

--[[
Tests the SetPlugin method.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusPlugin.new()
	NexusPlugin.SetPlugin(CuT)
	UnitTest:AssertSame(NexusPlugin.GetPlugin(),CuT,"Plugin wasn't set.")
end)



return true