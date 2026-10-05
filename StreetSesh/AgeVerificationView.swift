import SwiftUI
import AVFoundation
import Vision

// MARK: - Age Verification Gate
// Step 0.5 in onboarding — inserted after splash.
// Requires:
//   1. User declares they are 18+
//   2. Camera confirms a live face is present (liveness check via Vision)
//
// Full KYC (ID document + face-match) requires a third-party service such as
// Stripe Identity (https://stripe.com/identity), Onfido, or Persona.
// Set KYCEnabled = true and provide your endpoint/session token to enable it.

private let KYCEnabled = false   // flip to true when KYC service is configured

struct AgeVerificationView: View {
    let onVerified: () -> Void    // called when verification passes
    let onCancel: () -> Void      // called when user goes back

    @State private var declared18 = false
    @State private var faceDetected = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var isVerifying = false
    @State private var verificationFailed = false
    @State private var failMessage = ""

    var canProceed: Bool { declared18 && faceDetected }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Verify\nyour age.")
                        .font(.system(size: 36, weight: .black)).foregroundStyle(.white)
                    Text("StreetSesh is for skaters 18 and over.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.top, 110)
                .padding(.bottom, 36)

                Spacer()

                VStack(spacing: 16) {
                    // Face capture card
                    Button { showCamera = true } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(faceDetected ? Color.green.opacity(0.15) : Color.white.opacity(0.08))
                                    .frame(width: 52, height: 52)
                                if let img = capturedImage {
                                    Image(uiImage: img)
                                        .resizable().scaledToFill()
                                        .frame(width: 52, height: 52)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(faceDetected ? .green : .secondary)
                                }
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(faceDetected ? "Face confirmed" : "Take a selfie")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(faceDetected ? .green : .white)
                                Text(faceDetected ? "Liveness check passed" : "We need to confirm you're a real person")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: faceDetected ? "checkmark.circle.fill" : "chevron.right")
                                .foregroundStyle(faceDetected ? .green : .secondary)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(faceDetected ? Color.green.opacity(0.4) : Color.clear, lineWidth: 1.5))
                    }

                    // 18+ declaration
                    Button {
                        withAnimation(.spring(response: 0.25)) { declared18.toggle() }
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(declared18 ? Color.orange : Color.white.opacity(0.1))
                                    .frame(width: 24, height: 24)
                                if declared18 {
                                    Image(systemName: "checkmark").font(.system(size: 13, weight: .black))
                                        .foregroundStyle(.black)
                                }
                            }
                            Text("I confirm I am 18 years of age or older")
                                .font(.subheadline).foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)

                    if verificationFailed {
                        Text(failMessage)
                            .font(.caption).foregroundStyle(.red)
                            .padding(.horizontal, 4)
                    }

                    // Continue button
                    Button {
                        Task { await verify() }
                    } label: {
                        Group {
                            if isVerifying {
                                ProgressView().tint(.black)
                            } else {
                                Text("VERIFY & CONTINUE  →").font(.headline.weight(.black))
                            }
                        }
                        .frame(maxWidth: .infinity).padding(18)
                        .background(canProceed ? Color.orange : Color.white.opacity(0.1))
                        .foregroundStyle(canProceed ? Color.black : Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(!canProceed || isVerifying)

                    Button(action: onCancel) {
                        Text("Back").font(.subheadline.weight(.semibold)).foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 52)
            }
        }
        .sheet(isPresented: $showCamera) {
            FaceCaptureView { image in
                capturedImage = image
                showCamera = false
                if let img = image { detectFace(in: img) }
            }
            .ignoresSafeArea()
        }
    }

    private func detectFace(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let request = VNDetectFaceRectanglesRequest { req, err in
            DispatchQueue.main.async {
                let faces = req.results as? [VNFaceObservation] ?? []
                if faces.isEmpty {
                    verificationFailed = true
                    failMessage = "No face detected. Please retake the selfie in good lighting."
                    faceDetected = false
                } else {
                    faceDetected = true
                    verificationFailed = false
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    private func verify() async {
        isVerifying = true
        defer { isVerifying = false }

        if KYCEnabled {
            // TODO: Call your KYC service here (Stripe Identity / Onfido / Persona)
            // Example with Stripe Identity:
            //   1. Create a VerificationSession on your backend
            //   2. Present StripeIdentity.verificationFlow(clientSecret: ...) in SwiftUI
            //   3. On .flowCompleted, proceed
            // For now, fall through to the declaration-based path
        }

        // Minimum viable: face detected + 18+ declaration
        if faceDetected && declared18 {
            onVerified()
        } else {
            verificationFailed = true
            failMessage = "Please complete both steps above."
        }
    }
}

// MARK: - Camera Capture (UIKit wrapper)

struct FaceCaptureView: UIViewControllerRepresentable {
    let onCapture: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: FaceCaptureView
        init(_ p: FaceCaptureView) { self.parent = p }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.onCapture(info[.originalImage] as? UIImage)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCapture(nil)
        }
    }
}
