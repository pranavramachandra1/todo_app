import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    @EnvironmentObject var listManager: ListManager
    @EnvironmentObject var listLibrary: ListLibrary
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isPresentingNewTaskView = false
    @State private var isPresentingLibrary = false
    @State private var isPresentingSuggestionView = false
    @State private var isPresentingTagListView = false
    @State private var showAlert = false
    
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    var body: some View {
        NavigationStack {
            List {
                ForEach(listManager.viewableList) { task in
                    TaskView(task: task)
                }
            }
            .listStyle(.plain)
            .navigationTitle("ToDo:")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresentingTagListView = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    }
                    .foregroundColor(.blue)
                    .sheet(isPresented: $isPresentingTagListView) {
                        TagListView()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
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
                .foregroundColor(colorScheme == .dark ? .white: .black)
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
                .foregroundColor(colorScheme == .dark ? .white: .black)
                .alert("Update List:", isPresented: $showAlert) {
                    Button("Clear & create new", action: {listManager.clearList()})
                    Button("Rollover", action: {listManager.rolloverList()}).keyboardShortcut(.defaultAction)
                        Button("Cancel", role: .cancel, action: {})

                    }

                
                Spacer()
                
                // Get user analytics with gemini API
                Button(action: {
                    isPresentingSuggestionView = true
                }) {
                    Image(systemName: "lightbulb")
                }
                .foregroundColor(colorScheme == .dark ? .white: .black)
                .sheet(isPresented: $isPresentingSuggestionView) {
                    SuggestionView()
                }
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
