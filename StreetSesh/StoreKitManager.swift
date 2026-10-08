import StoreKit
import Foundation

// MARK: - StoreKit Manager
// StoreKit 2 subscription management for StreetSesh Pro.
//
// Setup required (before revenue testing):
//   1. App Store Connect → My Apps → StreetSesh → Features → In-App Purchases
//   2. Create Auto-Renewable Subscription group "Pro"
//   3. Add products with IDs below
//   4. Add a StoreKit configuration file for sandbox testing

@Observable
final class StoreKitManager {
    static let shared = StoreKitManager()

    static let proMonthlyID = "com.streetsesh.pro.monthly"
    static let proAnnualID  = "com.streetsesh.pro.annual"

    private(set) var products: [Product] = []
    var isPro = false

    private var updateListenerTask: Task<Void, Error>?

    private init() {
        updateListenerTask = listenForTransactions()
        Task { await loadProducts() }
        Task { await updateProStatus() }
    }

    deinit { updateListenerTask?.cancel() }

    var monthlyProduct: Product? { products.first { $0.id == Self.proMonthlyID } }
    var annualProduct:  Product? { products.first { $0.id == Self.proAnnualID } }

    // MARK: Purchase

    @discardableResult
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateProStatus()
            await transaction.finish()
            AnalyticsService.shared.track(.proUpgrade, meta: product.id)
            return true
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }

    func restorePurchases() async {
        try? await AppStore.sync()
        await updateProStatus()
    }

    // MARK: Private

    @MainActor
    private func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.proMonthlyID, Self.proAnnualID])
                .sorted { $0.price > $1.price } // annual first
        } catch {
            // Sandbox not configured yet — products unavailable
        }
    }

    @MainActor
    private func updateProStatus() async {
        var foundPro = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result {
                if (tx.productID == Self.proMonthlyID || tx.productID == Self.proAnnualID),
                   tx.revocationDate == nil {
                    foundPro = true
                }
            }
        }
        isPro = foundPro
    }

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached(priority: .background) {
            for await result in Transaction.updates {
                if case .verified(let tx) = result {
                    await self.updateProStatus()
                    await tx.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let value): return value
        }
    }

    enum StoreError: LocalizedError {
        case failedVerification
        var errorDescription: String? { "Purchase verification failed." }
    }
}
