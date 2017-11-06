import CoreData


/// MARK: - LDRCoreDataManager
class LDRCoreDataManager {

    /// MARK: - class method
    static let shared = LDRCoreDataManager()


    /// MARK: - property
    var managedObjectModel: NSManagedObjectModel {
        let modelURL = Bundle.main.url(forResource: "LDRModel", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }

    private static var ldr_managedObjectContext: NSManagedObjectContext?
    var managedObjectContext: NSManagedObjectContext {
        if let context = LDRCoreDataManager.ldr_managedObjectContext { return context }

        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        LDRCoreDataManager.ldr_managedObjectContext = managedObjectContext
        return managedObjectContext
    }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = documentsDirectories[documentsDirectories.count - 1] as NSURL
        let storeURL = documentsDirectory.appendingPathComponent("LDRModel.sqlite")

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeURL,
                options: options
            )
        } catch {
        }

        return persistentStoreCoordinator
    }


    /// MARK: - initialization
    init() {
    }

}
