# NexusUserInput
(extends [`NexusContainer`](../Base/NexusContainer.md))

Static class for user input. Recommended to only use it
for key presses since the key presses are from all PluginGuis
and main viewport.

## `static NexusEvent NexusUserInput.InputBegan`
Fired when a user begins interacting via a Human-Computer
Interface device - such as a mouse or gamepad. Replaced
by non-static versions when the `NexusUserInput` class is
instanciated instead of being used as a static class.

## `static NexusEvent NexusUserInput.InputChanged`
Fired when a user changes how they’re interacting via a
Human-Computer Interface device. Replaced by non-static
versions when the `NexusUserInput` class is instanciated
instead of being used as a static class.

## `static NexusUserInput.InputEnded`
Fires when a user stops interacting via a Human-Computer
Interface device. Replaced by non-static versions when the
`NexusUserInput` class is instanciated instead of being
used as a static class.

## `void NexusUserInput:OnInputBegan(InputObject InputObject,bool Processed)`
Invoked when an input is began.

## `void NexusUserInput:OnInputChanged(InputObject InputObject,bool Processed)`
Invoked when an input is changed.

## `void NexusUserInput:OnInputEnded(InputObject InputObject,bool Processed)`
Invoked when an input is ended.

## `void NexusUserInput:AddContext(Instance Frame)`
Adds a context for getting inputs.

## `void NexusUserInput:RemoveContext(Instance Frame)`
Removes a context for getting inputs.