# NexusCollapsableListFrame
(extends [`NexusWrappedInstance<Frame>`](../../Base/NexusWrappedInstance.md))

Frame that can be expanded or collapsed to show additional information.
Intended to contain additional list frames.

## `NexusEvent NexusCollapsableListFrame.DoubleClicked`
Event that is invoked when the collapsable frame
is clicked double-clicked.

## `NexusEvent NexusCollapsableListFrame.DelayClicked`
Event that is invoked when the collapsable frame
is clicked and then clicked again after a period
of time has passed.

## `Color3 NexusCollapsableListFrame.HighlightColor3`
The color that is used when the frame is selected.

## `bool NexusCollapsableListFrame.ArrowVisible`
Determines if the arrow for collapsing and expanding
the frame is visible or not.

## `bool NexusCollapsableListFrame.Expanded`
Determines if the collapsable frame is expanded (showing
the collapsable container's contents).

## [`NexusWrappedInstance<Frame>`](../../Base/NexusWrappedInstance.md) ` NexusCollapsableListFrame:GetMainContainer()`
Returns the container that is next to the arrow and
is not collapsed.

## [`NexusWrappedInstance<Frame>`](../../Base/NexusWrappedInstance.md) ` NexusCollapsableListFrame:GetCollapsableContainer()`
Returns the collapsable container frame. Frames
parented to this will be shown or hidden based on
if the frame is expanded or collapsed.