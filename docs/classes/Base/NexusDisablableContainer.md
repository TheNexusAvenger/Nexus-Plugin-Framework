# NexusDisablableContainer
(extends [`NexusContainer`](NexusContainer.md))

Guarentees a container can be enabled or disabled.

## `bool NexusDisablableContainer.Disabled`
Bool for representing if the container is disabled.

## `bool NexusDisablableContainer:IsEnabled()`
Returns if the container is enabled. Recommended
over checking `NexusDisablableContainer.Disabled`
since a class can override it to base off parent,
children, or something external.