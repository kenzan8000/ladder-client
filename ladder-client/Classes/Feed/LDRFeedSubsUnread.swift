import CoreData


/// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {

    /// MARK: - property

    @NSManaged var subscribeId: String

    @NSManaged var rate: NSNumber
    @NSManaged var folder: String

    @NSManaged var title: String
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
     * count number of the rate
     * @param subsunreads [LDRFeedSubsUnread]
     * @param rate the rate
     * @return Int
     **/
    class func countOfTheRate(subsunreads: [LDRFeedSubsUnread], rate: Int) -> Int {
        let filtered = subsunreads.filter { $0.rateValue == rate }
        return filtered.count
    }

    /**
     * count number of the folder
     * @param subsunreads [LDRFeedSubsUnread]
     * @param folder the folder
     * @return Int
     **/
    class func countOfTheFloder(subsunreads: [LDRFeedSubsUnread], folder: String) -> Int {
        let filtered = subsunreads.filter { $0.folder == folder }
        return filtered.count
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
     * save
     * @param json JSON
     * @return Error?
     */
    class func save(json: JSON) -> Error? {
        let context = LDRCoreDataManager.sharedInstance.managedObjectContext

        let items = json.arrayValue
        for item in items {
            let model = NSEntityDescription.insertNewObject(forEntityName: "LDRFeedSubsUnread", into: context) as! LDRFeedSubsUnread
            model.subscribeId = item["subscribe_id"].stringValue
            model.rate = NSNumber(value: item["rate"].intValue)
            model.folder = item["folder"].stringValue
            model.title = item["title"].stringValue
            model.link = item["link"].stringValue
            model.feedlink = item["feedlink"].stringValue
            model.icon = item["icon"].stringValue
            model.unreadCount = NSNumber(value: item["unread_count"].intValue)
        }

        do { try context.save() }
        catch { return LDRError.saveModelsFailed }

        return nil
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
        catch { return LDRError.deleteModelsFailed }

        return nil
    }

}
