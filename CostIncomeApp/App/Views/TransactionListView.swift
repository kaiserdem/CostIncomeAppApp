import SwiftUI
import UIKit

struct TransactionListView: View {
    @StateObject private var transactionManager = TransactionManager()
    @State private var showingAddTransaction = false
    @State private var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @State private var showSettings = false
    
    let types: [TransactionType] = [.costs, .income]
    let costsCategories = ["Food", "Homeву", "Heahвуцв", "Enr", "Otherвуцвуц", "andвуву", "2lth", "2Enter", "Other Other Other Other"]
    
    var categorySums: [String: Double] {
        var dict: [String: Double] = [:]
        for cat in costsCategories {
            dict[cat] = transactionManager.transactions.filter { $0.type == .costs && $0.category == cat }.reduce(0) { $0 + $1.amount }
        }
        return dict
    }
    
    var body: some View {
        NavigationView {
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
                            Button(action: { showSettings = true }) {
                                Image("settttttting")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                            }
                            .padding(.top, 12)
                            .padding(.trailing, 16)
                        }
                        // Свайп тільки для назви і суми
                        TabView(selection: $selectedTypeIndex) {
                            ForEach(0..<types.count, id: \ .self) { idx in
                                VStack(spacing: 12) {
                                    Text(types[idx] == .costs ? "Costs" : "Income")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Text(balanceString(for: types[idx]))
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .tag(idx)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 120)
                        
                        CustomIndicator(selectedIndex: $selectedTypeIndex)
                            .padding(.bottom, 8)
                        
                        // Блок категорій
                        CategoriesWrapView(categories: costsCategories, sums: categorySums, addCategory: { /* поки без логіки */ })
                            .padding(.top, 8)
                        
                        // Список транзакцій
                        VStack(spacing: 0) {
                            ForEach(filteredTransactions()) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                        }
                        .background(Color.clear)
                    }
                    .padding(.top, 24)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showingAddTransaction) {
                    AddTransactionView(transactionManager: transactionManager)
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { showingAddTransaction = true }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.purple)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(.trailing, 24)
                            .padding(.bottom, 32)
                        }
                    }
                )
            }
        }
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

// Кастомний wrap layout для категорій
struct CategoriesWrapView: View {
    let categories: [String]
    let sums: [String: Double]
    var addCategory: () -> Void

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let minItemWidth: CGFloat = 120
        let spacing: CGFloat = 8
        let countInRow = max(1, Int((screenWidth + spacing) / (minItemWidth + spacing)))
        let allItems = ["+"] + categories
        let rows = chunked(allItems, size: countInRow)
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        if item == "+" {
                            Button(action: addCategory) {
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
                                    .minimumScaleFactor(0.7)
                                Text("$\(String(format: "%.2f", sums[item] ?? 0))")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .minimumScaleFactor(0.7)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // Динамічний chunked
    func chunked<T>(_ array: [T], size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
}

// Гнучкий wrap layout для SwiftUI
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        FlowLayout(alignment: alignment, spacing: spacing, data: data, content: content)
    }
}

// FlowLayout — простий layout для wrap
struct FlowLayout<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let data: Data
    let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var rows: [[Data.Element]] = [[]]

        for item in data {
            let itemSize = CGSize(width: 120, height: 48) // приблизна ширина, можна підлаштувати
            if width + itemSize.width > geometry.size.width {
                width = 0
                rows.append([item])
            } else {
                rows[rows.count - 1].append(item)
            }
            width += itemSize.width + spacing
        }

        return VStack(alignment: alignment, spacing: spacing) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                            .frame(width: (geometry.size.width - CGFloat(row.count - 1) * spacing) / CGFloat(row.count))
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        totalHeight = proxy.size.height
                    }
            }
        )
    }
} 
