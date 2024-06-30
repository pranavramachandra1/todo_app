import SwiftUI

struct ContentView: View {
    @EnvironmentObject var listManager: ListManager
    
    @State private var isPresentingNewTaskView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(listManager.list) { task in
                    TaskView(task: task)
                }
            }
            .listStyle(.plain)
            .navigationTitle("ToDo:")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingNewTaskView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .sheet(isPresented: $isPresentingNewTaskView) {
                        NewTaskView()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ListManager())
    }
}
