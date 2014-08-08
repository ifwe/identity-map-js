class IdentityMap
    constructor: ->
        @_identities = {}

    put: (id, obj) ->
        previous = @get id
        obj = @_merge previous, obj if previous
        @_identities[id] = obj

    get: (id) ->
        if @_identities[id]? then @_identities[id] else null

    has: (id) ->
        @_identities[id]?

    identify: (id, obj) ->
        @put id, obj
        @get id

    _merge: (obj1, obj2) ->
        MergeRecursive obj1, obj2

module.exports = IdentityMap

MergeRecursive = (obj1, obj2) ->
    for p of obj2
        continue unless obj2.hasOwnProperty p

        if obj2.hasOwnProperty p
            # Property in destination object set; update its value.
            obj1[p] = if obj2[p].constructor == Object then MergeRecursive obj1[p], obj2[p] else obj2[p]
        else
            # Property in destination object not set; create it and set its value.
            obj1[p] = obj2[p]

    obj1
