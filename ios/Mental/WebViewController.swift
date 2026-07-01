import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    private var webView: WKWebView!

    // Match the app's deep space background
    private let bgColor = UIColor(red: 0.031, green: 0.043, blue: 0.071, alpha: 1.0) // #080b12

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure WKWebView
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        // Enable localStorage persistence (critical for progress saving)
        let dataStore = WKWebsiteDataStore.default()
        config.websiteDataStore = dataStore

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = bgColor
        webView.scrollView.backgroundColor = bgColor

        // Disable bouncing for more native feel
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false

        // Let the web content handle safe area itself
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(webView)
        view.backgroundColor = bgColor

        // Full screen constraints — edge to edge
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        loadWebApp()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Load the bundled web app

    private func loadWebApp() {
        guard let webappURL = Bundle.main.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "webapp"
        ) else {
            showError("Could not find webapp bundle")
            return
        }

        let webappDir = webappURL.deletingLastPathComponent()
        webView.loadFileURL(webappURL, allowingReadAccessTo: webappDir)
    }

    private func showError(_ message: String) {
        let label = UILabel()
        label.text = "⚠ \(message)"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Inject viewport-fit=cover for safe area handling and disable user scaling
        let script = """
        (function() {
            var meta = document.querySelector('meta[name=viewport]');
            if (meta) {
                meta.content = 'width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no, maximum-scale=1.0';
            }
            // Add safe area padding to body
            document.body.style.paddingTop = 'env(safe-area-inset-top)';
            document.body.style.paddingBottom = 'env(safe-area-inset-bottom)';
            document.body.style.boxSizing = 'border-box';
            // Prevent rubber-band scrolling
            document.body.style.overscrollBehavior = 'none';
            document.documentElement.style.overscrollBehavior = 'none';
        })();
        """
        webView.evaluateJavaScript(script)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Open external links (https/http) in Safari, keep local file navigation in-app
        if let url = navigationAction.request.url,
           (url.scheme == "https" || url.scheme == "http"),
           navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    // MARK: - WKUIDelegate

    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })
        present(alert, animated: true)
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        })
        present(alert, animated: true)
    }
}
