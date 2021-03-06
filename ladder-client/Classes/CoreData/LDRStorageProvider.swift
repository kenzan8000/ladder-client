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
    guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .ldrGroup) else {
      fatalError("Could not find shared coredata file.")
    }
    persistentContainer = NSPersistentContainer(name: "LDRCoreData")
    persistentContainer.persistentStoreDescriptions.first?.url = url.appendingPathComponent("LDRCoreData.sqlite")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }

}
