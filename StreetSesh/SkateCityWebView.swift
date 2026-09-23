import SwiftUI
import WebKit

// MARK: - SwiftUI wrapper

#if os(iOS)
struct SkateCityGameView: View {
    let username: String
    let skinHex: String
    let hoodieHex: String
    let deckHex: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            SkateCityWebViewRepresentable(
                username: username,
                skinHex: skinHex,
                hoodieHex: hoodieHex,
                deckHex: deckHex
            )
            .ignoresSafeArea()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Color.black.opacity(0.55))
                    .clipShape(Circle())
            }
            .padding(.top, 56)
            .padding(.leading, 16)
        }
        .statusBarHidden(true)
    }
}

// MARK: - WKWebView representable (iOS only)

struct SkateCityWebViewRepresentable: UIViewRepresentable {
    let username: String
    let skinHex: String
    let hoodieHex: String
    let deckHex: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.preferences.isElementFullscreenEnabled = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isOpaque = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let htmlURL = Bundle.main.url(
            forResource: "skatecity",
            withExtension: "html",
            subdirectory: "SkateCity"
        ) else { return }
        // Only load once — loadFileURL triggers updateUIView again
        guard webView.url == nil else { return }
        let gameDir = htmlURL.deletingLastPathComponent()
        var comps = URLComponents(url: htmlURL, resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "username", value: username.isEmpty ? "skater" : username),
            URLQueryItem(name: "skin",     value: skinHex),
            URLQueryItem(name: "hoodie",   value: hoodieHex),
            URLQueryItem(name: "deck",     value: deckHex)
        ]
        webView.loadFileURL(comps.url ?? htmlURL, allowingReadAccessTo: gameDir)
    }
}
#endif
