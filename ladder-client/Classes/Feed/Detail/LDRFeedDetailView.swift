import Introspect
import SwiftUI

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
  // MARK: property

  @ObservedObject var feedDetailViewModel: LDRFeedDetailViewModel
  @ObservedObject var feedDetailWebViewModel: LDRFeedDetailWebViewModel
  @Environment(\.colorScheme) var colorScheme: ColorScheme
    
  var body: some View {
    VStack {
      header
      ZStack {
        WebView(webView: feedDetailWebViewModel.webView)
        if !feedDetailWebViewModel.doneInitialLoading {
          ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
      }
      footer
    }
    .navigationBarTitle(feedDetailViewModel.unread.title)
    .navigationBarItems(trailing: pinButton)
    .sheet(isPresented: feedDetailWebViewModel.isPresentingSafariView) {
      safariView
    }
    .onAppear {
      feedDetailWebViewModel.loadHTMLString(
        colorScheme: colorScheme,
        body: feedDetailViewModel.body,
        link: feedDetailViewModel.link
      )
    }
    .alert(isPresented: feedDetailViewModel.isPresentingAlert) {
      Alert(title: Text(feedDetailViewModel.error?.localizedDescription ?? ""))
    }
    .introspectViewController { viewController in
      viewController.tabBarController?.tabBar.isHidden = true
    }
  }

  var pinButton: some View {
    Button(
      action: {
        if feedDetailViewModel.savePin() {
          LDRToastView.show(
            on: UIApplication.shared.windows[0],
            text: "Added to Read Later Pins\n\(feedDetailViewModel.title)"
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
    
  var header: some View {
    Text(
      "【\(feedDetailViewModel.index + 1) / \(feedDetailViewModel.count)】 \(feedDetailViewModel.title)"
    )
    .lineLimit(2)
    .truncationMode(.tail)
    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
  }
    
  var footer: some View {
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
    
  var safariView: some View {
    guard let url = feedDetailWebViewModel.safariUrl else {
      return AnyView(EmptyView())
    }
    return AnyView(SafariView(url: url))
  }
  
  // MARK: public api
  
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
        if !feedDetailViewModel.move(offset: direction) {
          LDRBlinkView.show(
            on: UIApplication.shared.windows[0],
            color: UIColor.systemGray6.withAlphaComponent(0.5),
            count: 1,
            interval: 0.08
          )
        } else {
          feedDetailWebViewModel.loadHTMLString(
            colorScheme: colorScheme,
            body: feedDetailViewModel.body,
            link: feedDetailViewModel.link
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
 
}

// MARK: - LDRFeedDetailView_Previews
struct LDRFeedDetailView_Previews: PreviewProvider {
  static var previews: some View {
    LDRFeedDetailView(
      feedDetailViewModel: LDRFeedDetailViewModel(unread: LDRUnread(response: LDRUnreadResponse(subscribeId: 1, items: [], channel: .example))),
      feedDetailWebViewModel: LDRFeedDetailWebViewModel()
    )
  }
}
