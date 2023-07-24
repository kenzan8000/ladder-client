import Combine
import SwiftUI
import WebKit

// MARK: - WebViewStore
public class WebViewStore: ObservableObject {
    // MARK: property
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }
    private var observers: [NSKeyValueObservation] = []
    
    // MARK: initializer
    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        setupObservers()
    }
    
    // MARK: destruction
    deinit {
        observers.forEach {
            $0.invalidate()
        }
    }
    
    // MARK: private api
    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward)
        ]
    }
}

// MARK: - WebView
public struct WebView: View, UIViewRepresentable {
    // MARK: typealias
    public typealias UIViewType = UIViewContainerView<WKWebView>
    
    // MARK: property
    public let webView: WKWebView
    
    // MARK: initializer
    public init(webView: WKWebView) {
        self.webView = webView
    }
    
    // MARK: UIViewRepresentable
    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WebView.UIViewType {
        UIViewContainerView()
    }
    
    public func updateUIView(_ uiView: WebView.UIViewType, context: UIViewRepresentableContext<WebView>) {
        // If its the same content view we don't need to update.
        if uiView.contentView !== webView {
            uiView.contentView = webView
        }
    }

    public func makeCoordinator() -> WebView.Coordinator {
        Coordinator()
    }
}

// MARK: - UIViewContainerView<ContentView: UIView>
public class UIViewContainerView<ContentView: UIView>: UIView {
    // A UIView which simply adds some view to its view hierarchy
    var contentView: ContentView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView {
                addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
        }
    }
}
