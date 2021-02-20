import CoreData
import SwiftyJSON

// MARK: - LDRPin
class LDRPin: NSManagedObject {

  // MARK: - property

  @NSManaged var createdOn: String
  @NSManaged var link: String
  @NSManaged var title: String

  var linkUrl: URL? { URL(string: self.link) }

  // MARK: - class method
    
  /// returns count of model from coredata
  ///
  /// - Returns: count of model
  class func count() -> Int {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
    let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = []
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var cnt = 0
    do {
      cnt = try context.count(for: fetchRequest)
    } catch {
      cnt = 0
    }
    return cnt
  }
    
  /// fetch models from coredata
  ///
  /// - Returns: models
  class func fetch() -> [LDRPin] {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
    let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(LDRPin.createdOn), ascending: false)]
    var models: [LDRPin] = []
    do {
      if let fetchedModels = try context.fetch(fetchRequest) as? [LDRPin] {
        models = fetchedModels
      }
    } catch { models = [] }
    return models
  }
    
  /// returns if the ldr pin is already saved
  ///
  /// - Parameters:
  ///   - link: link url string
  ///   - title: title of pin
  /// - Returns: Bool value if the ldr pin is already saved
  class func exists(link: String, title: String) -> Bool {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
    let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = [NSPredicate(format: "(link = %@)", link), NSPredicate(format: "(title = %@)", title)]
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var cnt = 0
    do {
      cnt = try context.count(for: fetchRequest)
    } catch { cnt = 0 }
    return cnt > 0
  }
    
  /// save pin
  ///
  /// - Parameters:
  ///   - createdOn: string representing date the pin is created
  ///   - title: title of pin
  ///   - link: link url string of pin
  /// - Returns: model saving error or nil if succeeded
  class func saveByAttributes(createdOn: String, title: String, link: String) -> Error? {
    let context = LDRCoreDataManager.shared.managedObjectContext
    guard let model = NSEntityDescription.insertNewObject(
      forEntityName: "LDRPin",
      into: context
    ) as? LDRPin else {
      return nil
    }
    model.createdOn = ""
    model.title = title
    model.link = link
    do {
      try context.save()
    } catch {
      return LDRError.saveModelsFailed
    }
    return nil
  }

  /// save pin
  ///
  /// - Parameter responses: LDRPinAllResponses
  /// - Returns: model saving error or nil if succeeded
  class func save(responses: LDRPinAllResponses) -> Error? {
    for response in responses {
      let context = LDRCoreDataManager.shared.managedObjectContext
      guard let model = NSEntityDescription.insertNewObject(
        forEntityName: "LDRPin",
        into: context
      ) as? LDRPin else {
        return nil
      }
      model.createdOn = "\(response.createdOn)"
      model.title = response.title
      model.link = response.link
      do {
        try context.save()
      } catch {
        return LDRError.saveModelsFailed
      }
    }
    return nil
  }

  /// delete all pins
  ///
  /// - Returns: model deletion error or nil if succeeded
  class func deleteAll() -> Error? {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
    let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = []
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models: [LDRPin] = []
    do {
      if let fetchedModels = try context.fetch(fetchRequest) as? [LDRPin] {
        models = fetchedModels
      }
    } catch {
      models = []
    }
    for model in models { context.delete(model) }
    do {
      try context.save()
    } catch {
      return LDRError.deleteModelsFailed
    }
    return nil
  }

  /// delete pin
  ///
  /// - Parameter pin: pin you want to delete
  /// - Returns: model deletion error or nil if succeeded
  class func delete(pin: LDRPin) -> Error? {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRPin")
    let entity = NSEntityDescription.entity(forEntityName: "LDRPin", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = [NSPredicate(format: "(link = %@)", pin.link)]
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models: [LDRPin] = []
    do {
      if let fetchedModels = try context.fetch(fetchRequest) as? [LDRPin] {
        models = fetchedModels
      }
    } catch {
      models = []
    }
    for model in models { context.delete(model) }
    do {
      try context.save()
    } catch {
      return LDRError.deleteModelsFailed
    }
    return nil
  }
}

extension LDRPin: Identifiable {
}
