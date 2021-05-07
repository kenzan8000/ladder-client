import CoreData

// MARK: enum
enum LDRFeedSubsUnreadSegment {
  case rate
  case folder
}

@objc
enum LDRFeedSubsUnreadState: Int64 {
  case unloaded = 0
  case unread = 1
  case read = 2
}

// MARK: - LDRFeedSubsUnread
class LDRFeedSubsUnread: NSManagedObject {
  // MARK: property
  @NSManaged var subscribeId: Int
  @NSManaged var rate: Int
  @NSManaged var folder: String
  @NSManaged var title: String
  @NSManaged var link: String
  @NSManaged var feedlink: String
  @NSManaged var icon: String
  @NSManaged var unreadCount: Int
  @NSManaged var state: LDRFeedSubsUnreadState
  
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
}

// MARK: - LDRFeedSubsUnread + Identifiable
extension LDRFeedSubsUnread: Identifiable {
}

// MARK: - LDRStorageProvider + LDRFeedSubsUnread
extension LDRStorageProvider {
  // MARK: public api
  
  /// Counts number of SubsUnread records
  /// - Returns: number of SubsUnread records Int
  func countSubsUnreads() -> Int {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try viewContext.count(for: fetchRequest)
    } catch {
      logger.error("\(logger.prefix(), privacy: .private)\(fetchRequest.debugDescription, privacy: .private)")
      return 0
    }
  }
  
  /// Fetches SubsUnread by LDRFeedSubsUnread.Segment
  /// - Parameter segment: LDRFeedSubsUnread.Segment
  /// - Returns: SubsUnread records beloging to the segment
  func fetchSubsUnreads(by segment: LDRFeedSubsUnreadSegment) -> [LDRFeedSubsUnread] {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.sortDescriptors = [NSSortDescriptor]()
    switch segment {
    case .rate:
      fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: \LDRFeedSubsUnread.rate, ascending: false))
    case .folder:
      fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: \LDRFeedSubsUnread.folder, ascending: true))
    }
    do {
      return try viewContext.fetch(fetchRequest)
    } catch {
      logger.error("\(logger.prefix(), privacy: .private)\(fetchRequest.debugDescription, privacy: .private)")
      return []
    }
  }

  /// Saves SubsUnreads records by response
  /// - Parameter response: LDRSubsResponse
  /// - Returns: save error or nil
  func saveSubsUnreads(by response: LDRSubsResponse) -> LDRError? {
    for item in response {
      let model = LDRFeedSubsUnread(context: viewContext)
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
      try viewContext.save()
    } catch {
      viewContext.rollback()
      logger.error("\(logger.prefix(), privacy: .private)\(LDRError.saveModel.legibleDescription, privacy: .private)")
      return LDRError.saveModel
    }
    return nil
  }
  
  /// Delete SubsUnreads records
  /// - Returns: save error or nil
  func deleteSubsUnreads() -> LDRError? {
    let fetchRequest: NSFetchRequest<LDRFeedSubsUnread> = LDRFeedSubsUnread.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    var models = [LDRFeedSubsUnread]()
    do {
      models = try viewContext.fetch(fetchRequest)
    } catch {
      models = []
    }
    do {
      models.forEach { viewContext.delete($0) }
      try viewContext.save()
    } catch {
      viewContext.rollback()
      logger.error("\(logger.prefix(), privacy: .private)\(LDRError.deleteModel.legibleDescription, privacy: .private)")
      return LDRError.deleteModel
    }
    return nil
  }
  
  /// Updates SubsUnreads#state column
  /// - Parameters:
  ///   - subsUnread: target SubsUnread record
  ///   - state: LDRFeedSubsUnread.State to update
  func updateSubsUnread(_ subsUnread: LDRFeedSubsUnread, state: LDRFeedSubsUnreadState) {
    subsUnread.state = state
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
      logger.error("\(logger.prefix(), privacy: .private)\(LDRError.saveModel.legibleDescription, privacy: .private)")
    }
  }
}
