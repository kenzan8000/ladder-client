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
  
  // MARK: class method
  
  /// save model
  /// - Parameters:
  ///   - storageProvider: for CoreData
  ///   - subsunread: parent model
  ///   - response: unread response
  class func save(storageProvider: LDRStorageProvider, subsunread: LDRFeedSubsUnread, response: LDRUnreadResponse) {
    for item in response.items {
      let model = LDRFeedUnread(context: storageProvider.viewContext)
      model.id = item.id
      model.body = item.body
      model.category = item.category
      model.link = item.link
      model.title = item.title
      model.subsunread = subsunread
    }
    do {
      try storageProvider.viewContext.save()
    } catch {
      storageProvider.viewContext.rollback()
    }
  }
  
}

extension LDRFeedUnread: Identifiable {
}
