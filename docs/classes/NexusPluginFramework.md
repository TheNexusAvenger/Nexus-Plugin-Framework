# NexusPluginFramework
(instance of `NexusProject`)

Main module for Nexus Plugin Framework.

## `object NexusPluginFramework.new(ClassName,...)`
Creates either a Nexus Plugin Framework class or a wrapped Roblox
class for Nexus Plugin Framework. Not all classes are exposed 
through this function.

## `NexusPluginFramework:GetClass(ClassName)`
Returns the class for a given name. Note that it
will yield if the class doesn't exist.

## `NexusPlugin NexusPluginFramework:GetPlugin()`
Returns the plugin instance.

## `NexusSettings NexusPluginFramework:GetSettings()`
Returns the settings instance.