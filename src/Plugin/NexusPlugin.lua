--[[
TheNexusAvenger

Mirrors the API of Roblox's Plugin class.
--]]

local CLASS_NAME = "NexusPlugin"



local NexusPluginFramework = require(script.Parent.Parent:WaitForChild("NexusPluginFrameworkProject")):GetContext(script)
local NexusContainer = NexusPluginFramework:GetResource("Base.NexusContainer")
local NexusStudioTheme = NexusPluginFramework:GetResource("Plugin.NexusStudioTheme")
local NexusEventCreator = NexusPluginFramework:GetResource("NexusInstance.Event.NexusEventCreator")

local NexusPlugin = NexusContainer:Extend()
NexusPlugin:SetClassName(CLASS_NAME)
NexusPluginFramework:SetContextResource(NexusPlugin)

local CachedPlugin



--[[
Returns a static plugin instance. Note it may not be
a "mock" plugin (NexusPlugin).
--]]
function NexusPlugin.GetPlugin()
	--Craete the cached plugin if needed.
	if not CachedPlugin then
		--Get the plugin.
		local Plugin
		pcall(function()
			Plugin = PluginManager():CreatePlugin()
		end)
		
		--Create the cached plugin.
		if Plugin then
			CachedPlugin = Plugin
		else
			CachedPlugin = NexusPlugin.new()
		end
	end
	
	--Return the cached plugin.
	return CachedPlugin
end

--[[
Creates a Nexus Plugin object.
--]]
function NexusPlugin:__new()
	self:InitializeSuper()
	self.Name = CLASS_NAME
	
	self.CollisionEnabled = true
	self.GridSize = 1
	
	self.Deactivation = NexusEventCreator:CreateEvent()
	self.Unloading = NexusEventCreator:CreateEvent()
end

--[[
Sets the state of the calling plugin to activated.
--]]
function NexusPlugin:Activate(ExclusiveMouse)
	warn("Unimplemented: NexusPlugin:Activate(ExclusiveMouse)")
end

--[[
This function creates a DockWidgetPluginGui using the
	provided DockWidgetPluginGuiInfo.
--]]
function NexusPlugin:CreateDockWidgetPluginGui(PluginGuiId,WidgetPluginGuiInfo)
	error("Unimplemented: NexusPlugin:CreateDockWidgetPluginGui(PluginGuiId,WidgetPluginGuiInfo)")
end

--[[
Creates a PluginAction which is an object that represents
a generic performable action in Roblox Studio, with no
directly associated Toolbar or Button.
--]]
function NexusPlugin:CreatePluginAction(ActionId,Text,StatusTip,IconName,AllowBinding)
	error("Unimplemented: NexusPlugin:CreatePluginAction(ActionId,Text,StatusTip,IconName,AllowBinding)")
end

--[[
Creates a new plugin menu.
--]]
function NexusPlugin:CreatePluginMenu(Id,Title,Icon)
	error("Unimplemented: NexusPlugin:CreatePluginMenu(Id,Title,Icon)")
end

--[[
Gets or creates a new Toolbar with the specified name,
which is then used to create a plugin button.
--]]
function NexusPlugin:CreateToolbar(Name)
	error("Unimplemented: NexusPlugin:CreateToolbar(Name)")
end

--[[
Deactivates the plugin.
--]]
function NexusPlugin:Deactivate()
	warn("Unimplemented: NexusPlugin:Deactivate()")
end

--[[
Returns the JointCreationMode the user has set in studio
under the Model tab.
--]]
function NexusPlugin:GetJoinMode()
	warn("Unimplemented: NexusPlugin:GetJoinMode()")
	return Enum.JointCreationMode.Surface
end

--[[
Returns a mouse that can be used with the plugin.
--]]
function NexusPlugin:GetMouse()
	error("Unimplemented: NexusPlugin:GetMouse()")
end

--[[
Returns the currently selected RibbonTool.
--]]
function NexusPlugin:GetSelectedRibbonTool()
	error("Unimplemented: NexusPlugin:GetSelectedRibbonTool()")
end

--[[
Retrieves a previously stored value with the given key,
or nil if the given key doesn’t exist.
--]]
function NexusPlugin:GetSetting(Key)
	error("Unimplemented: NexusPlugin:GetSetting(Key)")
end

--[[
Returns the studio user’s userId if they’re logged in,
otherwise returns 0.
--]]
function NexusPlugin:GetStudioUserId()
	error("Unimplemented: NexusPlugin:GetStudioUserId()")
end

--[[
Prompts the user to open a .fbx animation file that can
be loaded onto the rigModel, then proceeds to insert the
animation as a KeyframeSequence in the Workspace.
--]]
function NexusPlugin:ImportFbxAnimation(RigModel,IsR15)
	error("Unimplemented: NexusPlugin:ImportFbxAnimation(RigModel,IsR15)")
end

--[[
Prompts the user to open a .fbx file, uploads the individual
components of the model as meshes, and generates a character
rig for use in animation, which is loaded into the Workspace.
--]]
function NexusPlugin:ImportFbxRig(IsR15)
	error("Unimplemented: NexusPlugin:ImportFbxRig(IsR15)")
end

--[[
Returns true if this plugin is currently active, after having
been activated via the Plugin:Activate function.
--]]
function NexusPlugin:IsActivated()
	error("Unimplemented: NexusPlugin:IsActivated()")
end

--[[
Returns true if this plugin is currently active with an
exclusive mouse, after having been activated via the
Plugin:Activate function.
--]]
function NexusPlugin:IsActivatedWithExclusiveMouse()
	error("Unimplemented: NexusPlugin:IsActivatedWithExclusiveMouse()")
end

--[[
Negates the given parts and returns the resulting
NegateOperations.
--]]
function NexusPlugin:Negate(Objects)
	error("Unimplemented: NexusPlugin:Negate(Objects)")
end

--[[
Used to open the given script instance in an editor window,
in Roblox studio, at the given line. If no line is given
as an argument it will default to 0.
--]]
function NexusPlugin:OpenScript(Script,LineNumber)
	error("Unimplemented: NexusPlugin:OpenScript(Script,LineNumber)")
end

--[[
Opens the context help window to the wiki page that url
links to.
--]]
function NexusPlugin:OpenWikiPage(URL)
	error("Unimplemented: NexusPlugin:OpenWikiPage(URL)")
end

--[[
Opens a window in Roblox Studio, which prompts the user to
select an asset based on the assetType specified. Returns
what assetId was selected, or -1 if the window was closed.
--]]
function NexusPlugin:PromptForExistingAssetId(AssetType)
	error("Unimplemented: NexusPlugin:PromptForExistingAssetId(AssetType)")
end

--[[
Prompts the user to save their current selection with the
specified file name. Returns true if the user did save the file.
--]]
function NexusPlugin:PromptSaveSelection(SuggestedFileName)
	error("Unimplemented: NexusPlugin:PromptSaveSelection(SuggestedFileName)")
end

--[[
Opens an upload window for the user’s current selection.
--]]
function NexusPlugin:SaveSelectedToRoblox()
	error("Unimplemented: NexusPlugin:SaveSelectedToRoblox()")
end

--[[
Activates the specified Roblox Studio tool.
--]]
function NexusPlugin:SelectRibbonTool(Tool,Position)
	error("Unimplemented: NexusPlugin:SelectRibbonTool(Tool,Position)")
end

--[[
Separates the given UnionOperations and returns the resulting parts.
--]]
function NexusPlugin:Separate(Objects)
	error("Unimplemented: NexusPlugin:Separate(Objects)")
end

--[[
Stores a given value for later use under the given key. The value
will persist even after studio is closed.
--]]
function NexusPlugin:SetSetting(Key,Value)
	error("Unimplemented: NexusPlugin:SetSetting(Key,Value)")
end

--[[
Unions the given parts and returns the resulting UnionOperation.
--]]
function NexusPlugin:Union(Objects)
	error("Unimplemented: NexusPlugin:Union(Objects)")
end



return NexusPlugin