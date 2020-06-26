import KSToastView
import SwiftUI
import WebKit

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
    
    @ObservedObject var feedDetailViewModel: LDRFeedDetailViewModel
    
    var body: some View {
        VStack {
            header()
            
            WebView(webView: WKWebView())
            
            footer()
        }
        .navigationBarTitle(feedDetailViewModel.unread.title)
        .navigationBarItems(
            trailing: pinButton()
        )
    }

    func pinButton() -> some View {
        Button(
            action: {
                if self.feedDetailViewModel.savePin() {
                    KSToastView.ks_showToast(
                        "Added a pin\n\(self.feedDetailViewModel.title)",
                        duration: 2.0
                    )
                }
            },
            label: {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_pin,
                    iconColor: UIColor.systemGray,
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
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 24, trailing: 12))
    }
    
    func footer() -> some View {
        VStack {
            HStack {
                nextText(direction: -1)
                nextText(direction: 1)
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
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
        let icon = [-1: ion_chevron_left, 1: ion_chevron_right]
        return Button(
            action: {
                if !self.feedDetailViewModel.move(offset: direction) {
                    LDRBlinkView.show(
                        on: UIApplication.shared.windows[0],
                        color: UIColor.systemGray6.withAlphaComponent(0.5),
                        count: 1,
                        interval: 0.08
                    )
                }
            },
            label: {
                Image(uiImage: IonIcons.image(
                        withIcon: icon[direction],
                        iconColor: UIColor.label,
                        iconSize: 36,
                        imageSize: CGSize(width: 36, height: 36)
                    )
                )
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
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
