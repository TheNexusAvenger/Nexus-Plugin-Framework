# NexusContainer
(extends [`OverridableIndexInstance`](OverridableIndexInstance.md), mirrors `Instance`)

Mirrors the API of Roblox Instances for containing
children and being parented.

## `string NexusContainer.Name`
A non-unique identifier of the `NexusContainer`.

## `bool NexusContainer.Archivable`
Determines if an `NexusContainer` can be cloned
using `NexusContainer:Clone`.

## `bool NexusContainer.Hidden`
Determines if the `NexusContainer` will appear when
using `GetChildren` and `GetDescendants`. Intended to
be used to hide sub-containers of containers for additional
functionality such as scroll bars on frames.

## `NexusEvent NexusContainer.AncestryChanged`
Fires when the `NexusContainer.Parent `property
of the object or one of its ancestors is changed.

## `NexusEvent NexusContainer.ChildAdded`
Fires when an object is parented to this `NexusContainer`.

## `NexusEvent NexusContainer.ChildRemoved`
Fires when a child is removed from this `NexusContainer`.

## `NexusEvent NexusContainer.DescendantAdded`
Fires when a descendant is added to the `NexusContainer`.

## `NexusEvent NexusContainer.DescendantRemoving`
Fires immediately before a descendant of the
`NexusContainer` is removed.

## `void NexusContainer:ClearAllChildren()`
This function destroys all of an
`NexusContainer`'s children.

## `NexusContainer NexusContainer:Clone()`
Create a deep copy of a `NexusContainer` and
descendants where `Archivable = true`.

## `void NexusContainer:Destroy()`
Sets the `NexusContainer.Parent` property to nil,
locks the `NexusContainer.Parent` property,
and calls `Destroy` on all children.

## `NexusContainer NexusContainer:FindFirstAncestor(string Name)`
Returns the first ancestor of the `NexusContainer`
whose `NexusContainer.Name` is equal to the given
`Name`.

## `NexusContainer NexusContainer:FindFirstAncestorOfClass(string ClassName)`
Returns the first ancestor of the `NexusContainer`
whose `NexusContainer.ClassName` is equal to the
given `ClassName`.

## `NexusContainer NexusContainer:FindFirstAncestorWhichIsA(string ClassName)`
Returns the first ancestor of the `NexusContainer` for whom
`NexusContainer:IsA` returns true for the given ClassName.

## `NexusContainer NexusContainer:FindFirstChild(string Name,bool Recursive)`
Returns the first child of the `NexusContainer` found with
the given name.

## `NexusContainer NexusContainer:FindFirstChildOfClass(string ClassName)`
Returns the first child of the `NexusContainer` whose `ClassName`
is equal to the given `ClassName`.

## `NexusContainer NexusContainer:FindFirstChildWhichIsA(string ClassName,bool Recursive)`
Returns the first child of the NexusContainer for whom 
`NexusContainer:IsA` returns true for the given `ClassName`.

## `List<NexusContainer> NexusContainer:GetChildren()`
Returns an array containing all of the `NexusContainers`'s
children.

## `List<NexusContainer> NexusContainer:GetDescendants()`
Returns an array containing all of the descendants of the
`NexusContainer`.

## `string NexusContainer:GetFullName()`
Returns a string describing the `NexusContainer`'s ancestry.

## `bool NexusContainer:IsAncestorOf(NexusContainer OtherContainer)`
Returns true if an `NexusContainer` is an ancestor of the given
descendant.

## `bool NexusContainer:IsDescendantOf(NexusContainer OtherContainer)`
Returns true if an `NexusContainer` is a descendant of the given
ancestor.

## `NexusContainer NexusContainer:WaitForChild(string Name,float TimeOut)`
Returns the child of the `NexusContainer` with the given name.
If the child does not exist, it will yield the current thread
until it does.

## `NexusConnection NexusContainer:ConnectToHighestParent(string EventName,function ConnectionFunction)`
Connects an event to the highest parent. If the ancestry
changes, the connected event changes. Returns a connection.