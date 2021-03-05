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
      return 0
    }
  }
  
  /// Fetches SubsUnread by LDRFeedSubsUnread.Segment
  /// - Parameter segment: LDRFeedSubsUnread.Segment
  /// - Returns: SubsUnread records beloging to the segment
  func fetchSubsUnreads(by segment: LDRFeedSubsUnread.Segment) -> [LDRFeedSubsUnread] {
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
      return []
    }
  }

  /// Saves SubsUnreads records by response
  /// - Parameter response: LDRSubsResponse
  /// - Returns: save error or nil
  func saveSubsUnreads(by response: LDRSubsResponse) -> Error? {
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
      return LDRError.saveModelsFailed
    }
    return nil
  }
  
  /// Delete SubsUnreads records
  /// - Returns: save error or nil
  func deleteSubsUnreads() -> Error? {
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
      return LDRError.deleteModelsFailed
    }
    return nil
  }
  
  /// Updates SubsUnreads#state column
  /// - Parameters:
  ///   - subsUnread: target SubsUnread record
  ///   - state: LDRFeedSubsUnread.State to update
  func updateSubsUnread(_ subsUnread: LDRFeedSubsUnread, state: LDRFeedSubsUnread.State) {
    subsUnread.state = state
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
    }
  }
}
