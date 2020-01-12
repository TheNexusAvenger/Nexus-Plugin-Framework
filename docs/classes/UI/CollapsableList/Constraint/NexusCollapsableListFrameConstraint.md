# NexusCollapsableListFrameConstraint
(extends [`NexusContainer`](../../../Base/NexusContainer.md))

Abstract class for a constraint on list frames.

## `NexusEvent NexusCollapsableListFrameConstraint.ListFrameAdded`
Invoked when a list frame is added to the constraint.

## `NexusEvent NexusCollapsableListFrameConstraint.ListFrameRemoved`
Invoked when a list frame is removed from the constraint.

## `NexusEvent NexusCollapsableListFrameConstraint.ListFramesUpdated`
Invoked when the list frames list is changed. This included
frames being added, removed, and the order changing.

## `bool NexusCollapsableListFrameConstraint:ContainsListFrame(` [`NexusCollapsableListFrame`](../NexusCollapsableListFrame.md) `ListFrame)`
Returns if the constraint contains the list frame.

## `List<`[`NexusCollapsableListFrame`](../NexusCollapsableListFrame.md)`> NexusCollapsableListFrameConstraint:GetListFrames()`
Returns the list frames part of the constraint.

## `List<`[`NexusCollapsableListFrame`](../NexusCollapsableListFrame.md)`> NexusCollapsableListFrameConstraint:GetAllListFrames(bool OnlyShowVisible)`
Returns all of the list frames in the constraint.

## `void NexusCollapsableListFrameConstraint:SortListFrames(function SortFunction)`
Sorts the list frames using a given function.

## `void NexusCollapsableListFrameConstraint:AddListFrame(` [`NexusCollapsableListFrame`](../NexusCollapsableListFrame.md) ` ListFrame,int Index)`
Adds a list frame to the constraint.

## `void NexusCollapsableListFrameConstraint:RemoveListFrame(` [`NexusCollapsableListFrame`](../NexusCollapsableListFrame.md) ` ListFrame)`
Removes a list frame to the constraint.

## `void NexusCollapsableListFrameConstraint:ClearListFrames()`
Removes all of the list frames to the constraint.