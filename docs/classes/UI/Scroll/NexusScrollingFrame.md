# NexusScrollingFrame
(extends [`NexusWrappedInstance<ScrollingFrame>`](../../Base/NexusWrappedInstance.md))

## `static NexusScrollingFrame NexusScrollingFrame.new(`[`NexusScrollTheme`](../../Data/Enum/NexusEnumCollection.md) ` Theme)`
Creates a Nexus Scrolling Frame object.

## `Color3 NexusScrollingFrame.ScrollColor3`
Color of the background of the scroll bar and buttons.

!!! note
    This is only for the `Theme` being `NexusEnum.NexusScrollTheme.Qt5` in
    the constructor. This has no effect for `NexusEnum.NexusScrollTheme.Native`.

## `Color3 NexusScrollingFrame.ScrollBackgroundColor3`
Color of the background of the scroll bars' background.

!!! note
    This is only for the `Theme` being `NexusEnum.NexusScrollTheme.Qt5` in
    the constructor. This has no effect for `NexusEnum.NexusScrollTheme.Native`.

## `Color3 NexusScrollingFrame.ScrollArrowColor3`
Color of the arrows on the buttons.

!!! note
    This is only for the `Theme` being `NexusEnum.NexusScrollTheme.Qt5` in
    the constructor. This has no effect for `NexusEnum.NexusScrollTheme.Native`.

## `int NexusScrollingFrame.ScrollBarButtonIncrement`
Increment of how many pixels the canvas size moves
when pressing the scroll bar buttons.

!!! note
    This is only for the `Theme` being `NexusEnum.NexusScrollTheme.Qt5` in
    the constructor. This has no effect for `NexusEnum.NexusScrollTheme.Native`.