//
//  ContentView.swift
//  QuizApp
//
//  Created by İbrahim Uğurlu on 27.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showQuiz = false
    @State private var quizID = UUID()
    @State private var quizCompleted = false
    @State private var finalScore = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    quizID = UUID()
                    showQuiz = true
                }) {
                    Text("Başla")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $showQuiz) {
                QuizView(quizCompleted: $quizCompleted, finalScore: $finalScore)
                    .id(quizID)
            }
        }
    }
}

#Preview {
    ContentView()
}
