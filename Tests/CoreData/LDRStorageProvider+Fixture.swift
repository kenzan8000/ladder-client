import Foundation
@testable import ladder_client

// MARK: - LDRStorageProvider+Fixture
extension LDRStorageProvider {
  
  // MARK: static api
  
  static func fixture(
    name: String = LDR.coreData,
    group: String = LDR.group,
    storeType: StoreType = .inMemory
  ) -> LDRStorageProvider {
    LDRStorageProvider(name: name, group: group, storeType: storeType)
  }
  
  static func fixture(
    source: Bundle,
    name: String = LDR.coreData,
    group: String = LDR.testGroup
  ) -> LDRStorageProvider {
    LDRStorageProvider(source: source, name: name, group: group)
  }
}
