//  ARQuickLookView.swift
//  Drop the spot / storefront into the real world with AR Quick Look.

import SwiftUI
import QuickLook
import ARKit

struct ARQuickLookView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UINavigationController {
        let ql = QLPreviewController()
        ql.dataSource = context.coordinator
        return UINavigationController(rootViewController: ql)
    }
    func updateUIViewController(_ vc: UINavigationController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(url: url) }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL
        init(url: URL) { self.url = url }
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            let item = ARQuickLookPreviewItem(fileAt: url)
            item.allowsContentScaling = true
            return item
        }
    }
}
