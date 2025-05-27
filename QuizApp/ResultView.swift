//
//  ResultView.swift
//  QuizApp
//
//  Created by İbrahim Uğurlu on 27.05.2025.
//

import SwiftUI

struct ResultView: View {
    let skor: Int
    let toplamSoru: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Bitti!")
                .font(.largeTitle)
                .bold()
            
            Text("Skorunuz: \(skor)/\(toplamSoru)")
                .font(.title)
            
            Button(action: {
                dismiss()
            }) {
                Text("Ana Menüye Dön")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 30)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
} 
