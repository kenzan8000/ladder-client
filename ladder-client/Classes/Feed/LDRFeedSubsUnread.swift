import CoreData


/// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {

    /// MARK: - property

    @NSManaged var subscribeId: String

    @NSManaged var rate: NSNumber
    @NSManaged var folder: String

    @NSManaged var link: String
    @NSManaged var feedlink: String
    @NSManaged var icon: String

    @NSManaged var unreadCount: NSNumber

    var rateValue: Int {
        return self.rate.intValue
    }

    var unreadCountValue: Int {
        return self.unreadCount.intValue
    }


    /// MARK: - class method

    /**
     * count from coredata
     * @return Int
     */
    class func count() -> Int {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
        let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
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
     * @return [LDRFeedSubsUnread]
     */
    class func fetch() -> [LDRFeedSubsUnread] {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
        let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return models
        var models: [LDRFeedSubsUnread] = []
        do { models = try context.fetch(fetchRequest) as! [LDRFeedSubsUnread] }
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
        let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return models
        var models: [LDRFeedSubsUnread] = []
        do { models = try context.fetch(fetchRequest) as! [LDRFeedSubsUnread] }
        catch { models = [] }

        do {
            for model in models { context.delete(model) }
            try context.save()
        }
        catch { return LDRError.DeleteModelsFailed }

        return nil
    }

}
