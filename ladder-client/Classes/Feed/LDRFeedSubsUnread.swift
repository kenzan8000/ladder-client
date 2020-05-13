import CoreData
import SwiftyJSON

// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {

    // MARK: - property

    @NSManaged var subscribeId: String

    @NSManaged var rate: NSNumber
    @NSManaged var folder: String

    @NSManaged var title: String
    @NSManaged var link: String
    @NSManaged var feedlink: String
    @NSManaged var icon: String

    @NSManaged var unreadCount: NSNumber

    var rateValue: Int { self.rate.intValue }
    var unreadCountValue: Int { self.unreadCount.intValue }

    // MARK: - class method

    /// returns model count from coredata
    ///
    /// - Returns: count
    class func count() -> Int {
        let context = LDRCoreDataManager.shared.managedObjectContext

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
        do {
            count = try context.count(for: fetchRequest)
        } catch { count = 0 }

        return count
    }

    /// returns count of model by the rate
    ///
    /// - Parameters:
    ///   - subsunreads: subsunread models
    ///   - rate: rate star
    /// - Returns: count of model by the rate
    class func countOfTheRate(subsunreads: [LDRFeedSubsUnread], rate: Int) -> Int {
        let filtered = subsunreads.filter { $0.rateValue == rate }
        return filtered.count
    }

    /// returns count of model by the folder
    ///
    /// - Parameters:
    ///   - subsunreads: subsunread models
    ///   - folder: folder name
    /// - Returns: count of model by the folder
    class func countOfTheFloder(subsunreads: [LDRFeedSubsUnread], folder: String) -> Int {
        let filtered = subsunreads.filter { $0.folder == folder }
        return filtered.count
    }

    /// returns rates of subsunread models
    ///
    /// - Parameter subsunreads: subsunread models
    /// - Returns: rates of subsunread models
    class func getRates(subsunreads: [LDRFeedSubsUnread]) -> [Int] {
        var rates: [Int] = []
        for subsunread in subsunreads {
            let rateValue = subsunread.rateValue
            if rates.contains(rateValue) { continue }
            rates.append(rateValue)
        }
        return rates
    }

    /// returns folder names
    ///
    /// - Parameter subsunreads: subsunread models
    /// - Returns: folder names
    class func getFolders(subsunreads: [LDRFeedSubsUnread]) -> [String] {
        var folders: [String] = []
        for subsunread in subsunreads {
            if folders.contains(subsunread.folder) { continue }
            folders.append(subsunread.folder)
        }
        return folders
    }

    /// returns  rate name (stars)
    ///
    /// - Parameter rate: how many stars
    /// - Returns: rate name (stars)
    class func getRateName(rate: Int) -> String {
        var rateName = ""
        for i in 0 ..< 5 {
            rateName = ((rate >= 5 - i) ? "★" : "☆") + rateName
        }
        return rateName
    }
    
    /// fetch models from coredata
    ///
    /// - Parameter segment: search condition -> rate or folder
    /// - Returns: models from coredata
    class func fetch(segment: Int) -> [LDRFeedSubsUnread] {
        let context = LDRCoreDataManager.shared.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
        let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        var sortDescriptor: NSSortDescriptor?
        if segment == LDRFeedViewController.Segment.rate {
            sortDescriptor = NSSortDescriptor(key: #keyPath(LDRFeedSubsUnread.rate), ascending: false)
        } else if segment == LDRFeedViewController.Segment.folder {
            sortDescriptor = NSSortDescriptor(key: #keyPath(LDRFeedSubsUnread.folder), ascending: true)
        }
        if let descriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [descriptor]
        }
        
        fetchRequest.returnsObjectsAsFaults = false

        // return models
        var models: [LDRFeedSubsUnread] = []
        do {
            if let fetchedModels = try context.fetch(
                fetchRequest
            ) as? [LDRFeedSubsUnread] {
                models = fetchedModels
            }
        } catch {
            models = []
        }

        return models
    }

    /// save model
    ///
    /// - Parameter json: json representing the model
    /// - Returns: error of saving the model or no error if succeeded
    class func save(json: JSON) -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

        let items = json.arrayValue
        for item in items {
            guard let model = NSEntityDescription.insertNewObject(
                forEntityName: "LDRFeedSubsUnread",
                into: context
            ) as? LDRFeedSubsUnread else {
                continue
            }
            model.subscribeId = item["subscribe_id"].stringValue
            model.rate = NSNumber(value: item["rate"].intValue)
            model.folder = item["folder"].stringValue
            model.title = item["title"].stringValue
            model.link = item["link"].stringValue
            model.feedlink = item["feedlink"].stringValue
            model.icon = item["icon"].stringValue
            model.unreadCount = NSNumber(value: item["unread_count"].intValue)
        }

        do {
            try context.save()
        } catch {
            return LDRError.saveModelsFailed
        }

        return nil
    }

    /// delete all models
    ///
    /// - Returns: deletion error or nil if succeeded
    class func delete() -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

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
        do {
            if let fetchedModels = try context.fetch(fetchRequest) as? [LDRFeedSubsUnread] {
                models = fetchedModels
            }
        } catch {
            models = []
        }

        do {
            for model in models { context.delete(model) }
            try context.save()
        } catch {
            return LDRError.deleteModelsFailed
        }

        return nil
    }

}
