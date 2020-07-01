import Introspect
import SwiftUI

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
    
    @ObservedObject var feedDetailViewModel: LDRFeedDetailViewModel
    @ObservedObject var feedDetailWebViewModel: LDRFeedDetailWebViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            header()
            WebView(webView: feedDetailWebViewModel.webView)
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
                .foregroundColor(Color.blue)
                Image(uiImage: IonIcons.image(
                    withIcon: ion_pin,
                    iconColor: UIColor.systemBlue,
                    iconSize: 32,
                    imageSize: CGSize(width: 32, height: 32)
                ))
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
        .foregroundColor(Color.blue)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
    
    func moveButton(direction: Int) -> some View {
        let icon = [-1: ion_chevron_left, 1: ion_chevron_right]
        var color = UIColor.blue
        var opacity = 1.0
        if feedDetailViewModel.index + direction < 0 || feedDetailViewModel.index + direction >= feedDetailViewModel.count {
            color = UIColor.systemBlue
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
                Image(uiImage: IonIcons.image(
                        withIcon: icon[direction],
                        iconColor: color,
                        iconSize: 36,
                        imageSize: CGSize(width: 36, height: 36)
                    )
                )
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
