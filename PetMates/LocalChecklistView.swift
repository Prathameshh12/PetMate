
import SwiftUI

struct LocalChecklistView: View {
    
    @State private var tasks: [String] = []
    @State private var taskProgress: [String: Bool] = [:]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        Text(task)
                        Spacer()
                        Image(systemName: taskProgress[task] == true ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(taskProgress[task] == true ? .green : .gray)
                            .onTapGesture {
                                toggleTask(task)
                            }
                    }
                }
            }
            .navigationTitle("Your Pet's Tasks")
            .onAppear {
                loadTasks()
            }
        }
    }
    
    func toggleTask(_ task: String) {
        taskProgress[task]?.toggle()
        saveProgress()
    }
    
    func loadTasks() {
        tasks = UserDefaults.standard.stringArray(forKey: "taskList") ?? []
        if let savedProgress = UserDefaults.standard.dictionary(forKey: "taskProgress") as? [String: Bool] {
            taskProgress = savedProgress
        } else {
            taskProgress = tasks.reduce(into: [:]) { $0[$1] = false }
        }
    }
    
    func saveProgress() {
        UserDefaults.standard.set(taskProgress, forKey: "taskProgress")
    }
}
