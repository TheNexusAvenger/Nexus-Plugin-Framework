# NexusSettings
(extends [`NexusContainer`](../Base/NexusContainer.md))

Proxy's Roblox's settings.

## `static NexusSettings NexusSettings.GetSettings()`
Returns a singleton version of the settings.

## `NexusSettings:GetSetting(string Category,string Name)`
Returns the setting for the given category and name.

## `NexusSettings:SetSetting(string Category,string Name,object Value)`
Sets the setting for the given category and name.

## `NexusConnection NexusSettings:GetSettingsChangedSignal(string Category,string Name)`
Returns a changed signal for a given property. If the name
is nil, a changed signal for the category is returned.