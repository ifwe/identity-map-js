IdentityMap = require './IdentityMap'
identityMaps = {}

module.exports = (name = '__default') ->
    identityMaps[name] = new IdentityMap() unless identityMaps[name]?
    return identityMaps[name]
