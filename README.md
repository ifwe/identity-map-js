Tagged Identity Map
===================

An identity map for node.js and the browser.

Installation
------------

Usage
-----

    // on the server
    var identityMap = require('tagged-identity-map')('User');

    user1 = new User({
        id: 1,
        name: 'Bob'
    });
    identityMap.put(1, user);

    var user2 = identityMap.get(1);
    assert(user1 === user2);

Auto merge
----------

    var userA = new User({
        id: 123,
        name: 'Bob',
        photo: '//placehold.it/200x200'
    });

    var userB = new User({
        id: 123, // same ID as `userA`
        name: 'Joe',
        email: 'joe@example.com'
    });

    identityMap.put(123, userA);
    identityMap.put(123, userB); // merge happens here!

    var userC = identityMap.get(123);

    assert(userC.id === 123);
    assert(userC.name === 'Joe'); // `userB` overwrote `userA`'s value because it was `put()` last
    assert(userC.photo === '//placehold.it/200x200'); // this value wasn't lost in the merge
    assert(userC.email === 'joe@example.com'); // new value from `userB` was merged in.

Integration with your favorite web services

    var userIdentityMap = require('tagged-identity-map')('User');

    var getUser = function(id) {
        return myUserService.get('/user/' + id)
        .then(function(user) {
            // This sets the domain entitity in the identity map,
            // merges with any existing identities,
            // and returns the merged result.
            return userIdentityMap.identify(id, user);
        });
    };

    vat getUsers = function(ids) {
        return myUserService.get('/users/' + ids.join(','))
        .then(function(users) {
            // Loop through all users
            // and identify them all.
            for (var i in users) {
                users[i] = userIdentityMap.identify(user.id, user);
            }
            return users;
        });
    };

    // Now we can be sure we're dealing with the same instance of user 123
    // even though two different API calls have returned info for user 123
    Q.all([
        getUser(123),
        getUsers([123, 456])
    ]).then(function(results) {
        var userA = results[0];
        var userB = results[1][0];
        assert(userA.id === 123); // this object represents user with id 123
        assert(userB.id === 123); // this object also represents user 123
        assert(userA === userB); // both users reference the same JS object in memory

        assert(userA.name === 'Bob');
        assert(userB.name === 'Bob');
        userA.name = 'Joe'; // update userA's name
        assert(userA.name === 'Joe'); // surely this works...
        assert(userB.name === 'Joe'); // name is synced across references!
    });

