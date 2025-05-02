import SwiftUI
import UIKit

struct TransactionListView: View {
    @StateObject private var transactionManager = TransactionManager()
    @State private var showingAddTransaction = false
    @State private var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @State private var showSettings = false
    
    let types: [TransactionType] = [.costs, .income]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("bfwefewwg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    TabView(selection: $selectedTypeIndex) {
                        ForEach(0..<types.count, id: \ .self) { idx in
                            TopSummaryView(
                                selectedType: types[idx],
                                showSettings: $showSettings,
                                balance: getSelectedBalance(for: types[idx])
                            )
                            .tag(idx)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 250)
                    
                    CustomIndicator(selectedIndex: $selectedTypeIndex)
                        .padding(.bottom, 8)
                    
                    List {
                        Section("Транзакції") {
                            ForEach(filteredTransactions()) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { index in
                                    transactionManager.deleteTransaction(filteredTransactions()[index])
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(transactionManager: transactionManager)
            }
        }
    }
    
    func filteredTransactions() -> [Transaction] {
        transactionManager.transactions.filter { $0.type == types[selectedTypeIndex] }
    }
    
    func getSelectedBalance(for type: TransactionType) -> Double {
        transactionManager.transactions.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
    }
}

struct TopSummaryView: View {
    var selectedType: TransactionType
    @Binding var showSettings: Bool
    var balance: Double
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Spacer()
                    
                    Button(action: { showSettings = true }) {
                        Image("settttttting")
                            .frame(width: 32, height: 32)
                           
                    }
                }
                
                VStack(spacing: 12) {
                    Spacer(minLength: 0)
                    Text(selectedType == .costs ? "Costs" : "Income")
                        .foregroundColor(.white)
                    Text(balanceString)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
            }
        }
    }
    
    var balanceString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: balance)) ?? "$ 0,00"
    }
}

struct CustomIndicator: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        Image(selectedIndex == 1 ? "switch1" : "switch2")
            .resizable()
            .frame(width: 48, height: 24)
            .padding(8)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
            .onTapGesture {
                withAnimation {
                    selectedIndex = selectedIndex == 0 ? 1 : 0
                }
            }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Налаштування")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            if let imageName = transaction.imageName {
                if let image = loadImage(imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.headline)
                if let category = transaction.category {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f ₴", transaction.amount))
                    .foregroundColor(transaction.type == .income ? .green : .red)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
    
    private func loadImage(_ imageName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
} 
