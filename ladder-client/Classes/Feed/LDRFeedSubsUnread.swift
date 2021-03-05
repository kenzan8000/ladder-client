import CoreData

// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {
  // MARK: enum
  enum Segment {
    case rate
    case folder
  }
  
  @objc
  enum State: Int64 {
    case unloaded = 0
    case unread = 1
    case read = 2
  }
  
  // MARK: property
  @NSManaged var subscribeId: Int
  @NSManaged var rate: Int
  @NSManaged var folder: String
  @NSManaged var title: String
  @NSManaged var link: String
  @NSManaged var feedlink: String
  @NSManaged var icon: String
  @NSManaged var unreadCount: Int
  @NSManaged var state: State
  @NSManaged var unreads: Set<LDRFeedUnread>

  var rateString: String {
    (0 ..< 5)
      .map { ((rate >= 5 - $0) ? "★" : "☆") }
      .reversed()
      .joined()
  }
  
  // MARK: class method
  
  /// Returns fixed type NSFetchRequest
  @nonobjc
  class func fetchRequest() -> NSFetchRequest<LDRFeedSubsUnread> {
    NSFetchRequest<LDRFeedSubsUnread>(entityName: "LDRFeedSubsUnread")
  }
  
  /// returns model count from coredata
  /// - Parameter storageProvider: for CoreData
  /// - Returns: count
  class func count(storageProvider: LDRStorageProvider) -> Int {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try storageProvider.viewContext.count(for: fetchRequest)
    } catch {
      return 0
    }
  }

  /// fetch models from coredata
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - segment: search condition -> rate or folder
  /// - Returns: models from coredata
  class func fetch(storageProvider: LDRStorageProvider, segment: Segment) -> [LDRFeedSubsUnread] {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    var sortDescriptor: NSSortDescriptor?
    switch segment {
    case .rate:
      sortDescriptor = NSSortDescriptor(keyPath: \LDRFeedSubsUnread.rate, ascending: false)
    case .folder:
      sortDescriptor = NSSortDescriptor(keyPath: \LDRFeedSubsUnread.folder, ascending: true)
    }
    if let descriptor = sortDescriptor {
      fetchRequest.sortDescriptors = [descriptor]
    }
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try storageProvider.viewContext.fetch(fetchRequest)
    } catch {
      return []
    }
  }

  /// save model
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - response: LDRSubsResponse
  /// - Returns: error of saving the model or no error if succeeded
  class func save(storageProvider: LDRStorageProvider, response: LDRSubsResponse) -> Error? {
    for item in response {
      let model = LDRFeedSubsUnread(context: storageProvider.viewContext)
      model.subscribeId = item.subscribeId
      model.rate = item.rate
      model.folder = item.folder
      model.title = item.title
      model.link = item.link
      model.feedlink = item.feedlink
      model.icon = item.icon
      model.unreadCount = item.unreadCount
    }
    do {
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
      return LDRError.saveModelsFailed
    }
    return nil
  }
  
  /// delete all models
  /// - Parameter storageProvider: for CoreData
  /// - Returns: deletion error or nil if succeeded
  class func delete(storageProvider: LDRStorageProvider) -> Error? {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models = [LDRFeedSubsUnread]()
    do {
      models = try storageProvider.viewContext.fetch(fetchRequest)
    } catch {
      models = []
    }
    do {
      for model in models { storageProvider.viewContext.delete(model) }
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
      return LDRError.deleteModelsFailed
    }
    return nil
  }
  
  // MARK: public api
  
  /// Updates state
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - state: LDRFeedSubsUnerad.State
  func update(storageProvider: LDRStorageProvider, state: State) {
    self.state = state
    do {
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
    }
  }
}

// MARK: - LDRFeedSubsUnread + Identifiable
extension LDRFeedSubsUnread: Identifiable {
}
