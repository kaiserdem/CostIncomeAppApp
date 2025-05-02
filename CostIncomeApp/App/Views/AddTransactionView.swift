import SwiftUI
import PhotosUI


struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var transactionManager: TransactionManager
    
    @State private var amount = ""
    @State private var type: TransactionType = .costs
    @State private var name = ""
    @State private var category = ""
    @State private var date = Date()
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageName: String?
    
    let costsCategories = ["Продукти", "Транспорт", "Розваги", "Комунальні", "Інше"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Сума") {
                    TextField("Сума", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section("Тип") {
                    Picker("Тип", selection: $type) {
                        Text("Витрата").tag(TransactionType.costs)
                        Text("Дохід").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Назва") {
                    TextField("Назва", text: $name)
                }
                
                if type == .costs {
                    Section("Категорія") {
                        Picker("Категорія", selection: $category) {
                            ForEach(costsCategories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                    }
                }
                
                Section("Дата") {
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                }
                
                Section("Зображення") {
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        if let imageName = imageName {
                            Text("Змінити зображення")
                        } else {
                            Text("Додати зображення")
                        }
                    }
                }
            }
            .navigationTitle("Нова транзакція")
            .navigationBarItems(
                leading: Button("Скасувати") {
                    dismiss()
                },
                trailing: Button("Зберегти") {
                    saveTransaction()
                }
                .disabled(amount.isEmpty || name.isEmpty || (type == .costs && category.isEmpty))
            )
            .onChange(of: selectedImage) { newValue in
                if let newValue {
                    Task {
                        await saveImage(newValue)
                    }
                }
            }
        }
    }
    
    private func saveImage(_ image: PhotosPickerItem) async {
        guard let data = try? await image.loadTransferable(type: Data.self) else { return }
        let fileName = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            imageName = fileName
        } catch {
            print("Помилка збереження зображення: \(error)")
        }
    }
    
    private func saveTransaction() {
        guard let amountDouble = Double(amount) else { return }
        
        let transaction = Transaction(
            amount: amountDouble,
            type: type,
            name: name,
            category: type == .costs ? category : nil,
            date: date,
            imageName: imageName
        )
        
        transactionManager.addTransaction(transaction)
        dismiss()
    }
} 
