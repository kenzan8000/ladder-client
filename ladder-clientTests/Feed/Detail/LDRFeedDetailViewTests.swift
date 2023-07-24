import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedDetailViewTests
class LDRFeedDetailViewTests: XCTestCase {
    
    // MARK: property
    var storageProvider: LDRStorageProvider!
    
    // MARK: life cycle
    
    override func setUpWithError() throws {
        storageProvider = .fixture(source: Bundle(for: type(of: LDRFeedDetailViewTests())))
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: test
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntry_shouldReturnProperFeedInfo() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        XCTAssertEqual(sut.subsunread.title, "はてなブックマーク - 人気エントリー - 総合")
        XCTAssertEqual(sut.count, 115)
    }
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntryAndIndexIs0_shouldNotBeAbleToReduceIndex() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        _ = sut.addIndex(-1)
        XCTAssertEqual(sut.index, 0)
    }
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntryAndIndexIs114_shouldNotBeAbleToAddIndex() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        _ = sut.addIndex(114)
        _ = sut.addIndex(1)
        XCTAssertEqual(sut.index, 114)
    }
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntryAndIndexIs0_shouldReturnProperContent() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        XCTAssertEqual(sut.index, 0)
        XCTAssertEqual(sut.title, "もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter")
        XCTAssertEqual(sut.prevTitle, "")
        XCTAssertEqual(sut.nextTitle, "東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース")
        XCTAssertEqual(sut.link, try XCTUnwrap(URL(string: "https://togetter.com/li/1678345")))
        XCTAssertEqual(sut.body, "<blockquote title=\"もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter\">\n<img src=\"https://cdn-ak2.favicon.st-hatena.com/?url=https%3A%2F%2Ftogetter.com%2Fli%2F1678345\" alt=\"\"> <a href=\"https://togetter.com/li/1678345\">もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter</a><p><a href=\"https://togetter.com/li/1678345\"><img src=\"https://cdn-ak-scissors.b.st-hatena.com/image/square/71f103cac00ec8a8acff780a391e5ce8494c9dd9/height=90;version=1;width=120/https%3A%2F%2Fs.togetter.com%2Fogp%2Fd32504c1832836c8c387687f2478724d-1200x630.png\" alt=\"もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter\" title=\"もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter\"></a></p>\n<p>「フェミニストの声」として以下を引用してますが、なんと引用元が示されていないのです。 \"・気持ち悪い ・マー君も夢中とか取り上げるな！ ・日本人の男性の感情は狂っているのか ・見た瞬間嫌な気持ちになった 続きを読む</p>\n<p><a href=\"https://b.hatena.ne.jp/entry/s/togetter.com/li/1678345\"><img src=\"https://b.hatena.ne.jp/entry/image/https://togetter.com/li/1678345\" alt=\"はてなブックマーク - もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter\" title=\"はてなブックマーク - もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter\" border=\"0\"></a> <a href=\"https://b.hatena.ne.jp/entry/s/togetter.com/li/1678345\"><img src=\"https://b.st-hatena.com/images/append.gif\" border=\"0\" alt=\"はてなブックマークに追加\" title=\"はてなブックマークに追加\"></a></p>\n</blockquote><img src=\"http://feeds.feedburner.com/~r/hatena/b/hotentry/~4/_q4-pxdmcok\" height=\"1\" width=\"1\" alt=\"\">")
    }
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntryAndIndexIs1_shouldReturnProperContent() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        _ = sut.addIndex(1)
        XCTAssertEqual(sut.index, 1)
        XCTAssertEqual(sut.title, "東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース")
        XCTAssertEqual(sut.prevTitle, "もしかしてエア炎上？／『馬を女体化した美少女ゲー「ウマ娘」が、女性軽視とフェミ女性から批判殺到、大炎上』と秒刊サンデー、しかし「フェミニスト」の意見とされるものにソース提示なし - Togetter")
        XCTAssertEqual(sut.nextTitle, "住民女性「町が壊れた」返礼品バブル霧散…寄付３９億円一転、廃業続々（読売新聞オンライン） - Yahoo!ニュース")
        XCTAssertEqual(sut.link, try XCTUnwrap(URL(string: "https://www3.nhk.or.jp/news/html/20210307/k10012902141000.html")))
        XCTAssertEqual(sut.body, "<blockquote title=\"東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース\">\n<img src=\"https://cdn-ak2.favicon.st-hatena.com/?url=https%3A%2F%2Fwww3.nhk.or.jp%2Fnews%2Fhtml%2F20210307%2Fk10012902141000.html\" alt=\"\"> <a href=\"https://www3.nhk.or.jp/news/html/20210307/k10012902141000.html\">東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース</a><p><a href=\"https://www3.nhk.or.jp/news/html/20210307/k10012902141000.html\"><img src=\"https://cdn-ak-scissors.b.st-hatena.com/image/square/e17647234411ce8fbb4954997700490e036bb5f9/height=90;version=1;width=120/https%3A%2F%2Fwww3.nhk.or.jp%2Fnews%2Fhtml%2F20210307%2FK10012902141_2103071502_2103071503_01_02.jpg\" alt=\"東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース\" title=\"東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース\"></a></p>\n<p>東京都は、7日午後3時時点の速報値で都内で新たに237人が新型コロナウイルスに感染していることを確認したと発表しました。</p>\n<p><a href=\"https://b.hatena.ne.jp/entry/s/www3.nhk.or.jp/news/html/20210307/k10012902141000.html\"><img src=\"https://b.hatena.ne.jp/entry/image/https://www3.nhk.or.jp/news/html/20210307/k10012902141000.html\" alt=\"はてなブックマーク - 東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース\" title=\"はてなブックマーク - 東京都 新型コロナ 新たに237人感染確認 | 新型コロナ 国内感染者数 | NHKニュース\" border=\"0\"></a> <a href=\"https://b.hatena.ne.jp/entry/s/www3.nhk.or.jp/news/html/20210307/k10012902141000.html\"><img src=\"https://b.st-hatena.com/images/append.gif\" border=\"0\" alt=\"はてなブックマークに追加\" title=\"はてなブックマークに追加\"></a></p>\n</blockquote><img src=\"http://feeds.feedburner.com/~r/hatena/b/hotentry/~4/zJYGcT1-NYo\" height=\"1\" width=\"1\" alt=\"\">")
    }
    
    func testLDRFeedDetailView_whenSubsunreadIsHatebuHotEntryAndIndexIs114_shouldReturnProperContent() throws {
        let subsunread = try XCTUnwrap(storageProvider.fetchSubsUnreads(by: .folder)[3])
        let sut = LDRFeedDetailView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub(), subsunread: subsunread)
        _ = sut.addIndex(114)
        XCTAssertEqual(sut.index, 114)
        XCTAssertEqual(sut.title, "ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE")
        XCTAssertEqual(sut.prevTitle, "プラスチック新法案まとまる　スプーン有料化も検討（テレビ朝日系（ANN）） - Yahoo!ニュース")
        XCTAssertEqual(sut.nextTitle, "")
        XCTAssertEqual(sut.link, try XCTUnwrap(URL(string: "https://gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/")))
        XCTAssertEqual(sut.body, "<blockquote title=\"ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE\">\n<img src=\"https://cdn-ak2.favicon.st-hatena.com/?url=https%3A%2F%2Fgigazine.net%2Fnews%2F20210309-bill-gates-say-bitcoin-is-bad%2F\" alt=\"\"> <a href=\"https://gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/\">ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE</a><p><a href=\"https://gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/\"><img src=\"https://cdn-ak-scissors.b.st-hatena.com/image/square/badb3f0d2293694970d22f94dbc28233ecdb2bbc/height=90;version=1;width=120/https%3A%2F%2Fi.gzn.jp%2Fimg%2F2021%2F03%2F09%2Fbill-gates-say-bitcoin-is-bad%2F00.jpg\" alt=\"ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE\" title=\"ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE\"></a></p>\n<p>by Sam Churchill ビル・ゲイツ氏がビットコインのマイニングには多大な電力が必要であるという点に触れて、「気候的に良いとは言えない」と発言しました。 Bill Gates Says that Bitcoin is bad For the Planet https://www.technologyelevation.com/2021/03/bill-gates-says-that-bitcoin-is-bad-for.html Microsoftの...</p>\n<p><a href=\"https://b.hatena.ne.jp/entry/s/gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/\"><img src=\"https://b.hatena.ne.jp/entry/image/https://gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/\" alt=\"はてなブックマーク - ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE\" title=\"はてなブックマーク - ビル・ゲイツが「ビットコインは地球に悪影響」と発言 - GIGAZINE\" border=\"0\"></a> <a href=\"https://b.hatena.ne.jp/entry/s/gigazine.net/news/20210309-bill-gates-say-bitcoin-is-bad/\"><img src=\"https://b.st-hatena.com/images/append.gif\" border=\"0\" alt=\"はてなブックマークに追加\" title=\"はてなブックマークに追加\"></a></p>\n</blockquote><img src=\"http://feeds.feedburner.com/~r/hatena/b/hotentry/~4/UI9CHvj6ZyM\" height=\"1\" width=\"1\" alt=\"\">")
    }
}
