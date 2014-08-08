Tagged Identity Map
===================

An identity map for node.js -- and coming soon, browser support!

Installation
------------

    $ npm install tagged-identity-map

Usage
-----

**On the server**

    // Load an identity map for users
    var userIdentityMap = require('tagged-identity-map')('User');

    // Create your user instance
    userA = new User({
        id: 123,
        name: 'Bob'
    });
    userIdentityMap.put(123, userA);

    var userB = userIdentityMap.get(123);
    assert(userA === userB);

Auto merge
----------

The identity map will automatically merge identities together if the same identity already exists in the map.

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

Integration with your favorite web services is easy by utilizing the `identify()` function. This will automatically set the identity in the map, merge if it necessary, and return the merged identity.

    var userIdentityMap = require('tagged-identity-map')('User');

    // Function to get a single user from a web service
    var getUser = function(id) {
        return myUserService.get('/user/' + id)
        .then(function(user) {
            // This sets the domain entitity in the identity map,
            // merges with any existing identities,
            // and returns the merged result.
            return userIdentityMap.identify(id, user);
        });
    };

    // Function to get multiple users from a web service
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
    // even though two different API calls have returned info for that user.
    Q.all([
        getUser(123),
        getUsers([123, 456])
    ]).then(function(results) {
        // extract the user from the results to simplify the assertions below
        var userA = results[0];
        var userB = results[1][0];

        // Yay, both variables reference the same object!
        assert(userA.id === 123); // this object represents user with id 123
        assert(userB.id === 123); // this object also represents user 123
        assert(userA === userB); // both users reference the same JS object in memory

        // Let's try updating one of them to make sure they stay synced...
        assert(userA.name === 'Bob');
        assert(userB.name === 'Bob');
        userA.name = 'Joe'; // update userA's name
        assert(userA.name === 'Joe'); // surely this works...
        assert(userB.name === 'Joe'); // name is synced across references!
    });
