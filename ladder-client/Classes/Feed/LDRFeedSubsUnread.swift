import CoreData

// MARK: - LDRFeedSubsUnread

class LDRFeedSubsUnread: NSManagedObject {
  // MARK: enum
  enum Segment: Int {
    case rate = 0
    case folder = 1
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
  /// - Returns: count
  class func count() -> Int {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try context.count(for: fetchRequest)
    } catch {
      return 0
    }
  }

  /// returns count of model by the rate
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - rate: rate star
  /// - Returns: count of model by the rate
  class func countOfTheRateInt(subsunreads: [LDRFeedSubsUnread], rate: Int) -> Int {
    subsunreads
      .filter { $0.rate == rate }
      .count
  }
    
  /// Returns filtered subsunread array by rate
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - rate: rate string
  /// - Returns: filtered subsunread models
  class func filter(subsunreads: [LDRFeedSubsUnread], rate: String) -> [LDRFeedSubsUnread] {
    subsunreads
      .filter { $0.rateString == rate }
      .sorted { $0.title < $1.title }
  }

  /// returns count of model by the folder
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - folder: folder name
  /// - Returns: count of model by the folder
  class func countOfTheFloder(subsunreads: [LDRFeedSubsUnread], folder: String) -> Int {
    subsunreads
      .filter { $0.folder == folder }
      .count
  }
    
  /// Returns filtered subsunread array by rate
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - folder: folder string
  /// - Returns: filtered subsunread models
  class func filter(subsunreads: [LDRFeedSubsUnread], folder: String) -> [LDRFeedSubsUnread] {
    subsunreads
      .filter { $0.folder == folder }
      .sorted { $0.title < $1.title }
  }

  /// Returns Rate Strings from subsunread array
  /// - Parameter subsunreads:subsunread array
  /// - Returns: Rate Strings e.g. "★★★☆☆" when rate equals to 3
  class func getRates(subsunreads: [LDRFeedSubsUnread]) -> [String] {
    Array(
      Set(subsunreads.map { $0.rateString })
    ).sorted()
  }

  /// returns folder names
  /// - Parameter subsunreads: subsunread models
  /// - Returns: folder names
  class func getFolders(subsunreads: [LDRFeedSubsUnread]) -> [String] {
    Array(
      Set(subsunreads.map { $0.folder })
    ).sorted()
  }

  /// fetch models from coredata
  ///
  /// - Parameter segment: search condition -> rate or folder
  /// - Returns: models from coredata
  class func fetch(segment: Segment) -> [LDRFeedSubsUnread] {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    var sortDescriptor: NSSortDescriptor?
    if segment == .rate {
      sortDescriptor = NSSortDescriptor(keyPath: \LDRFeedSubsUnread.rate, ascending: false)
    } else if segment == .folder {
      sortDescriptor = NSSortDescriptor(keyPath: \LDRFeedSubsUnread.folder, ascending: true)
    }
    if let descriptor = sortDescriptor {
      fetchRequest.sortDescriptors = [descriptor]
    }
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try context.fetch(fetchRequest)
    } catch {
      return []
    }
  }

  /// save model
  ///
  /// - Parameter response: LDRSubsResponse
  /// - Returns: error of saving the model or no error if succeeded
  class func save(response: LDRSubsResponse) -> Error? {
    let context = LDRCoreDataManager.shared.managedObjectContext
    for item in response {
      let model = LDRFeedSubsUnread(context: context)
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
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let predicates = [NSPredicate]()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var models = [LDRFeedSubsUnread]()
    do {
      models = try context.fetch(fetchRequest)
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

// MARK: - LDRFeedSubsUnread + Identifiable
extension LDRFeedSubsUnread: Identifiable {
}
