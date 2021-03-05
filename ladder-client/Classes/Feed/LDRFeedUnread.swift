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
  ///
  /// - Parameter response: LDRUnreadResponse
  /// - Returns: error of saving the model or no error if succeeded
  class func save(subsunread: LDRFeedSubsUnread, response: LDRUnreadResponse) {
    let context = LDRCoreDataManager.shared.managedObjectContext
    for item in response.items {
      let model = LDRFeedUnread(context: context)
      model.id = item.id
      model.body = item.body
      model.category = item.category
      model.link = item.link
      model.title = item.title
      model.subsunread = subsunread
    }
    do {
      try context.save()
    } catch {
      context.rollback()
    }
  }
  
}

extension LDRFeedUnread: Identifiable {
}
