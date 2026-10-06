import Foundation
import UIKit

// MARK: - Security Service

@MainActor
final class SecurityService {
    static let shared = SecurityService()
    private init() {}

    // MARK: - Public API

    /// Returns true when the device or binary shows signs of tampering.
    /// Call once at launch; if true, show AppSecurityGateView and halt.
    /// Always returns false in DEBUG builds — debugger attachment would otherwise
    /// trigger a false positive via the P_TRACED flag check.
    func isDeviceCompromised() -> Bool {
#if DEBUG
        return false
#else
        return isJailbroken() || isBundleIDSpoofed() || isDebugged()
#endif
    }

    /// Returns true if the app is currently being screen-recorded.
    func isScreenBeingRecorded() -> Bool {
        UIScreen.main.isCaptured
    }

    // MARK: - Jailbreak detection

    private func isJailbroken() -> Bool {
#if targetEnvironment(simulator)
        return false
#else
        // Suspicious file paths that only exist on jailbroken devices
        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash", "/usr/sbin/sshd", "/etc/apt",
            "/private/var/lib/apt/", "/private/var/lib/cydia",
            "/usr/bin/ssh", "/usr/libexec/sftp-server",
        ]
        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) { return true }
        }

        // Attempt sandbox violation: jailbroken apps can write outside sandbox
        let testPath = "/private/jb_test_\(UUID().uuidString)"
        do {
            try "jailbreak_test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true  // write succeeded — sandbox is broken
        } catch {}

        // Check for suspicious URL schemes (Cydia, Sileo)
        for scheme in ["cydia://", "sileo://", "zbra://"] {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                return true
            }
        }

        return false
#endif
    }

    // MARK: - Bundle integrity

    private func isBundleIDSpoofed() -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier else { return true }
        // Replace with your actual bundle ID if changed from default
        let expected = "com.streetsesh.app"
        // Only block if a custom bundle ID was set and it doesn't match
        // (placeholder prefix check — adjust to your real ID)
        return bundleID.isEmpty || (!bundleID.hasPrefix("com.") && !bundleID.hasPrefix("streetsesh"))
    }

    // MARK: - Debugger detection

    private func isDebugged() -> Bool {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        let rc = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        if rc == 0 {
            return (info.kp_proc.p_flag & P_TRACED) != 0
        }
        return false
    }
}

// MARK: - Screen recording notification

extension SecurityService {
    /// Call once from ContentView .onAppear to start monitoring screen capture.
    /// The provided closure is called whenever recording starts or stops.
    func observeScreenCapture(onChange: @escaping (Bool) -> Void) {
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil, queue: .main
        ) { _ in
            onChange(UIScreen.main.isCaptured)
        }
    }
}
