# NexusEnum
(extends [`OverridableIndexInstance`](../../Base/OverridableIndexInstance.md))

Custom enum that contains a set of items, including Enums.

## `static NexusEnum NexusEnum.new(string Name)`
Creates an NexusEnum object.

## `string NexusEnum.Name`
The name of the enum.

## `NexusEnum NexusEnum.ParentEnum`
The parent enum of the enum. By default,
it is nil and is defined with `NexusEnum:AddEnum`.

## `NexusEnum NexusEnum:GetEnum(string EnumName)`
Returns an enum for the name.

## `List<NexusEnum> NexusEnum:GetEnumItems()`
Returns a list of the sub-enums.

## `void NexusEnum:AddEnum(NexusEnum EnumInstance)`
Adds an Enum.

## `NexusEnum NexusEnum:CreateEnum(string ...)`
Creates an Enum.

## `bool NexusEnum:Equals(NexusEnum OtherEnum)`
Returns if another enum item is equal.