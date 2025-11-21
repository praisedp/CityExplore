import SwiftUI

struct SplashView: View {
    @State private var animateLogo = false
    @State private var animateText = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .scaleEffect(animateLogo ? 1.1 : 0.8)
                    .shadow(color: .white.opacity(0.5), radius: 20)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateLogo)
                
                VStack(spacing: 8) {
                    Text("City Explorer")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(.easeOut(duration: 1), value: animateText)
                    
                    Text("Discover, remember, and revisit your favorite places.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(.easeOut(duration: 1).delay(0.2), value: animateText)
                }
            }
        }
        .onAppear {
            animateLogo = true
            animateText = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


