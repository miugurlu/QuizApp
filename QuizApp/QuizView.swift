//
//  QuizView.swift
//  QuizApp
//
//  Created by İbrahim Uğurlu on 27.05.2025.
//

import SwiftUI

struct QuizView: View {
    @Binding var quizCompleted: Bool
    @Binding var finalScore: Int
    
    @State private var sorular: [Question] = []
    @State private var soruNo = 0
    @State private var secilen_cevap: Int?
    @State private var skor = 0
    @State private var quizBitti = false
    @State private var kalanSure = 20
    @State private var toplamKalanSure = 60
    @State private var timer: Timer?
    @State private var toplamTimer: Timer?
    
    init(quizCompleted: Binding<Bool>, finalScore: Binding<Int>) {
        _quizCompleted = quizCompleted
        _finalScore = finalScore
        _sorular = State(initialValue: [])
        _soruNo = State(initialValue: 0)
        _secilen_cevap = State(initialValue: nil)
        _skor = State(initialValue: 0)
        _quizBitti = State(initialValue: false)
        _kalanSure = State(initialValue: 20)
        _toplamKalanSure = State(initialValue: 60)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if !quizBitti {
                HStack(spacing: 10) {
                    // Toplam süre
                    Text("Toplam: \(toplamKalanSure)s")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.1))
                        )
                    
                    // Soru süresi
                    Text("Soru: \(kalanSure)s")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.1))
                        )
                }
                .padding(.horizontal)
                
                Text("Soru \(soruNo + 1)/\(sorular.count)")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.vertical, 5)
            }
            
            VStack(spacing: 20) {
                if !quizBitti {
                    Text("Skor: \(skor)")
                        .font(.largeTitle)
                }
                
                if quizBitti {
                    ResultView(skor: skor, toplamSoru: sorular.count)
                        .onAppear {
                            finalScore = skor
                            quizCompleted = true
                        }
                } else if !sorular.isEmpty {
                    Text(sorular[soruNo].soru)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(0..<sorular[soruNo].secenekler.count, id: \.self) { index in
                            Button(action: {
                                secilen_cevap = index
                                cevapKontrol(index)
                            }) {
                                Text(sorular[soruNo].secenekler[index])
                                    .font(.body)
                                    .foregroundColor(secilen_cevap == index ? .white : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(secilen_cevap == index ? Color.blue : Color.gray.opacity(0.2))
                                    )
                            }
                            .disabled(secilen_cevap != nil)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            soruYukle()
        }
        .onChange(of: soruNo) { _ in
            kalanSure = 20
            baslatTimer()
        }
    }
    
    private func baslatTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if kalanSure > 0 {
                kalanSure -= 1
            } else {
                timer?.invalidate()
                if soruNo < sorular.count - 1 {
                    soruNo += 1
                    secilen_cevap = nil
                } else {
                    quizBitti = true
                }
            }
        }
    }
    
    private func baslatToplamTimer() {
        toplamTimer?.invalidate()
        
        toplamTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if toplamKalanSure > 0 {
                toplamKalanSure -= 1
            } else {
                toplamTimer?.invalidate()
                timer?.invalidate()
                quizBitti = true
            }
        }
    }
    
    private func soruYukle() {
        if let url = Bundle.main.url(forResource: "sorular", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let questionData = try decoder.decode(QuestionData.self, from: data)
                sorular = questionData.sorular
                baslatTimer()
                baslatToplamTimer()
            } catch {
                print("JSON yüklenirken hata oluştu: \(error)")
            }
        }
    }
    
    private func cevapKontrol(_ secilenIndex: Int) {
        if secilenIndex == sorular[soruNo].dogruCevap {
            skor += 1
        }
        
        timer?.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if soruNo < sorular.count - 1 {
                soruNo += 1
                secilen_cevap = nil
            } else {
                toplamTimer?.invalidate()
                quizBitti = true
            }
        }
    }
}

// JSON yapısı için model
struct QuestionData: Codable {
    let sorular: [Question]
}
