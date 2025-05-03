import SwiftUI

@main
struct CostIncomeAppApp: App {
    var body: some Scene {
        WindowGroup {
            TransactionListView()
                .environmentObject(TransactionViewModel())

        }
    }
}

