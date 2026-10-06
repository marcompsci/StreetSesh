import Foundation
import Security

// MARK: - Keychain Service
// Replaces any plaintext (UserDefaults/in-memory) storage of session tokens,
// user IDs, or other sensitive values.

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private let service = "com.streetsesh.app"

    // MARK: - Write

    @discardableResult
    func set(_ value: String, for key: KeychainKey) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Delete any existing entry first
        delete(key)

        let query: [String: Any] = [
            kSecClass as String:             kSecClassGenericPassword,
            kSecAttrService as String:       service,
            kSecAttrAccount as String:       key.rawValue,
            kSecValueData as String:         data,
            kSecAttrAccessible as String:    kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    // MARK: - Read

    func get(_ key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String:  true,
            kSecMatchLimit as String:  kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
        return value
    }

    // MARK: - Delete

    @discardableResult
    func delete(_ key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }

    // MARK: - Clear all

    func clearAll() {
        KeychainKey.allCases.forEach { delete($0) }
    }
}

// MARK: - Keys

enum KeychainKey: String, CaseIterable {
    case supabaseAccessToken  = "supabase_access_token"
    case supabaseRefreshToken = "supabase_refresh_token"
    case userID               = "user_id"
    case deviceFingerprint    = "device_fingerprint"
    case ipBanCache           = "ip_ban_cache"
}
