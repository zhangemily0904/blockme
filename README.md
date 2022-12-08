# BlockMe
## About The App
BlockMe is a Carnegie Mellon University meal block marketplace where students can sell their surplus blocks or get blocks for less! BlockMe is designed to be a minimal app that can quickly facilitate transactions whenever you need it!

## Features
As a meal block marketplace, BlockMe allows users to list their meal block up for sale anytime during the day. Users can choose the pricing of their block, the expiration time of the listing, and where they are willing to meet the other party to block them. Sellers can easily browse the marketplace to find a block listing best suited for their needs and easily request to purchase the block. 

Since block transactions must be in person and cannot be transfered online, we have carefully designed a transaction process that will guide the buyer and seller throughout the whole transaction journey. There are multiple checkpoints in place to ensure that both parties are on the same page. 

Users can also easily view their order history in the app.

However, BlockMe does not handle payments or messaging on platform. We provide the necessary contact info of users instead. 

## Constraints
BlockMe implements several contrainsts on how to use the marketplace.
1. A user can only have one active listing at a time. 
2. A user cannot buy a block if they have an active listing.
3. A user cannot buy their own listing.
4. Expiration time for new listings must be before 12:00am of the current day.

## Unit Tests
BlockMe currently does not have any unit tests written for its backend. The backend is comprised of all firebase related logic. While trying to write unit tests, our team ran into a problem that we couldn't solve within the time contraints. While trying to compile and run the unit tests, xcode complains about Firebase not being configured although we have configured firebase properly in the app delegate. Upon further research, we found the following stackoverflow articles: [Firebase Configuration Error](https://stackoverflow.com/questions/60753233/the-default-firebaseapp-instance-must-be-configured-before-the-defaultfirebaseap), [Including Modules in Unit Tests](https://stackoverflow.com/questions/58125428/missing-required-module-xyz-on-unit-tests-when-using-swift-package-manager).

From these articles, we concluded that somehow our project isn't happy with us linking Firebase dependencies in both the app and the unit tests. Upon removing the binary links and any firebase calls for the unit tests, the tests are able to compile and run properly. However, we are still unable to conduct any testing since our backend is all firebase related models / viewmodels. We have dedicated severals days in Sprint 6 to solve this problem and have consulted Prof H and multiple TAs. As a team, we have made the collective decision to focus our time on other tasks in order to make our app well rounded and complete.

## Demoing the App
To best experience BlockMe, we recommend to test the app with 2 accounts on separate devices or simulators. This way, the 2 accounts can interact with each other through transactions as the respective buyer and seller. 
