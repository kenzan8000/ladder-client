import CoreData

// MARK: - LDRStorageProvider
final class LDRStorageProvider {

  // MARK: property
  let persistentContainer: NSPersistentContainer
  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: initialization
  init() {
    persistentContainer = NSPersistentContainer(name: "LDRCoreData")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }

}
