import Introspect
import SwiftUI

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
    // MARK: - property

    @ObservedObject var feedDetailViewModel: LDRFeedDetailViewModel
    @ObservedObject var feedDetailWebViewModel: LDRFeedDetailWebViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // MARK: - view

    var body: some View {
        VStack {
            header()
            ZStack {
                WebView(webView: feedDetailWebViewModel.webView)
                if !feedDetailWebViewModel.doneInitialLoading {
                    ActivityIndicator(
                        isAnimating: .constant(true),
                        style: .large
                    )
                }
            }
            footer()
        }
        .navigationBarTitle(feedDetailViewModel.unread.title)
        .navigationBarItems(
            trailing: pinButton()
        )
        .sheet(isPresented: feedDetailWebViewModel.isPresentingSafariView) {
            self.safariView()
        }
        .onAppear {
            self.feedDetailWebViewModel.loadHTMLString(
                colorScheme: self.colorScheme,
                body: self.feedDetailViewModel.body,
                link: self.feedDetailViewModel.link
            )
        }
        .introspectViewController { viewController in
            viewController.tabBarController?.tabBar.isHidden = true
        }
    }

    func pinButton() -> some View {
        Button(
            action: {
                if self.feedDetailViewModel.savePin() {
                    LDRToastView.show(
                        on: UIApplication.shared.windows[0],
                        text: "Added to Read Later Pins\n\(self.feedDetailViewModel.title)"
                    )
                }
            },
            label: {
                Text("Pin it")
                .foregroundColor(.blue)
                Image(systemName: "pin.fill")
                .foregroundColor(.blue)
            }
        )
    }
    
    func header() -> some View {
        Text(
            "【\(feedDetailViewModel.index + 1) / \(feedDetailViewModel.count)】 \(feedDetailViewModel.title)"
        )
        .lineLimit(2)
        .truncationMode(.tail)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
    }
    
    func footer() -> some View {
        VStack {
            HStack {
                nextText(direction: -1)
                nextText(direction: 1)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            HStack {
                moveButton(direction: -1)
                moveButton(direction: 1)
            }
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 24, trailing: 0))
        }
    }
    
    func nextText(direction: Int) -> some View {
        var text = direction < 0 ? feedDetailViewModel.prevTitle : feedDetailViewModel.nextTitle
        if !text.isEmpty {
            text = "【\(feedDetailViewModel.index + 1 + direction)】 " + text
        }
        return Text(text)
        .lineLimit(2)
        .truncationMode(.tail)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
    
    func moveButton(direction: Int) -> some View {
        var color = Color.blue
        var opacity = 1.0
        if feedDetailViewModel.index + direction < 0 || feedDetailViewModel.index + direction >= feedDetailViewModel.count {
            color = Color.blue
            opacity = 0.5
        }
        return Button(
            action: {
                if !self.feedDetailViewModel.move(offset: direction) {
                    LDRBlinkView.show(
                        on: UIApplication.shared.windows[0],
                        color: UIColor.systemGray6.withAlphaComponent(0.5),
                        count: 1,
                        interval: 0.08
                    )
                } else {
                    self.feedDetailWebViewModel.loadHTMLString(
                        colorScheme: self.colorScheme,
                        body: self.feedDetailViewModel.body,
                        link: self.feedDetailViewModel.link
                    )
                }
            },
            label: {
                Image(systemName: direction == -1 ? "chevron.left" : "chevron.right")
                .font(.title)
                .foregroundColor(color)
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        .opacity(opacity)
    }
    
    func safariView() -> some View {
        guard let url = self.feedDetailWebViewModel.safariUrl else {
            return AnyView(EmptyView())
        }
        return AnyView(SafariView(url: url))
    }
}

// MARK: - LDRFeedDetailView_Previews
struct LDRFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedDetailView(
            feedDetailViewModel: LDRFeedDetailViewModel(unread: LDRFeedUnread(subscribeId: "1", title: "Title")),
            feedDetailWebViewModel: LDRFeedDetailWebViewModel()
        )
    }
}
