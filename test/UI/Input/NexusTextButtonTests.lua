--[[
TheNexusAvenger

Tests the NexusTextButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusTextButton = NexusPluginFramework:GetResource("UI.Input.NexusTextButton")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusTextButton.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusTextButton","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusTextButton","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusTextButton","Name is incorrect.")
end)

--[[
Tests the Disabled property.
--]]
NexusUnitTesting:RegisterUnitTest("Disabled",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusTextButton.new()
	
	--Test disabling block auto button color.
	CuT.Disabled = true
	UnitTest:AssertFalse(CuT:GetWrappedInstance().AutoButtonColor,"AutoButtonColor is not disabled.")
	
	--Test enabling block auto button color.
	CuT.Disabled = false
	UnitTest:AssertTrue(CuT:GetWrappedInstance().AutoButtonColor,"AutoButtonColor is disabled.")
end)



return true