# monopoly_money

A simple android app I made for my brother, and I. We enjoy playing monopoly and wanted to make games quicker without worrying about cleaning up and organizing the money every time, so I made this app. 

## ONLY GOOD FOR SELF HOSTING:
The app uses Firebase for the backend, because for such a simple app hosting my own backend would have been unneccessary. This app is meant to be entierly self hosted, as there is no backend security, data is created from the app and uploaded to Firestore. This app performs client side validation, and uses the client as the source of truth.

create a fireabse_options.dart file, and follow steps on the Firebase documentation for Flutter. Setup can also be found on the Firebase console itself, by adding Flutter as an app. 

## HOW IT WORKS: 
This project uses an ORM, the objects themselves manage DB uploads, are synced with the server(using a `StreamSubscription`), and updates listening ui componenets as all game classes inherit from the `ChangeNotifier` class. As well, the game classes provide utility functions for managing the game, bank, and the players. 

A gameKey is the collection name, and that is the identifier for a game. Checking to see if the gameKey has not been previously used has not been implemented. 

### BaseMoneyInteractor
A class which inherits from `ChangeNotifier`. This class represents documents in the database which are able to use money. 

- Has a money field(integer) (managed by following methods)
- Has a name field(string)
- Has a gameKey field(string) (used for Firestore storage)

Provides the functions: 
- `saveMoney()`
- `sendMoney()`: where the recipient is also a `BaseMoneyInteractor`, and the amount is an integer. As well there a reason argument which is a string, and is used in logs. 

However, this class does not feature an implementation for the `create()` method, so that inheriting classes can define the shape of its own data. 

*`Player`, and `Bank` inherit from this object.*

### Player
Inherits from `BaseMoneyInteractor`
- Added a banker field(boolean), to determine if the player is the banker. 
- Implements create method. 
### Bank 
Inherits from `BaseMoneyInteractor`
- Added a banker field(`Player`) which points to the player who is the banker. 

### Game
The game object stores the current/local player(`Game.self`), the bank(`Game.bank`), and the players(`game.players`)

- The game watches for new documents being added to the game collection on firestore( a document represents a player), and adds the player to the game on all connected devices.
- The game allows for "authentication", which just performs a check to see if a player with the same name has already been registered, and if so does not make another player, and just locally adds the player. Otherwise the player is created locally and on Firestore.

As well the game stores it's `gameKey`, and is used for Firestore operations.

The `gameFromExisting()` method is used to join an existing game with a given game key. Returns a game, and adds the player. The `authenticatePlayer` method should be ran after. 

### Logs
TODO: Although logging has been fully implemented as a game class, the UI has not been made. It will be created in the future using a simple stream builder, it will not have the more complicated self updating system the previously mentioned classes have.