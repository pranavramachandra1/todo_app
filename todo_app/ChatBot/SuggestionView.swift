//
//  SuggestionView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/3/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool // true for user messages, false for bot responses
}

struct SuggestionView: View {
    @EnvironmentObject var listLibrary: ListLibrary
    @State private var messages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var isLoading: Bool = false

    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    
                                    
                                    
                                    
                                    if isLoading && message.id == messages.last?.id {
                                        Text("Loading...")
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
                
                // Input field and send button
                HStack {
                    TextField("Type a message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(userInput.isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("Chat with Suggestions")
            .onAppear {
                Task {
                    await initialBotMessage()
                }
            }
        }
    }
    
    // Sends the initial bot message based on user data
    func initialBotMessage() async {
        isLoading = true
        let prompt = listLibrary.generateSuggestionPromot()
        if !prompt.isEmpty {
            await generateResponse(for: prompt)
        }
        isLoading = false
    }
    
    // Sends user input as a message and generates a response
    func sendMessage() {
        let userMessage = ChatMessage(text: userInput, isUser: true)
        messages.append(userMessage)
        
        let prompt = userInput // Send user's custom prompt to the model
        userInput = ""
        Task {
            isLoading = true
            await generateResponse(for: prompt)
            isLoading = false
        }
    }
    
    func addChatHistory(prompt: String) -> String {
        var chatPrompt = prompt + " Consider the chat history between you and the user: "
        
        for chat in messages {
            if chat.isUser {
                chatPrompt += "User: "
            } else {
                chatPrompt += "Gemini: "
            }
            
            chatPrompt += chat.text
        }
        
        return chatPrompt
    }
    
    // Generate a response from the model
    func generateResponse(for prompt: String) async {
        do {
            
            print(addChatHistory(prompt: prompt))
            
            let responseContent = try await model.generateContent(addChatHistory(prompt: prompt))
            if let text = responseContent.text {
                let botMessage = ChatMessage(text: text, isUser: false)
                messages.append(botMessage)
            } else {
                let botMessage = ChatMessage(text: "No response received.", isUser: false)
                messages.append(botMessage)
            }
        } catch {
            let errorMessage = ChatMessage(text: "An error occurred: \(error)", isUser: false)
            messages.append(errorMessage)
        }
    }
}

#Preview {
    SuggestionView()
}
