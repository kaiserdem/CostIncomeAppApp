import Foundation

class TransactionManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private let saveKey = "transactions"
    
    init() {
        loadTransactions()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at: index)
            saveTransactions()
        }
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    func getBalance() -> Double {
        transactions.reduce(0) { result, transaction in
            result + (transaction.type == .income ? transaction.amount : -transaction.amount)
        }
    }
} 