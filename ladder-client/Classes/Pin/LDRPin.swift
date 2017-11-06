import CoreData


/// MARK: - LDRPin
class LDRPin: NSManagedObject {

    /// MARK: - property

    @NSManaged var createdOn: String
    @NSManaged var link: String
    @NSManaged var title: String

    var linkUrl: URL? {
        return URL(string: self.link)
    }



    /// MARK: - class method

    /**
     * count from coredata
     * @return Int
     */
    class func count() -> Int {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
        let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return count
        var count = 0
        do { count = try context.count(for: fetchRequest) }
        catch { count = 0 }

        return count
    }

    /**
     * fetch from coredata
     * @return [LDRPin]
     */
    class func fetch() -> [LDRPin] {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
        let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return models
        var models: [LDRPin] = []
        do { models = try context.fetch(fetchRequest) as! [LDRPin] }
        catch { models = [] }

        return models
    }

    /**
     * delete
     * @return Error?
     */
    class func delete() -> Error? {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
        let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return models
        var models: [LDRPin] = []
        do { models = try context.fetch(fetchRequest) as! [LDRPin] }
        catch { models = [] }

        do {
            for model in models { context.delete(model) }
            try context.save()
        }
        catch { return LDRError.deleteModelsFailed }

        return nil
    }

}
