# NexusPluginFramework
(instance of `NexusProject`)

Main module for Nexus Plugin Framework.

## `object NexusPluginFramework.new(string ClassName,object ...)`
Creates either a Nexus Plugin Framework class or a wrapped Roblox
class for Nexus Plugin Framework. Not all classes are exposed 
through this function.

## `NexusInstance NexusPluginFramework:GetClass(string ClassName)`
Returns the class for a given name. Note that it
will yield if the class doesn't exist.

## [`NexusPlugin`](Plugin/NexusPlugin.md) ` NexusPluginFramework:GetPlugin()`
Returns the plugin instance.

## [`NexusSettings`](Plugin/NexusSettings.md) ` NexusPluginFramework:GetSettings()`
Returns the settings instance.