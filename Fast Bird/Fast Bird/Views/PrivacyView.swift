//
//  PrivacyView.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import WebKit

enum PrivacyMode {
    case accept
    case view
}

struct PrivacyView: View {
    let mode: PrivacyMode
    let onAccept: () -> Void
    let onBack: (() -> Void)?
    
    @StateObject private var settings = SettingsManager.shared
    
    init(mode: PrivacyMode, onAccept: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.mode = mode
        self.onAccept = onAccept
        self.onBack = onBack
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // WebView
                WebViewRepresentable(urlString: "https://fastbirrd.com/privacy-policy.html")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea(.all)
                
                // Back button (if in view mode)
                if mode == .view, let onBack = onBack {
                    let buttonSize: CGFloat = 48.0 * (geometry.size.height / 896.0)
                    let leftMargin: CGFloat = 24.0 * (geometry.size.width / 414.0)
                    let topMargin: CGFloat = 48.0 * (geometry.size.height / 896.0)
                    
                    Button(action: onBack) {
                        if let backImage = ResourceManager.shared.uiImage(named: .arrowBack) {
                            Image(uiImage: backImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                    }
                    .position(
                        x: leftMargin + buttonSize / 2,
                        y: topMargin + buttonSize / 2 + geometry.safeAreaInsets.top
                    )
                }
                
                // Accept button (if in accept mode)
                if mode == .accept {
                    let buttonWidth = geometry.size.width * 0.4
                    let buttonHeight = buttonWidth * (159.0 / 468.0)
                    let bottomMargin: CGFloat = 24.0 * (geometry.size.height / 896.0)
                    
                    Button(action: {
                        settings.isPrivacyAccepted = true
                        onAccept()
                    }) {
                        if let approveImage = ResourceManager.shared.uiImage(named: .btnApprove) {
                            Image(uiImage: approveImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: buttonWidth, height: buttonHeight)
                        } else {
                            Text("ACCEPT")
                                .font(.custom("Bungee-Regular", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height - buttonHeight / 2 - bottomMargin - geometry.safeAreaInsets.bottom
                    )
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
    }
}

