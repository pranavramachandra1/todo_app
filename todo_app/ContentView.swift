import SwiftUI

struct ContentView: View {
    @EnvironmentObject var listManager: ListManager
    @EnvironmentObject var listLibrary: ListLibrary
    
    @State private var isPresentingNewTaskView = false
    @State private var isPresentingLibrary = false
    @State private var showAlert = false

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
                    .foregroundColor(.green)
                    .sheet(isPresented: $isPresentingNewTaskView) {
                        NewTaskView()
                    }
                }
            }
            
            HStack {
                
                Spacer()
                
                // View previous lists:
                Button(action: {
                    isPresentingLibrary = true
                }) {
                    Image(systemName: "newspaper")
                }
                .foregroundColor(.black)
                .sheet(isPresented: $isPresentingLibrary) {
                    LibraryView()
                }
                
                Spacer()
                
                // View previous lists:
                Button(action: {
                    showAlert = true
                }) {
                    Image(systemName: "arrow.2.circlepath")
                }
                .foregroundColor(.black)
                .alert("Test", isPresented: $showAlert) {
                    Button("Clear & create new", action: {listManager.clearList()})
                    Button("Rollover", action: {listManager.rolloverList()}).keyboardShortcut(.defaultAction)
                        Button("Cancel", role: .cancel, action: {})

                    }

                
                Spacer()
                
                // Get user analytics with gemini API
                Button(action: {
                    print("Ask gemini")
                }) {
                    Image(systemName: "lightbulb")
                }
                .foregroundColor(.black)
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let listLibrary = ListLibrary() // Create an instance of ListLibrary
        let listManager = ListManager(listLibrary: listLibrary) // Initialize ListManager with ListLibrary

        return ContentView()
            .environmentObject(listManager) // Pass the ListManager instance
            .environmentObject(listLibrary) // Pass the ListLibrary instance
    }
}
