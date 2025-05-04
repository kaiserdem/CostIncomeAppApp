import SwiftUI
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactionManager = TransactionManager()
    @Published var showingAddTransaction = false
    @Published var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @Published var showSettings = false
    @Published var showAddCategoryPopup = false
    @Published var newCategoryName: String = ""
    @Published var categories: [String] = []
    
    let types: [TransactionType] = [.costs, .income]
    let defaultCategories = ["Home and Life", "Food", "Health", "Entertainment", "Transportation costs", "Other"]
    
    var categorySums: [String: Double] {
        var dict: [String: Double] = [:]
        for cat in categories {
            dict[cat] = transactionManager.transactions.filter { $0.type == .costs && $0.category == cat }.reduce(0) { $0 + $1.amount }
        }
        return dict
    }
    
    func updateCategories() {
        let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
        print("savedCategories (перед оновленням): \(savedCategories.count)")
        categories = defaultCategories + savedCategories.filter { !defaultCategories.contains($0) }
        print("allCategories (після оновлення): \(categories.count)")
    }
    
    func addCategory(_ name: String) {
        print("Кількість категорій перед додаванням: \(categories.count)")
        var cat = UserDefaults.standard.stringArray(forKey: "categories") ?? []
        cat.append(name)
        UserDefaults.standard.set(cat, forKey: "categories")
        print("Збережені категорії в UserDefaults: \(UserDefaults.standard.stringArray(forKey: "categories")?.count ?? 0)")
        updateCategories()
        print("Кількість категорій після додавання: \(categories.count)")
    }
    
    func filteredTransactions() -> [Transaction] {
        transactionManager.transactions.filter { $0.type == types[selectedTypeIndex] }
    }
    
    func balanceString(for type: TransactionType) -> String {
        let balance = transactionManager.transactions.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
        return CurrencyService.shared.formatAmount(balance)
    }
} 
