import SwiftUI

extension View {
    /// Cross-platform wrapper for navigationBarTitleDisplayMode(.inline)
    func inlineNavBar() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
