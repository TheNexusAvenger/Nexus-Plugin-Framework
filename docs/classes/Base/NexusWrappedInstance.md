# NexusWrappedInstance
(extends [`NexusDisablableContainer`](NexusDisablableContainer.md))

Wraps a Roblox Instance with the `NexusContainer` API.

## `static NexusWrappedInstance NexusWrappedInstance.GetInstance(Instance ExistingInstance)`
Gets a Nexus Wrapped Instance from a string
or an existing Roblox instance. When using
existing instances, this should be used since
it goes through a cache which prevents a single
instance having multiple `NexusWrappedInstance`s.

## `static NexusWrappedInstance NexusWrappedInstance.new(Instance ExistingInstance)`
Creates a Nexus Wrapped Instance object from a string
or an existing Roblox instance.

## `bool NexusWrappedInstance.Selected`
Bool for the `NexusWrappedInstance` being selected.
Used for changing the colors based on selecting.

## `Instance NexusWrappedInstance:GetWrappedInstance()`
Returns the wrapped instance.