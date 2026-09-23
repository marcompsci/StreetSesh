import SwiftUI
import SwiftData

// MARK: - Root SkateCity Container

struct SkateCityView: View {
    @Query private var users: [AppUser]
    @StateObject private var appState  = SkateCityAppState()
    @State private var showShopEntry  = false
    @AppStorage("sk_shopEntryShown") private var shopEntryShown = false

    var body: some View {
        TabView {
            SkateCityHomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            SkateCityExploreView()
                .tabItem { Label("Explore", systemImage: "map.fill") }

            SkateCitySessionsView()
                .tabItem { Label("Sessions", systemImage: "person.3.fill") }

            SkateCityProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.skLime)
        #if os(iOS)
        .toolbarBackground(Color.skDark, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        #endif
        .environmentObject(appState)
        .onAppear {
            if let user = users.first, !appState.hasSynced {
                appState.syncFromAppUser(user)
            }
            if !shopEntryShown {
                shopEntryShown = true
                showShopEntry = true
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showShopEntry) {
            SKShopEntryView(shop: SKMockData.shops[0])
        }
        #endif
    }
}

// MARK: - Shop Entry Screen (first-launch experience)

struct SKShopEntryView: View {
    let shop: SkateShop
    @Environment(\.dismiss) private var dismiss
    @State private var appeared  = false
    @State private var countdown = 3

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Storefront illustration
                storefrontIllustration
                    .scaleEffect(appeared ? 1 : 0.82)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75), value: appeared)

                Spacer().frame(height: 32)

                // Shop info
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeIn(duration: 0.4).delay(0.3), value: appeared)

                    Text(shop.name)
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(Color(hex: shop.accentColorHex))
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.45), value: appeared)

                    Text(shop.neighborhood)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeIn(duration: 0.4).delay(0.55), value: appeared)
                }

                Spacer().frame(height: 40)

                // CTA
                Button {
                    dismiss()
                } label: {
                    Text("Step Inside")
                        .font(.system(size: 17, weight: .black))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: shop.accentColorHex))
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.7), value: appeared)

                Spacer().frame(height: 20)

                Text("Auto-entering in \(countdown)s")
                    .font(.caption)
                    .foregroundStyle(.gray.opacity(0.6))

                Spacer(minLength: 40)
            }
        }
        .onAppear {
            appeared = true
            // Auto-dismiss countdown
            Task {
                for i in stride(from: 3, through: 1, by: -1) {
                    try? await Task.sleep(for: .seconds(1))
                    countdown = i - 1
                }
                dismiss()
            }
        }
    }

    // MARK: - Storefront Illustration

    private var storefrontIllustration: some View {
        let accent = Color(hex: shop.accentColorHex)
        return ZStack(alignment: .bottom) {
            // Building wall
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#1A1A1A"))
                .frame(width: 220, height: 160)

            // Sign above door
            RoundedRectangle(cornerRadius: 6)
                .fill(accent.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 6).stroke(accent.opacity(0.4), lineWidth: 1)
                )
                .frame(width: 160, height: 28)
                .overlay(
                    Text(shop.name.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(accent)
                )
                .offset(y: -112)

            // Window (left)
            windowShape(accent: accent)
                .offset(x: -60, y: -50)

            // Window (right)
            windowShape(accent: accent)
                .offset(x: 60, y: -50)

            // Door
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#282828"))
                .frame(width: 44, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(accent.opacity(0.35), lineWidth: 1)
                )
                .overlay(
                    Circle()
                        .fill(accent.opacity(0.8))
                        .frame(width: 5, height: 5)
                        .offset(x: 12),
                    alignment: .center
                )

            // Door step
            RoundedRectangle(cornerRadius: 2)
                .fill(accent.opacity(0.3))
                .frame(width: 60, height: 5)
        }
    }

    private func windowShape(accent: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(accent.opacity(0.06))
                .frame(width: 48, height: 40)
            RoundedRectangle(cornerRadius: 3)
                .stroke(accent.opacity(0.3), lineWidth: 1)
                .frame(width: 48, height: 40)
            // panes
            Rectangle().fill(accent.opacity(0.15)).frame(width: 0.5, height: 40)
            Rectangle().fill(accent.opacity(0.15)).frame(width: 48, height: 0.5)
        }
    }
}
