import SwiftUI
import SwiftData
import UIKit

// MARK: - UIImagePickerController wrapper

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Spot Photo Report Sheet

struct SpotPhotoReportSheet: View {
    let spotName: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]

    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .camera
    @State private var capturedImage: UIImage?
    @State private var note = ""
    @State private var submitted = false

    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if submitted {
                    submittedView
                } else {
                    mainContent
                }
            }
            .navigationTitle("Report Spot Update")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $capturedImage, sourceType: pickerSource)
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {

                // Spot label
                VStack(alignment: .leading, spacing: 4) {
                    Text("SPOT")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(.secondary)
                    Text(spotName)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }

                // Photo picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("PHOTO")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(.secondary)

                    if let img = capturedImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(alignment: .topTrailing) {
                                Button { capturedImage = nil } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.white)
                                        .padding(10)
                                }
                            }
                    } else {
                        HStack(spacing: 12) {
                            if cameraAvailable {
                                photoSourceButton(icon: "camera.fill", label: "Camera") {
                                    pickerSource = .camera
                                    showImagePicker = true
                                }
                            }
                            photoSourceButton(icon: "photo.on.rectangle", label: "Library") {
                                pickerSource = .photoLibrary
                                showImagePicker = true
                            }
                        }
                    }
                }

                // Note
                VStack(alignment: .leading, spacing: 8) {
                    Text("NOTE (OPTIONAL)")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(.secondary)
                    TextField("What's changed? Any access, lighting, or obstacle updates?",
                              text: $note, axis: .vertical)
                        .lineLimit(3...6)
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Submit
                Button { submitReport() } label: {
                    Label("Submit Report", systemImage: "arrow.up.circle.fill")
                        .font(.system(size: 15, weight: .black))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(capturedImage != nil ? Color.orange : Color.white.opacity(0.08))
                        .foregroundStyle(capturedImage != nil ? .black : .secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(capturedImage == nil)
                .animation(.easeInOut(duration: 0.2), value: capturedImage != nil)
            }
            .padding(20)
        }
    }

    private var submittedView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)
            Text("Report Submitted")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Thanks for keeping the spot map fresh.\nWe'll review your update soon.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button("Done") { dismiss() }
                .font(.system(size: 15, weight: .black))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.orange)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
    }

    private func photoSourceButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(Color.white.opacity(0.08))
            .foregroundStyle(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private func submitReport() {
        guard let img = capturedImage,
              let data = img.jpegData(compressionQuality: 0.75) else { return }
        let username = users.first?.username ?? "anonymous"
        let report = SpotPhotoReport(spotName: spotName, photoData: data,
                                     note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                                     submittedBy: username)
        modelContext.insert(report)
        withAnimation(.spring(response: 0.4)) { submitted = true }
    }
}
