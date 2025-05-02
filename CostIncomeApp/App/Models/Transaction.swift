import Foundation

enum TransactionType: String, Codable {
    case income = "income"
    case costs = "costs"
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var type: TransactionType
    var name: String
    var category: String?
    var date: Date
    var imageName: String?
    
    init(id: UUID = UUID(), amount: Double, type: TransactionType, name: String, category: String? = nil, date: Date = Date(), imageName: String? = nil) {
        self.id = id
        self.amount = amount
        self.type = type
        self.name = name
        self.category = category
        self.date = date
        self.imageName = imageName
    }
} 
