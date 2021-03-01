import CoreData

// MARK: - LDRCoreDataManager
class LDRCoreDataManager {

  // MARK: static property
  static let shared = LDRCoreDataManager()

  // MARK: property
  let persistentContainer: NSPersistentContainer
  var managedObjectContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: initialization
  init() {
    persistentContainer = NSPersistentContainer(name: "LDRModel")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }

}
