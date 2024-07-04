//
//  SuggestionView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/3/24.
//

import SwiftUI
import GoogleGenerativeAI

struct SuggestionView: View {
    @EnvironmentObject var listLibrary: ListLibrary
    @State private var response: String = "Loading..."
    @State private var isLoading: Bool = false
    
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    VStack {
                        Text("Your ToDo Progress:")
                            .font(.largeTitle)
                            .bold()
                        
                        Text(response)
                            .padding()
                        
                        Spacer()
                    }
                    .padding()
                }
                .task {
                    await generateResponse()
                }
            }
        }
    
    func generateResponse() async {
        let prompt = listLibrary.generateSuggestionPromot()
        isLoading = true
        do {
            let responseContent = try await model.generateContent(prompt)
            if let text = responseContent.text {
                response = text
            } else {
                response = "No response received."
            }
        } catch {
            response = "An error occurred: \(error)"
        }
        isLoading = false
    }
}

#Preview {
    SuggestionView()
}
