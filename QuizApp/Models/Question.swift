import Foundation

struct Question: Codable, Identifiable {
    let id: Int
    let soru: String
    let secenekler: [String]
    let dogruCevap: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case soru
        case secenekler
        case dogruCevap = "dogru_cevap"
    }
} 
