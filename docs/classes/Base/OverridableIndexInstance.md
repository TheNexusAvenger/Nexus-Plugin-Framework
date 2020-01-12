# OverridableIndexInstance
(extends `NexusInstance`)

Extends Nexus Instance to allow lower level
overriding of indexing.

## `object OverridableIndexInstance:__rawget(string Index)`
Returns the raw index of the object
(bypasses `__getindex`).

## `object,bool verridableIndexInstance:__getindex(string IndexName,object OriginalReturn)`
Returns the value for a custom index. If the second
value returned is true, it will force return the
returned value, even if it is nil. If not, regular
indexing will be used

## `object OverridableIndexInstance:__setindex(string IndexName,object NewValue)`
Returns the value for an index to be set. This is
run before the value of the object is set.