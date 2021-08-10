import SwiftUI

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
  // MARK: property

  @ObservedObject var viewModel: ViewModel
  @ObservedObject var webViewModel: WebViewModel
  @Environment(\.colorScheme) var colorScheme: ColorScheme
    
  var body: some View {
    VStack {
      header
      ZStack {
        WebView(webView: webViewModel.webView)
        if !webViewModel.doneInitialLoading {
          ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
      }
      footer
    }
    .navigationBarTitle(viewModel.subsunread.title)
    .navigationBarItems(trailing: pinButton)
    .sheet(isPresented: webViewModel.isPresentingSafariView) {
      safariView
    }
    .onAppear {
      webViewModel.loadHTMLString(
        colorScheme: colorScheme,
        body: viewModel.body,
        link: viewModel.link
      )
    }
    .alert(isPresented: viewModel.isPresentingAlert) {
      Alert(title: Text(viewModel.error?.legibleDescription ?? ""))
    }
  }

  var pinButton: some View {
    Button(
      action: {
        viewModel.savePin()
        LDRToastView.show(
          on: UIApplication.shared.windows[0],
          text: "Added to Read Later Pins\n\(viewModel.title)"
        )
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
      "【\(viewModel.index + 1) / \(viewModel.count)】 \(viewModel.title)"
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
    guard let url = webViewModel.safariUrl else {
      return AnyView(EmptyView())
    }
    return AnyView(SafariView(url: url))
  }
  
  // MARK: public api
  
  func nextText(direction: Int) -> some View {
    var text = direction < 0 ? viewModel.prevTitle : viewModel.nextTitle
    if !text.isEmpty {
      text = "【\(viewModel.index + 1 + direction)】 " + text
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
    if viewModel.index + direction < 0 || viewModel.index + direction >= viewModel.count {
      color = Color.blue
      opacity = 0.5
    }
    return Button(
      action: {
        if !viewModel.move(offset: direction) {
          LDRBlinkView.show(
            on: UIApplication.shared.windows[0],
            color: UIColor.systemGray6.withAlphaComponent(0.5),
            count: 1,
            interval: 0.08
          )
        } else {
          webViewModel.loadHTMLString(
            colorScheme: colorScheme,
            body: viewModel.body,
            link: viewModel.link
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
    let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      LDRFeedDetailView(
        viewModel: LDRFeedDetailView.ViewModel(storageProvider: LDRStorageProvider(name: LDR.coreData, group: LDR.group), keychain: keychain, subsunread: LDRFeedSubsUnread(context: .init(concurrencyType: .mainQueueConcurrencyType))),
        webViewModel: LDRFeedDetailView.WebViewModel()
      )
      .colorScheme($0)
    }
  }
}
