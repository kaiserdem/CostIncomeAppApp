import Foundation
import SwiftUI

class CurrencyService: ObservableObject {
    static let shared = CurrencyService()
    
    @Published var selectedCurrency: TransactionCurrency = .usd
    
    private init() {
        if let savedValue = UserDefaults.standard.string(forKey: "SelectedCurrency"),
           let savedCurrency = TransactionCurrency(rawValue: savedValue) {
            selectedCurrency = savedCurrency
        }
    }
    
    func updateCurrency(_ currency: TransactionCurrency) {
        selectedCurrency = currency
        UserDefaults.standard.set(currency.rawValue, forKey: "SelectedCurrency")
    }
    
    func formatAmount(_ amount: Double) -> String {
        return String(format: "%.2f \(selectedCurrency.symbol)", amount)
    }
} 