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

## Use Cases
### A-Level
1. Users can register and login (authentication)
2. Users can see a navigation bar
3. Buyers can see a list of blocks available for purchase along with information about dining options, price, and expiration time
4. Buyers can purchase a block
5. Sellers can create a listing
6. Sellers can accept or decline the purchase request for my block 
7. Sellers can update their listings
8. Sellers can delete their listings
9. Users can cancel the transaction in the middle of the purchase/sell process
10. Users can filter listings
11. Users can sort listings
12. Users can rate each other

### B-Level
1. Tabs inside the orders view to separate sold and bought orders 


## Unit Tests
BlockMe's backend is comprised mainly of firebase related classes. While writing out unit tests, our team ran into problems that prevented us from writing async related tests (aka Firebase calls). Screenshots of the error are included below. We tried to solve this problem for several days with multiple team members looking at the issue. We also talked to our TA and found out other teams were experiencing the same error. We concluded that it was better worth our time to polish our other deliverables rather than sinking more time into the unit tests. 
![Screen Shot 2022-12-14 at 8 07 14 PM](https://user-images.githubusercontent.com/72707689/207753995-68b39432-6650-4f78-9ec7-344150943338.png)
![Screen Shot 2022-12-14 at 8 11 03 PM](https://user-images.githubusercontent.com/72707689/207753996-b7907e6d-6029-4dd0-860b-c356d7d40bfc.png)

We do have unit tests for the classes that don't utilize Firebase.

## Demoing the App
To best experience BlockMe, we recommend to test the app with 2 accounts on separate devices or simulators. This way, the 2 accounts can interact with each other through transactions as the respective buyer and seller. The app is configured to automatically run in light mode, but please switch to light mode manually for best experience if the configuration did not work on your device.
