--[[
TheNexusAvenger

Tests the NexusStudioTheme class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusPluginFramework"))
local NexusStudioTheme = NexusPluginFramework:GetResource("Plugin.NexusStudioTheme")



--[[
Test that the constructors work without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructors",function(UnitTest)
	--Test the base constructor.
	local CuT1 = NexusStudioTheme.new()
	UnitTest:AssertEquals(CuT1.ClassName,"NexusStudioTheme","Class name is incorrect.")
	UnitTest:AssertEquals(CuT1.Name,"Fallback","Name is incorrect.")
	UnitTest:AssertEquals(tostring(CuT1),"Fallback","Name is incorrect.")
	
	--Test the cahce constructor.
	local CuT2,CuT3 = NexusStudioTheme.FromThemeEnum(),NexusStudioTheme.FromThemeEnum()
	UnitTest:AssertSame(CuT2,CuT3,"Themes aren't cached.")
end)

--[[
Tests the GetColor method.
--]]
NexusUnitTesting:RegisterUnitTest("GetColor",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusStudioTheme.new()
	
	--Run the assertions.
	UnitTest:AssertClose(CuT:GetColor(Enum.StudioStyleGuideColor.DialogMainButton),Color3.new(0,0.635294,1),0.001,"Colors aren't close.")
	UnitTest:AssertClose(CuT:GetColor("DialogMainButton",Enum.StudioStyleGuideModifier.Selected),Color3.new(0,0.454902,0.741176),0.001,"Colors aren't close.")
	UnitTest:AssertClose(CuT:GetColor("DialogMainButton","Disabled"),Color3.new(0.235294,0.235294,0.235294),0.001,"Colors aren't close.")
end)



return true