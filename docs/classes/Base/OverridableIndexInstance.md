# OverridableIndexInstance
(Extends `NexusInstance`)

Extends Nexus Instance to allow lower level
overriding of indexing.

## `OverridableIndexInstance:__rawget(Index)`
Returns the raw index of the object
(bypasses `__getindex`).

## `OverridableIndexInstance:__getindex(IndexName,OriginalReturn)`
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used

## `OverridableIndexInstance:__setindex(IndexName,NewValue)`
Returns the value for an index to be set. This is
run before the value of the object is set.