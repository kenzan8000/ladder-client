import CoreData
import SwiftyJSON

// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {
  // MARK: enum
  enum Segment: Int {
    case rate = 0
    case folder = 1
  }
    
  // MARK: property
  @NSManaged var subscribeId: String
  @NSManaged var rate: NSNumber
  @NSManaged var folder: String
  @NSManaged var title: String
  @NSManaged var link: String
  @NSManaged var feedlink: String
  @NSManaged var icon: String
  @NSManaged var unreadCount: NSNumber

  var rateValue: Int { self.rate.intValue }
  var rateString: String {
    (0 ..< 5)
      .map { ((rate.intValue >= 5 - $0) ? "★" : "☆") }
      .reversed()
      .joined()
  }
  var unreadCountValue: Int { self.unreadCount.intValue }
  var unreadCountString: String { self.unreadCount.stringValue }

  // MARK: class method

  /// returns model count from coredata
  ///
  /// - Returns: count
  class func count() -> Int {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
    let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = []
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
    var count = 0
    do {
      count = try context.count(for: fetchRequest)
    } catch {
      count = 0
    }
    return count
  }

  /// returns count of model by the rate
  ///
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - rate: rate star
  /// - Returns: count of model by the rate
  class func countOfTheRateInt(subsunreads: [LDRFeedSubsUnread], rate: Int) -> Int {
    subsunreads.filter { $0.rateValue == rate }.count
  }
    
  /// Returns filtered subsunread array by rate
  ///
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
  ///
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
  ///
  /// - Parameters:
  ///   - subsunreads: subsunread models
  ///   - folder: folder string
  /// - Returns: filtered subsunread models
  class func filter(subsunreads: [LDRFeedSubsUnread], folder: String) -> [LDRFeedSubsUnread] {
    subsunreads
      .filter { $0.folder == folder }
      .sorted { $0.title < $1.title }
  }

  /// returns rates of subsunread models
  ///
  /// - Parameter subsunreads: subsunread models
  /// - Returns: rates of subsunread models
  class func getRateInts(subsunreads: [LDRFeedSubsUnread]) -> [Int] {
    var rates: [Int] = []
    for subsunread in subsunreads {
      let rateValue = subsunread.rateValue
      if rates.contains(rateValue) { continue }
      rates.append(rateValue)
    }
    return rates
  }
    
  /// Returns Rate Strings from subsunread array
  /// - Parameter subsunreads:subsunread array
  /// - Returns: Rate Strings e.g. "★★★☆☆" when rate equals to 3
  class func getRates(subsunreads: [LDRFeedSubsUnread]) -> [String] {
    var rates: [String] = []
    for subsunread in subsunreads {
      let rateValue = subsunread.rateString
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
    folders.sort()
    return folders
  }

  /// fetch models from coredata
  ///
  /// - Parameter segment: search condition -> rate or folder
  /// - Returns: models from coredata
  class func fetch(segment: Segment) -> [LDRFeedSubsUnread] {
    let context = LDRCoreDataManager.shared.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
    let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = []
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    var sortDescriptor: NSSortDescriptor?
    if segment == .rate {
      sortDescriptor = NSSortDescriptor(key: #keyPath(LDRFeedSubsUnread.rate), ascending: false)
    } else if segment == .folder {
      sortDescriptor = NSSortDescriptor(key: #keyPath(LDRFeedSubsUnread.folder), ascending: true)
    }
    if let descriptor = sortDescriptor {
      fetchRequest.sortDescriptors = [descriptor]
    }
    fetchRequest.returnsObjectsAsFaults = false
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
  /// - Parameter response: LDRSubsResponse
  /// - Returns: error of saving the model or no error if succeeded
  class func save(response: LDRSubsResponse) -> Error? {
    let context = LDRCoreDataManager.shared.managedObjectContext
    for item in response {
      guard let model = NSEntityDescription.insertNewObject(
        forEntityName: "LDRFeedSubsUnread",
        into: context
      ) as? LDRFeedSubsUnread else {
        continue
      }
      model.subscribeId = "\(item.subscribeId)"
      model.rate = NSNumber(value: item.rate)
      model.folder = item.folder
      model.title = item.title
      model.link = item.link
      model.feedlink = item.feedlink
      model.icon = item.icon
      model.unreadCount = NSNumber(value: item.unreadCount)
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
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LDRFeedSubsUnread")
    let entity = NSEntityDescription.entity(forEntityName: "LDRFeedSubsUnread", in: context)
    fetchRequest.entity = entity
    fetchRequest.fetchBatchSize = 20
    let predicates: [NSPredicate] = []
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    fetchRequest.returnsObjectsAsFaults = false
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

// MARK: - LDRFeedSubsUnread + Identifiable
extension LDRFeedSubsUnread: Identifiable {
}
