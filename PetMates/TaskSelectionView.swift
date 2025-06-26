import SwiftUI

struct TaskSelectionView: View {
    
    @State private var selectedTasks: Set<String> = []
    @State private var petName = ""
    @State private var selectedType = ""
    
    let allTasks = ["Feed", "Water", "Walk", "Brush", "Play", "Litter", "Park", "Bath"]
    let petTypes = ["Dog", "Cat"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                PetBackground()
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("What does your pet do each day?")
                        .font(.title2)
                        .bold()
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.orange)
                    
                    Text("Choose the daily tasks you want to track")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(allTasks, id: \.self) { task in
                            TaskButton(task: task, isSelected: selectedTasks.contains(task)) {
                                withAnimation {
                                    toggleTask(task)
                                }
                            }
                        }
                    }
                    
                    
                    Text("Optional")
                        .font(.headline)
                    
                    TextField("Pet's Name", text: $petName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        ForEach(petTypes, id: \.self) { type in
                            Button(action: {
                                withAnimation {
                                    selectedType = type
                                }
                            }) {
                                HStack {
                                    Image(systemName: type == "Dog" ? "dog.fill" : "cat.fill")
                                    Text(type)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(selectedType == type ? Color.black : Color.clear)
                                .foregroundColor(selectedType == type ? .white : .black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.4), lineWidth: 1)
                                )
                                .cornerRadius(20)
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ChecklistView(tasks: Array(selectedTasks), petName: petName, petType: selectedType)) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(25)
                    }
                }
                .padding()
                
                .navigationTitle("PetMate")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    loadPreviousTasks()
                }
            }
        }
    }
    
    // Save every time task is toggled
    func toggleTask(_ task: String) {
        if selectedTasks.contains(task) {
            selectedTasks.remove(task)
        } else {
            selectedTasks.insert(task)
        }
        UserDefaults.standard.set(Array(selectedTasks), forKey: "taskList")
    }
    
    // Load on launch
    func loadPreviousTasks() {
        if let savedTasks = UserDefaults.standard.stringArray(forKey: "taskList") {
            selectedTasks = Set(savedTasks)
        }
    }
}



struct TaskButton: View {
    let task: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconForTask(task))
                Text(task)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.black : Color.clear)
            .foregroundColor(isSelected ? .white : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut, value: isSelected)
        }
    }
    
    func iconForTask(_ task: String) -> String {
        switch task {
        case "Feed": return "takeoutbag.and.cup.and.straw.fill"
        case "Water": return "drop"
        case "Walk": return "figure.walk"
        case "Go to Park": return "leaf"
        case "Brush": return "scissors"
        case "Play": return "sportscourt"
        case "Grooming": return "comb"
        case "Clean Litter": return "trash"
        default: return "pawprint"
        }
    }
}



struct PetBackground: View {
    var body: some View {
        ZStack {
            Image(systemName: "dog.fill")
                .resizable()
                .foregroundColor(.orange)
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .rotationEffect(.degrees(-15))
                .opacity(0.1)
                .offset(x: -100, y: -150)

            Image(systemName: "cat.fill")
                .resizable()
                .foregroundColor(.orange)
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
                .rotationEffect(.degrees(20))
                .opacity(0.1)
                .offset(x: 120, y: 200)
        }
    }
}

#Preview{
    TaskSelectionView()
}
