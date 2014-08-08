factory = require "#{LIB_DIR}/factory"
IdentityMap = require "#{LIB_DIR}/IdentityMap"

describe 'Factory', ->
    it 'exists', ->
        factory.should.exist

    it 'is a function', ->
        factory.should.be.a 'function'

    it 'returns an instance of `IdentityMap`', ->
        factory().should.be.instanceOf IdentityMap

    it 'returns identical instance on multiple calls', ->
        map1 = factory()
        map2 = factory()
        map1.should.equal map2

    describe 'named maps', ->
        it 'returns an instance of `IdentityMap`', ->
            factory('test').should.be.instanceOf IdentityMap

        it 'is different instance than default identity map', ->
            mapDefault = factory()
            mapNamed = factory 'test'
            mapDefault.should.not.equal mapNamed

        it 'is different from other named instances', ->
            mapNamed1 = factory 'test'
            mapNamed2 = factory 'foo'
            mapNamed1.should.not.equal mapNamed2

        it 'is the same as identically named map', ->
            mapNamed1 = factory 'test'
            mapNamed2 = factory 'test' # same name
            mapNamed1.should.equal mapNamed2
