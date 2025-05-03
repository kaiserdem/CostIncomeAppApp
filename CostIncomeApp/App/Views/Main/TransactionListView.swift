import SwiftUI
import Combine

struct TransactionListView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showingAddTransaction = false
    @State private var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @State private var showSettings = false
    @State private var showAddCategoryPopup = false
    @State private var newCategoryName: String = ""
    
    let types: [TransactionType] = [.costs, .income]
    
    var categorySums: [String: Double] {
        var dict: [String: Double] = [:]
        for cat in viewModel.categories {
            dict[cat] = viewModel.transactionManager.transactions.filter { $0.type == .costs && $0.category == cat }.reduce(0) { $0 + $1.amount }
        }
        return dict
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bfwefewwg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Кнопка завжди зверху
                        HStack {
                            Spacer()

                            NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                                Button(action: {
                                    showSettings = true
                                }) {
                                    Image("settttttting")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                }
                                .padding(.top, 12)
                                .padding(.trailing, 16)
                            }
                        }
                        // Свайп тільки для назви і суми
                        TabView(selection: $viewModel.selectedTypeIndex) {
                            ForEach(0..<viewModel.types.count, id: \ .self) { idx in
                                VStack(spacing: 12) {
                                    Text(viewModel.types[idx] == .costs ? "Costs" : "Income")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Text(viewModel.balanceString(for: viewModel.types[idx]))
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .tag(idx)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 120)
                        
                        CustomIndicator(selectedIndex: $viewModel.selectedTypeIndex)
                            .padding(.bottom, 8)
                        
                        // Блок категорій
                        CategoriesWrapView(viewModel: _viewModel, sums: categorySums, showAddCategoryPopup: $viewModel.showAddCategoryPopup, addCategory: {
                            viewModel.showAddCategoryPopup = true
                        })
                        .padding(.top, 8)
                        
                        Button(action: { /* логіка для show all */ }) {
                            Image("showalllllll")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                                .padding(.horizontal)
                        }
                        
                        // Статичний список з перевіркою на пустоту
                        VStack(spacing: 0) {
                            if viewModel.filteredTransactions().isEmpty {
                                Color.white
                                    .frame(maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                                    .background(Color.white.opacity(0.8))
                                    .background(Color.white.opacity(0.7))
                                
                            } else {
                                ForEach(viewModel.filteredTransactions()) { transaction in
                                    TransactionRow(transaction: transaction)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.bottom, -46)
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                    .edgesIgnoringSafeArea(.bottom)
                }
                VStack {
                    
                    Spacer()
                    Spacer()
                    HStack(spacing: 8) {
                        Button(action: {
                            
                        }) {
                            Image("Buuton")
                                .resizable()
                                .frame(width: 75, height: 78)
                            
                        }
                        
                        Button(action: {
                            
                        }) {
                            Image("Buuton-2")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 100, height: 78)
                            
                        }
                        
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 0)
                }
              
                if viewModel.showAddCategoryPopup {
                    AddCategoryPopup(isPresented: $viewModel.showAddCategoryPopup)
                }
            }
            .onAppear {
                viewModel.updateCategories()
            }
        }
    }
    
    func updateCategories() {
        let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
        viewModel.categories = viewModel.defaultCategories + savedCategories.filter { !viewModel.defaultCategories.contains($0) }
    }
    
    func filteredTransactions() -> [Transaction] {
        viewModel.transactionManager.transactions.filter { $0.type == types[selectedTypeIndex] }
    }
    
    func balanceString(for type: TransactionType) -> String {
        let balance = viewModel.transactionManager.transactions.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: balance)) ?? "$ 0,00"
    }
}

// Додаємо розширення для заокруглення тільки верхніх кутів
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CustomIndicator: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        Image(selectedIndex == 1 ? "switch1" : "switch2")
            .resizable()
            .frame(width: 48, height: 24)
            .padding(8)
            .onTapGesture {
                withAnimation {
                    selectedIndex = selectedIndex == 0 ? 1 : 0
                }
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


struct CategoriesWrapView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    let sums: [String: Double]
    @Binding var showAddCategoryPopup: Bool
    var addCategory: () -> Void
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let minItemWidth: CGFloat = 120
        let spacing: CGFloat = 8
        let countInRow = max(1, Int((screenWidth + spacing) / (minItemWidth + spacing)))
        let allItems = ["+"] + viewModel.categories
        let rows = chunked(allItems, size: countInRow)
        
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(rows, id: \ .self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \ .self) { item in
                        if item == "+" {
                            Button(action: {
                                showAddCategoryPopup = true
                            }) {
                                Image("addCategory Name")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .padding(.horizontal, 6)
                                    .frame(height: 48)
                            }
                        } else {
                            HStack(spacing: 4) {
                                Text("\(item):")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("$\(String(format: "%.2f", sums[item] ?? 0))")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Динамічний chunked
    func chunked<T>(_ array: [T], size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
}


