import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var username = ""
    @State private var city = "San Francisco"
    @State private var isUnder18 = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()

                // Wordmark
                VStack(spacing: 0) {
                    Text("STREET")
                        .font(.system(size: 54, weight: .black))
                        .foregroundStyle(.orange)
                    Text("SESH")
                        .font(.system(size: 54, weight: .black))
                        .foregroundStyle(.white)
                    Text("The spot app skaters actually trust.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }

                Spacer()

                // Form
                VStack(spacing: 16) {
                    inputField(label: "USERNAME", placeholder: "grindset_99", text: $username)
                        .autocorrectionDisabled()

                    inputField(label: "YOUR CITY", placeholder: "San Francisco", text: $city)

                    Toggle(isOn: $isUnder18) {
                        Text("I'm under 18")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .tint(.orange)
                }
                .padding(.horizontal)

                Spacer()

                // CTA
                Button { createUser() } label: {
                    Text("GET SKATING")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding()
            }
        }
    }

    @ViewBuilder
    private func inputField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)
            TextField("", text: text, prompt: Text(placeholder).foregroundStyle(.secondary))
                .font(.title3)
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
        }
    }

    private func createUser() {
        let name = username.trimmingCharacters(in: .whitespaces)
        let userCity = city.trimmingCharacters(in: .whitespaces)
        let user = AppUser(
            username: name.isEmpty ? "skater" : name,
            city: userCity.isEmpty ? "San Francisco" : userCity,
            isUnder18: isUnder18
        )
        modelContext.insert(user)
        Task { try? await SupabaseService.shared.upsertUser(user) }
    }
}
