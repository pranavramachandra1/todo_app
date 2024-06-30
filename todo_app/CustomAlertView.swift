//
//  CustomAlertView.swift
//  ToDo
//
//  Created by Pranav Ramachandra on 6/23/24.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var options: [String]
    var actions: [() -> Void]
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            VStack {
                Text(title).font(.headline)
                Text(message).font(.subheadline)
                ForEach(0..<options.count, id: \.self) { index in
                    Button(action: {
                        actions[index]()
                        isPresented = false
                    }) {
                        Text(options[index])
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .frame(maxWidth: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        options: [String],
        actions: [() -> Void]
    ) -> some View {
        self.overlay(
            CustomAlertView(
                title: title,
                message: message,
                options: options,
                actions: actions,
                isPresented: isPresented
            )
        )
    }
}
