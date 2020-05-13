import Foundation

print("The app is loading...")
let dbController = makeDatabaseController()
print("Ready")

// ...
let contextChanged = true
// ...
if contextChanged {
    dbController.save()
}
