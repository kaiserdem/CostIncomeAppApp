import SwiftUI
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactionManager = TransactionManager()
    @Published var showingAddTransaction = false
    @Published var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @Published var showSettings = false
    @Published var showAddCategoryPopup = false
    @Published var newCategoryName: String = ""
    @Published var categories: [String] = UserDefaults.standard.stringArray(forKey: "categories") ?? []
    
    let types: [TransactionType] = [.costs, .income]
    let defaultCategories = ["Food", "Home and Life", "Health", "Entertainment", "Other"]
    
    var categorySums: [String: Double] {
        var dict: [String: Double] = [:]
        for cat in categories {
            dict[cat] = transactionManager.transactions.filter { $0.type == .costs && $0.category == cat }.reduce(0) { $0 + $1.amount }
        }
        return dict
    }
    
    func updateCategories() {
        let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
        categories = defaultCategories + savedCategories.filter { !defaultCategories.contains($0) }
    }
    
    func addCategory(_ name: String) {
        categories.append(name)
        UserDefaults.standard.set(categories, forKey: "categories")
    }
    
    func filteredTransactions() -> [Transaction] {
        transactionManager.transactions.filter { $0.type == types[selectedTypeIndex] }
    }
    
    func balanceString(for type: TransactionType) -> String {
        let balance = transactionManager.transactions.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: balance)) ?? "$ 0,00"
    }
} 