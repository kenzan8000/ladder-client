import SwiftUI
import WebKit

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
    
    @ObservedObject var feedDetailViewModel: LDRFeedDetailViewModel
    
    var body: some View {
        VStack {
            WebView(webView: WKWebView())
        }
        .navigationBarTitle(feedDetailViewModel.unread.title)
        .navigationBarItems(
            trailing: Text("Hoge")
        )
    }

}

// MARK: - LDRFeedDetailView_Previews
struct LDRFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedDetailView(
            feedDetailViewModel: LDRFeedDetailViewModel(unread: LDRFeedUnread(subscribeId: "1", title: "Title"))
        )
    }
}
