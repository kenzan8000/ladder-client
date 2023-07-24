import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedViewTests
class LDRFeedViewTests: XCTestCase {
    
    // MARK: property
    var storageProvider: LDRStorageProvider!
    
    // MARK: life cycle
    
    override func setUpWithError() throws {
        storageProvider = .fixture(source: Bundle(for: type(of: LDRFeedViewTests())))
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: test
 
    func testLDRFeedView_whenSegmentIsFolder_segmentShouldBeFolder() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .folder)
        XCTAssertEqual(sut.segment, .folder)
    }
    
    func testLDRFeedView_whenSegmentIsRate_segmentShouldBeRate() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .rate)
        XCTAssertEqual(sut.segment, .rate)
    }
    
    func testLDRFeedView_whenSegmentIsFolder_sectionsShouldBeEqualToFolders() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .folder)
        let folders = ["company", "feed", "friend", "fun", "gadget", "software engineer", "software engineering"]
        XCTAssertEqual(sut.sections, folders)
        XCTAssertEqual(sut.sections, sut.folders)
    }
    
    func testLDRFeedView_whenSegmentIsRate_sectionsShouldBeEqualToRates() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .rate)
        let rates = ["★★★★☆", "★★★☆☆", "★★☆☆☆"]
        XCTAssertEqual(sut.sections, rates)
        XCTAssertEqual(sut.sections, sut.rates)
    }
    
    func testLDRFeedView_whenInitialState_unreadCountShoudBeEqualTo343() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .folder)
        XCTAssertEqual(sut.unreadCount, 343)
    }
    
    func testLDRFeedView_whenSegmentIsFolderAndSectionIsCompany_titlesShoudBeFollowing() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .folder)
        let section = "company"
        let subsunreads = sut.getSubsUnreads(at: section)
        XCTAssertEqual(subsunreads.map { $0.title }, ["Netflix TechBlog - Medium", "Twilio Blog", "Uber Engineering Blog"])
    }
    
    func testLDRFeedView_whenSegmentIsRateAndSectionIs4stars_titlesShouldBeFollowing() throws {
        let sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), segment: .rate)
        let section = "★★★★☆"
        let subsunreads = sut.getSubsUnreads(at: section)
        XCTAssertEqual(subsunreads.map { $0.title }, ["alextsui05’s Activity", "efclのはてなブックマーク", "eugeneotto’s Activity", "type:show score&gt;10 &amp;#8211; hnapp", "歴ログ -世界史専門ブログ-"])
    }
    
    func testLDRFeedView_whenSegmentIsInitializedByKeychain_segmentShouldBeSameWithKeychain() throws {
        let keychain = LDRKeychainStub()
        var segment: LDRFeedSubsUnreadSegment
        var sut: LDRFeedView.ViewModel
        
        segment = .rate
        keychain.feedSubsUnreadSegmentString = "\(segment.rawValue)"
        sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: try XCTUnwrap(keychain.feedSubsUnreadSegmentString?.feedSubsUnreadSegmentValue))
        XCTAssertEqual(sut.segment, segment)
        
        segment = .folder
        keychain.feedSubsUnreadSegmentString = "\(segment.rawValue)"
        sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: try XCTUnwrap(keychain.feedSubsUnreadSegmentString?.feedSubsUnreadSegmentValue))
        XCTAssertEqual(sut.segment, segment)
    }
    
    func testLDRFeedView_whenSegmentValueIsUpdated_keychainValueShouldAlsoBeUpdated() throws {
        let keychain = LDRKeychainStub()
        var sut: LDRFeedView.ViewModel
        
        sut = LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate)
        
        sut.segment = .folder
        XCTAssertEqual(keychain.feedSubsUnreadSegmentString, "\(sut.segment.rawValue)")
        
        sut.segment = .rate
        XCTAssertEqual(keychain.feedSubsUnreadSegmentString, "\(sut.segment.rawValue)")
    }
    
}
