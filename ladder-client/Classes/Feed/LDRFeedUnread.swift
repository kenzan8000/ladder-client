import CoreData

// MARK: - LDRFeedUnread
class LDRFeedUnread: NSManagedObject {
  // MARK: property
  @NSManaged var id: Int
  @NSManaged var category: String
  @NSManaged var title: String
  @NSManaged var body: String
  @NSManaged var link: String
  
  @NSManaged var subsunread: LDRFeedSubsUnread
  
  var linkUrl: URL {
    URL(string: link) ?? URL(fileURLWithPath: "")
  }
  
}

// MARK: - LDRFeedUnread + Identifiable
extension LDRFeedUnread: Identifiable {
}

// MARK: - LDRStorageProvider + LDRFeedUnread
extension LDRStorageProvider {
  // MARK: public api
  
  /// Saves a unread record
  /// - Parameters:
  ///   - response: unread response
  ///   - subsUnread: parent model
  func saveUnread(by response: LDRUnreadResponse, subsUnread: LDRFeedSubsUnread) {
    response.items.forEach {
      let model = LDRFeedUnread(context: viewContext)
      model.id = $0.id
      model.body = $0.body
      model.category = $0.category
      model.link = $0.link
      model.title = $0.title
      model.subsunread = subsUnread
    }
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
      logger.error("\(logger.prefix(self, #function), privacy: .private)\(LDRError.saveModel.legibleDescription, privacy: .private)")
    }
  }
 
}
