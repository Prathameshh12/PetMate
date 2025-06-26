import SwiftUI

struct HomeScreen: View {
    @State private var showSplash: Bool = true
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8
    @State private var navigateToMain: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.opacity(0.2).ignoresSafeArea()

                NavigationLink(destination: TaskSelectionView(), isActive: $navigateToMain) {
                    EmptyView()
                }

                if showSplash {
                    VStack(spacing: 20) {
                        Image("AppLogo") // Replace with your actual asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .scaleEffect(scale)

                        Text("PetMate")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .scaleEffect(scale)
                    }
                    .opacity(opacity)
                    .onAppear {
                        // Animate fade-in and scale up over 2 seconds
                        withAnimation(.easeInOut(duration: 2.0)) {
                            opacity = 1.0
                            scale = 1.0
                        }

                        // After 3 seconds, trigger navigation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                showSplash = false
                                navigateToMain = true
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
