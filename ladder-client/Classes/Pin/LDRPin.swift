import CoreData
import SwiftyJSON


/// MARK: - LDRPin
class LDRPin: NSManagedObject {

    /// MARK: - property

    @NSManaged var createdOn: String
    @NSManaged var link: String
    @NSManaged var title: String

    var linkUrl: URL? { return URL(string: self.link) }


    /// MARK: - class method

    /**
     * count from coredata
     * @return Int
     */
    class func count() -> Int {
        let context = LDRCoreDataManager.shared.managedObjectContext

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
        let context = LDRCoreDataManager.shared.managedObjectContext

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
     * already saved the pin?
     * @param link String
     * @param title String
     * @return BOOL
     */
    class func alreadySavedPin(link: String, title: String) -> Bool {
        let context = LDRCoreDataManager.shared.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
        let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = [NSPredicate(format: "(link = %@)", link), NSPredicate(format: "(title = %@)", title)]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.returnsObjectsAsFaults = false

        // return count
        var count = 0
        do { count = try context.count(for: fetchRequest) }
        catch { count = 0 }

        return (count > 0)
    }


    /**
     * save
     * @param createdOn String
     * @param title String
     * @param link String
     * @return Error?
     */
    class func saveByAttributes(createdOn: String, title: String, link: String) -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

        let model = NSEntityDescription.insertNewObject(forEntityName: "LDRPin", into: context) as! LDRPin
        model.createdOn = ""
        model.title = title
        model.link = link

        do { try context.save() }
        catch { return LDRError.saveModelsFailed }

        return nil
    }

    /**
     * save
     * @param json JSON
     * @return Error?
     */
    class func save(json: JSON) -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

        let items = json.arrayValue
        for item in items {
            let model = NSEntityDescription.insertNewObject(forEntityName: "LDRPin", into: context) as! LDRPin
            model.createdOn = item["created_on"].stringValue
            model.title = item["title"].stringValue
            model.link = item["link"].stringValue
        }

        do { try context.save() }
        catch { return LDRError.saveModelsFailed }

        return nil
    }

    /**
     * delete
     * @return Error?
     */
    class func deleteAll() -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

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

    /**
     * delete
     * @param pin LDRPin to delete
     * @return Error?
     */
    class func delete(pin: LDRPin) -> Error? {
        let context = LDRCoreDataManager.shared.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
        let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let predicates: [NSPredicate] = [NSPredicate(format: "(link = %@)", pin.link)]
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
