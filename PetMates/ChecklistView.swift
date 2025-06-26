import SwiftUI

struct ChecklistView: View {
    
    let tasks: [String]
    let petName: String
    let petType: String
    
    @State private var taskQueue: [String] = []
    @State private var doneTasks: [String] = []
    @State private var notDoneTasks: [String] = []
    
    @State private var showUndo = false
    @State private var lastActionTask = ""
    @State private var lastActionType = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                PetBackground()
                ZStack {
                    
                    if let currentTask = taskQueue.first {
                        SwipeCard(task: currentTask, onSwipeRight: {
                            markTask(task: currentTask, type: "Done")
                        }, onSwipeLeft: {
                            markTask(task: currentTask, type: "Not Done")
                        })
                    } else {
                        VStack(spacing: 20) {
                            Text("All tasks reviewed!")
                                .font(.title2)
                                .bold()
                            
                            if !petName.isEmpty {
                                Text("Pet's Name: \(petName)")
                            }
                            
                            if !petType.isEmpty {
                                Text("Pet Type: \(petType)")
                            }
                            
                            Text("✅ Done: \(doneTasks.count)   ❌ Not Done: \(notDoneTasks.count)")
                                .foregroundColor(.gray)
                            
                            if !doneTasks.isEmpty || !notDoneTasks.isEmpty {
                                List {
                                    if !doneTasks.isEmpty {
                                        Section("Done Tasks") {
                                            ForEach(doneTasks, id: \.self) { Text($0) }
                                        }
                                    }
                                    if !notDoneTasks.isEmpty {
                                        Section("Not Done Tasks") {
                                            ForEach(notDoneTasks, id: \.self) { Text($0) }
                                        }
                                    }
                                }
                                .frame(height: 300)
                            }
                            
                            NavigationLink(destination: SummaryView(totalTasks: doneTasks.count + notDoneTasks.count, doneTasks: doneTasks.count, petName: petName, petType: petType)) {
                                Text("View Today's Progress")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(25)
                            }
                            
                            NavigationLink(destination: TaskSelectionView()) {
                                Text("Edit Tasks or Restart")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(25)
                            }
                        }
                    }
                    
                    if showUndo {
                        VStack {
                            Spacer()
                            HStack {
                                Text("Task '\(lastActionTask)' marked \(lastActionType).")
                                Spacer()
                                Button("Undo") {
                                    undoLastAction()
                                }
                                .bold()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.9))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding()
                            .transition(.move(edge: .bottom))
                        }
                        .animation(.easeInOut, value: showUndo)
                    }
                }
                .padding()
                .onAppear {
                    taskQueue = tasks
                }
                .navigationTitle("Today's Checklist")
            }
        }
    }
    
    private func markTask(task: String, type: String) {
        withAnimation {
            _ = taskQueue.removeFirst()
        }
        if type == "Done" {
            doneTasks.append(task)
        } else {
            notDoneTasks.append(task)
        }
        lastActionTask = task
        lastActionType = type
        showUndo = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showUndo = false
            }
        }
    }
    
    private func undoLastAction() {
        withAnimation {
            if lastActionType == "Done" {
                doneTasks.removeLast()
            } else {
                notDoneTasks.removeLast()
            }
            taskQueue.insert(lastActionTask, at: 0)
            showUndo = false
        }
    }
}

struct SwipeCard: View {
    
    let task: String
    let onSwipeRight: () -> Void
    let onSwipeLeft: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(task) // Image name in Assets must match task string exactly
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            Text(task)
                .font(.title)
                .bold()
            
            Text("Swipe Left = Not Done   |   Swipe Right = Done")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 450)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .offset(offset)
        .rotationEffect(.degrees(Double(offset.width) / 20))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if offset.width > 100 {
                        onSwipeRight()
                    } else if offset.width < -100 {
                        onSwipeLeft()
                    }
                    offset = .zero
                }
        )
        .animation(.spring(), value: offset)
    }
}
