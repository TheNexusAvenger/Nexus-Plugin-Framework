# NexusPlugin
(extends [`NexusContainer`](../Base/NexusContainer.md), implements `Plugin`)

Mirrors the API of Roblox's Plugin class.

## `NexusPlugin/Plugin NexusPlugin.GetPlugin()`
Returns a static plugin instance. Note it may not be
a "mock" plugin (NexusPlugin).

## `void NexusPlugin.SetPlugin(NexusPlugin/Plugin Plugin)`
Sets the static plugin instance. Needed to be
used in a Script since `plugin` is not defined
in `ModuleScripts`, even if it required by a plugin
`Script`.