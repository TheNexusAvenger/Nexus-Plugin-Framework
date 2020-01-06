--[[
TheNexusAvenger

Tests the NexusTextBox class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusTextBox = NexusPluginFramework:GetResource("UI.Input.NexusTextBox")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusTextBox.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusTextBox","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusTextBox","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusTextBox","Name is incorrect.")
end)



return true