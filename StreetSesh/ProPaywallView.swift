import SwiftUI
import StoreKit

struct ProPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan = StoreKitManager.proAnnualID
    @State private var isPurchasing = false

    private let store = StoreKitManager.shared

    private let features: [(icon: String, label: String, colorHex: String)] = [
        ("brain.head.profile",              "Skate Coach AI",              "#C77DFF"),
        ("map.fill",                        "Unlimited Spot Saves",        "#3AB5E6"),
        ("antenna.radiowaves.left.and.right", "Priority Condition Updates","#CCFF40"),
        ("chart.bar.xaxis",                 "Personal Progress Analytics", "#FF9500"),
        ("flag.fill",                       "Brand Challenges (coming)",   "#FF3B30"),
        ("crown.fill",                      "Pro Badge on Profile",        "#FFD700"),
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    paywallHeader
                    featureList
                    planPicker
                    ctaButton
                    restoreButton
                    legalFooter
                    Spacer(minLength: 50)
                }
            }
            dismissButton
        }
    }

    // MARK: - Header

    private var paywallHeader: some View {
        ZStack(alignment: .center) {
            RadialGradient(
                gradient: Gradient(colors: [Color(hex: "#C77DFF").opacity(0.25), Color.clear]),
                center: .center,
                startRadius: 10,
                endRadius: 200
            )
            .frame(height: 270)

            VStack(spacing: 12) {
                Spacer().frame(height: 80)
                ZStack {
                    Circle()
                        .fill(Color(hex: "#C77DFF").opacity(0.15))
                        .frame(width: 84, height: 84)
                    Image(systemName: "crown.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color(hex: "#FFD700"))
                }
                Text("StreetSesh Pro")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(.white)
                Text("Unlock the full skate experience.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Feature List

    private var featureList: some View {
        VStack(spacing: 0) {
            ForEach(features, id: \.label) { f in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: f.colorHex).opacity(0.15))
                            .frame(width: 36, height: 36)
                        Image(systemName: f.icon)
                            .font(.system(size: 15))
                            .foregroundStyle(Color(hex: f.colorHex))
                    }
                    Text(f.label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color(hex: "#C77DFF"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
                if f.label != features.last?.label {
                    Divider()
                        .background(Color.white.opacity(0.06))
                        .padding(.leading, 70)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }

    // MARK: - Plan Picker

    private var planPicker: some View {
        VStack(spacing: 10) {
            let annualID  = StoreKitManager.proAnnualID
            let monthlyID = StoreKitManager.proMonthlyID

            if let annual = store.annualProduct {
                planRow(id: annualID, title: "Annual",
                        price: annual.displayPrice + " / year",
                        badge: "Save ~40%", badgeColor: "#34C759")
            } else {
                planRow(id: annualID, title: "Annual",
                        price: "$29.99 / year",
                        badge: "Save ~40%", badgeColor: "#34C759")
            }

            if let monthly = store.monthlyProduct {
                planRow(id: monthlyID, title: "Monthly",
                        price: monthly.displayPrice + " / month",
                        badge: nil, badgeColor: nil)
            } else {
                planRow(id: monthlyID, title: "Monthly",
                        price: "$4.99 / month",
                        badge: nil, badgeColor: nil)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private func planRow(id: String, title: String, price: String,
                         badge: String?, badgeColor: String?) -> some View {
        let selected = selectedPlan == id
        return Button { selectedPlan = id } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(selected ? Color(hex: "#C77DFF") : Color.white.opacity(0.3),
                                lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if selected {
                        Circle()
                            .fill(Color(hex: "#C77DFF"))
                            .frame(width: 12, height: 12)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(price)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if let badge, let colorHex = badgeColor {
                    Text(badge)
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(Color(hex: colorHex))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: colorHex).opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(selected ? Color(hex: "#C77DFF").opacity(0.10) : Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected ? Color(hex: "#C77DFF").opacity(0.6) : Color.white.opacity(0.1),
                            lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - CTA

    private var ctaButton: some View {
        Button { purchaseSelected() } label: {
            Group {
                if isPurchasing {
                    ProgressView().tint(.black)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill").font(.system(size: 14))
                        Text("Start Pro")
                            .font(.system(size: 16, weight: .black))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(hex: "#C77DFF"))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isPurchasing)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var restoreButton: some View {
        Button {
            Task { await store.restorePurchases() }
        } label: {
            Text("Restore Purchases")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    private var legalFooter: some View {
        Text("Subscription renews automatically. Cancel anytime in App Store settings.")
            .font(.system(size: 10))
            .foregroundStyle(Color.secondary.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.top, 10)
    }

    private var dismissButton: some View {
        VStack {
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(.top, 56)
                .padding(.trailing, 20)
            }
            Spacer()
        }
    }

    // MARK: - Helpers

    private func purchaseSelected() {
        let product = selectedPlan == StoreKitManager.proAnnualID
            ? store.annualProduct
            : store.monthlyProduct
        guard let product else { return }
        isPurchasing = true
        Task {
            _ = try? await store.purchase(product)
            await MainActor.run { isPurchasing = false }
        }
    }
}
