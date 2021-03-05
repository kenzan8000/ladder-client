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
}

// MARK: - LDRPin + Identifiable
extension LDRPin: Identifiable {
}

// MARK: - LDRStorageProvider + LDRPin
extension LDRStorageProvider {
  
  // MARK: public api
  
  /// Returns number of pin records
  /// - Returns: number of pins Int
  func countPins() -> Int {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try viewContext.count(for: fetchRequest)
    } catch {
      return 0
    }
  }
    
  /// Fetches pin records
  /// - Returns: models
  func fetchPins() -> [LDRPin] {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LDRPin.createdOn, ascending: false)]
    do {
      return try viewContext.fetch(fetchRequest)
    } catch {
      return []
    }
  }
    
  /// Returns if pin record already exists
  /// - Parameters:
  ///   - link: pin's link url string
  /// - Returns: Bool if existing or not
  func existPin(link: String) -> Bool {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "(%K = %@)", #keyPath(LDRPin.link), link)])
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try viewContext.count(for: fetchRequest) > 0
    } catch {
      return false
    }
  }
    
  /// Saves a pin by a client action
  /// - Parameters:
  ///   - title: pin's title
  ///   - link: pin's url string
  func savePin(title: String, link: String) {
    let model = LDRPin(context: viewContext)
    model.title = title
    model.link = link
    model.createdOn = Int(Date().timeIntervalSince1970)
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
    }
  }

  /// Save pins by response
  /// - Parameters:
  ///   - response: LDRPinAllResponse
  /// - Returns: Error occuring when saving pin records or nil
  func savePins(by response: LDRPinAllResponse) -> Error? {
    response.forEach {
      let model = LDRPin(context: viewContext)
      model.title = $0.title
      model.link = $0.link
      model.createdOn = $0.createdOn
    }
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
      return LDRError.saveModelsFailed
    }
    return nil
  }

  /// Delete pin records
  /// - Parameters:
  ///   - predicate: condition to search pins to delete
  /// - Returns: Error occuring when deleting pin records or nil
  func deletePins(by predicate: NSPredicate?) -> Error? {
    let fetchRequest: NSFetchRequest<LDRPin> = LDRPin.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    fetchRequest.returnsObjectsAsFaults = false
    if let predicate = predicate {
      fetchRequest.predicate = predicate
    }
    var models = [LDRPin]()
    do {
      models = try viewContext.fetch(fetchRequest)
    } catch {
      return LDRError.deleteModelsFailed
    }
    models.forEach { viewContext.delete($0) }
    do {
      try viewContext.save()
    } catch {
      viewContext.rollback()
      return LDRError.deleteModelsFailed
    }
    return nil
  }
  
  /// Delete pin records
  /// - Returns: Error occuring when deleting pin records or nil
  func deletePins() -> Error? {
    deletePins(by: nil)
  }

  /// Delete a pin record
  /// - Parameters:
  ///   - pin: pin to delete
  /// - Returns: Error occuring when deleting a pin record or nil
  func deletePin(_ pin: LDRPin) -> Error? {
    deletePins(
      by: NSPredicate(format: "(%K = %@)", #keyPath(LDRPin.link), pin.link)
    )
  }
}
