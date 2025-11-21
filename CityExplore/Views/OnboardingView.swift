import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let systemImage: String
}

private let onboardingPages: [OnboardingPage] = [
    OnboardingPage(
        title: "Discover Places",
        message: "Keep track of parks, restaurants, and hidden gems you find in any city.",
        systemImage: "mappin.and.ellipse"
    ),
    OnboardingPage(
        title: "Save Details",
        message: "Add notes, categories, and mark your favorites so you never forget why you loved them.",
        systemImage: "star.circle"
    ),
    OnboardingPage(
        title: "See It All",
        message: "Browse your list or jump to the map to explore everything you’ve saved at a glance.",
        systemImage: "map.circle"
    )
]

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: 24) {
                        Image(systemName: page.systemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .foregroundColor(.accentColor)
                            .padding()
                        
                        Text(page.title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(page.message)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button(action: advanceOrFinish) {
                Text(currentIndex == onboardingPages.count - 1 ? "Get Started" : "Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
    }
    
    private func advanceOrFinish() {
        if currentIndex < onboardingPages.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


