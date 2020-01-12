# NexusPluginFramework
(instance of `NexusProject`)

Main module for Nexus Plugin Framework.

## `object NexusPluginFramework.new(string ClassName,object ...)`
Creates either a Nexus Plugin Framework class or a wrapped Roblox
class for Nexus Plugin Framework. Not all classes are exposed 
through this function.

The following class names are added as custom instances:

* `Signal` (`NexusInstance.Event.RobloxEvent`)
* [`UserInput` (`Plugin.NexusUserInput`)](Plugin/NexusUserInput.md)
* [`CollapsableListFrame` (`UI.CollapsableList.NexusCollapsableListFrame`)](UI/CollapsableList/NexusCollapsableListFrame.md)
* [`ListContentsPropertyConstraint` (`UI.CollapsableList.Constraint.NexusContentsPropertyConstraint`)](UI/CollapsableList/Constraint/NexusContentsPropertyConstraint.md)
* [`ListMultiConstraint` (`UI.CollapsableList.Constraint.NexusMultiConstraint`)](UI/CollapsableList/Constraint/NexusMultiConstraint.md)
* [`ListSelectionConstraint` (`UI.CollapsableList.Constraint.NexusSelectionConstraint`)](UI/CollapsableList/Constraint/NexusSelectionConstraint.md)
* [`BoundingSizeConstraint` (`UI.Constraint.NexusBoundingSizeConstraint`)](UI/Constraint/NexusBoundingSizeConstraint.md)
* [`CheckBox` (`UI.Input.NexusCheckBox`)](UI/Input/NexusCheckBox.md)
* [`ScrollBar` (`UI.Scroll.NexusScrollBar`)](UI/Scroll/NexusScrollBar.md)

The following Roblox Instances have custom implementations of classes:

* [`PluginButton` (`Plugin.NexusPluginButton`)](Plugin/NexusPluginButton.md)
* [`PluginGui` (`Plugin.NexusPluginGui`)](Plugin/NexusPluginGui.md)
* [`PluginToolbar` (`Plugin.NexusPluginToolbar`)](Plugin/NexusPluginToolbar.md)
* [`ImageButton` (`UI.Input.NexusImageButton`)](UI/Input/NexusImageButton.md)
* [`TextBox` (`UI.Input.NexusTextBox`)](UI/Input/NexusTextBox.md)
* [`ScrollingFrame` (`UI.Scroll.NexusScrollingFrame`)](UI/Scroll/NexusScrollingFrame.md)

If an instance is created using this method and isn't on the list,
a wrapped version of the instance is used.

## `NexusInstance NexusPluginFramework:GetClass(string ClassName)`
Returns the class for a given name. Note that it
will yield if the class doesn't exist.

## [`NexusPlugin`](Plugin/NexusPlugin.md) ` NexusPluginFramework:GetPlugin()`
Returns the plugin instance.

## [`NexusSettings`](Plugin/NexusSettings.md) ` NexusPluginFramework:GetSettings()`
Returns the settings instance.