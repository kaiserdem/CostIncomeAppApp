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
        let formattedAmount = amount.truncatingRemainder(dividingBy: 1) == 0 ? 
            String(format: "%.0f", amount) : 
            String(format: "%.2f", amount)
        return "\(selectedCurrency.symbol) \(formattedAmount)"
    }
} 