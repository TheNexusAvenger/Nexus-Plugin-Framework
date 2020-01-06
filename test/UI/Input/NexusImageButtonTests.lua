--[[
TheNexusAvenger

Tests the NexusImageButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusImageButton = NexusPluginFramework:GetResource("UI.Input.NexusImageButton")



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local CuT = NexusImageButton.new()
	UnitTest:AssertEquals(CuT.ClassName,"NexusImageButton","Class name is incorrect.")
	UnitTest:AssertEquals(CuT.Name,"NexusImageButton","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT),"NexusImageButton","Name is incorrect.")
end)

--[[
Tests the Disabled property.
--]]
NexusUnitTesting:RegisterUnitTest("Disabled",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusImageButton.new()
	
	--Test disabling block auto button color.
	CuT.Disabled = true
	UnitTest:AssertFalse(CuT:GetWrappedInstance().AutoButtonColor,"AutoButtonColor is not disabled.")
	
	--Test enabling block auto button color.
	CuT.Disabled = false
	UnitTest:AssertTrue(CuT:GetWrappedInstance().AutoButtonColor,"AutoButtonColor is disabled.")
end)



return true