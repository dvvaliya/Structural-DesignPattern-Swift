import Foundation

public protocol DatabaseController {
    func save()
    func undo()
}

public class CoreDataManager: DatabaseController {
    public init() {
        sleep(3)
    }
    
    public func save() {
        print("All changes saved")
    }
    
    public func undo() {
        print("All changes reverted")
    }
}


public class CoreDataProxy: DatabaseController {
    lazy private var coreDataManager: CoreDataManager = CoreDataManager()
    
    public func save() {
        coreDataManager.save()
    }
    
    public func undo() {
        coreDataManager.undo()
    }
}

public func makeDatabaseController() -> DatabaseController {
    CoreDataProxy()
}
