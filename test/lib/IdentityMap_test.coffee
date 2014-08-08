IdentityMap = require "#{LIB_DIR}/IdentityMap"

describe 'IdentityMap', ->
    beforeEach ->
        @map = new IdentityMap()

    describe 'put and get', ->
        it 'returns null when id is not found', ->
            expect(@map.get('anything')).to.be.null

        it 'returns identity when id is found', ->
            @map.put('my_id', 'canary')
            @map.get('my_id').should.equal 'canary'

        it 'merges objects when putting to an existing id', ->
            @map.put 'my_id',
                foo: 'bar'
                derp: 'doo'

            @map.put 'my_id',
                foo: 'blerp'
                herp: 'derp'

            @map.get('my_id').should.deep.equal
                foo: 'blerp'
                derp: 'doo'
                herp: 'derp'

    describe 'identify', ->
        it 'places object in map if not set', ->
            @map.identify 'my_id', 'canary'
            @map.get('my_id').should.equal 'canary'

        it 'returns object from map', ->
            @map.identify('my_id', 'canary').should.equal 'canary'

        it 'returns merged object from map', ->
            @map.put 'my_id',
                foo: 'bar'
                derp: 'doo'

            result = @map.identify 'my_id',
                foo: 'blerp'
                herp: 'derp'

            result.should.deep.equal
                foo: 'blerp'
                derp: 'doo'
                herp: 'derp'

        it 'is idempotent', ->
            result1 = @map.identify 'my_id',
                foo: 'bar'

            result2 = @map.identify 'my_id',
                foo: 'bar'

            result1.should.equal.result2

        it 'supports instances', ->
            class User
                someMethod: sinon.spy()

            userA = new User()
            userA.someMethod.should.be.a 'function' # sanity check
            userB = @map.identify 'my_id', userA
            userB.someMethod.should.be.a 'function' # sanity check
            userB.someMethod()
            userB.someMethod.called.should.be.true
            userA.someMethod.called.should.be.true
