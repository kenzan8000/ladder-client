import CoreData

// MARK: - LDRPin
class LDRPin: NSManagedObject {

  // MARK: property

  @NSManaged var createdOn: Int
  @NSManaged var link: String
  @NSManaged var title: String

  var linkUrl: URL? { URL(string: link) }

  // MARK: class method
  
  /// Returns fixed type NSFetchRequest
  @nonobjc
  class func fetchRequest() -> NSFetchRequest<LDRPin> {
    NSFetchRequest<LDRPin>(entityName: "LDRPin")
  }
  
  /// returns count of model from coredata
  /// - Parameter storageProvider: for CoreData
  /// - Returns: number of pin count
  class func count(storageProvider: LDRStorageProvider) -> Int {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var cnt = 0
    do {
      cnt = try storageProvider.viewContext.count(for: fetchRequest)
    } catch {
      cnt = 0
    }
    return cnt
  }
    
  /// fetch models from coredata
  /// - Parameter storageProvider: for CoreData
  /// - Returns: models
  class func fetch(storageProvider: LDRStorageProvider) -> [LDRPin] {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LDRPin.createdOn, ascending: false)]
    do {
      return try storageProvider.viewContext.fetch(fetchRequest)
    } catch {
      return []
    }
  }
    
  /// returns if the ldr pin is already saved
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - link: link url string
  ///   - title: title of pin
  /// - Returns: Bool value if the ldr pin is already saved
  class func exists(storageProvider: LDRStorageProvider, link: String, title: String) -> Bool {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [
      NSPredicate(format: "(%K = %@)", #keyPath(LDRPin.link), link),
      NSPredicate(format: "(%K = %@)", #keyPath(LDRPin.title), title),
    ]
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try storageProvider.viewContext.count(for: fetchRequest) > 0
    } catch {
      return false
    }
  }
    
  /// save pin
  ///
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - createdOn: string representing date the pin is created
  ///   - title: title of pin
  ///   - link: link url string of pin
  /// - Returns: model saving error or nil if succeeded
  class func saveByAttributes(storageProvider: LDRStorageProvider, createdOn: Int, title: String, link: String) -> Error? {
    let model = LDRPin(context: storageProvider.viewContext)
    model.createdOn = createdOn
    model.title = title
    model.link = link
    do {
      try storageProvider.viewContext.save()
    } catch {
      return LDRError.saveModelsFailed
    }
    return nil
  }

  /// save pin
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - response: all pin response
  /// - Returns: model saving error or nil if succeeded
  class func save(storageProvider: LDRStorageProvider, responses: LDRPinAllResponse) -> Error? {
    for response in responses {
      let model = LDRPin(context: storageProvider.viewContext)
      model.createdOn = response.createdOn
      model.title = response.title
      model.link = response.link
      do {
        try storageProvider.viewContext.save()
      } catch {
        return LDRError.saveModelsFailed
      }
    }
    return nil
  }

  /// delete all pins
  /// - Parameter storageProvider: for CoreData
  /// - Returns: model deletion error or nil if succeeded
  class func deleteAll(storageProvider: LDRStorageProvider) -> Error? {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models = [LDRPin]()
    do {
      models = try storageProvider.viewContext.fetch(fetchRequest)
    } catch {
      models = []
    }
    for model in models {
      storageProvider.viewContext.delete(model)
    }
    do {
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
      return LDRError.deleteModelsFailed
    }
    return nil
  }

  /// delete pin
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - pin: pin to delete
  /// - Returns: model deletion error or nil if succeeded
  class func delete(storageProvider: LDRStorageProvider, pin: LDRPin) -> Error? {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate(format: "(%K = %@)", #keyPath(LDRPin.link), pin.link)]
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models = [LDRPin]()
    do {
      models = try storageProvider.viewContext.fetch(fetchRequest)
    } catch {
      models = []
    }
    for model in models {
      storageProvider.viewContext.delete(model)
    }
    do {
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
      return LDRError.deleteModelsFailed
    }
    return nil
  }
}

extension LDRPin: Identifiable {
}
