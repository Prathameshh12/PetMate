import SwiftUI
import WebKit

struct SummaryView: View {
    let totalTasks: Int
    let doneTasks: Int
    let petName: String
    let petType: String

    var completionRate: Double {
        totalTasks == 0 ? 0 : Double(doneTasks) / Double(totalTasks)
    }

    @Environment(\.dismiss) var dismiss
    @State private var navigateToTaskSelection = false

    var body: some View {
        NavigationStack {
            ZStack {
                PetBackground()
                VStack(spacing: 30) {
                    
                    Text("Today's Summary for \(petName.isEmpty ? "Your Pet" : petName)")
                        .font(.title2)
                        .bold()
                    
                    if completionRate == 1.0 {
                        // Show GIF only if 100% completed
                        Image("happy_dog")
                            .frame(width: 200, height: 200)
                    } else {
                        Image(dogFaceImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190, height: 190)
                    }
                    
                    ProgressView(value: completionRate)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding()
                    
                    Text("\(Int(completionRate * 100))% of tasks completed")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(" Tasks Done: \(doneTasks)")
                        Text("Tasks Missed: \(totalTasks - doneTasks)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    NavigationLink(destination: TaskSelectionView(), isActive: $navigateToTaskSelection) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        navigateToTaskSelection = true
                    }) {
                        Text("Back to Task Selection")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(25)
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }

    func dogFaceImage() -> String {
        return completionRate > 0.5 ? "happy_dog" : "sad_dog"
    }
}

struct GIFView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        if let gifURL = URL(string: url) {
            let request = URLRequest(url: gifURL)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
