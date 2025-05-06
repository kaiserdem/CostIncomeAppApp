#if canImport(UIKit)
import UIKit
#endif
import SwiftUI
import Combine
import AVFoundation

#if canImport(UIKit)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    var onImageSaved: ((String) -> Void)?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .fullScreen
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                let imageName = saveImage(image)
                parent.onImageSaved?(imageName)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func saveImage(_ image: UIImage) -> String {
            guard let data = image.jpegData(compressionQuality: 0.8) else { return "" }
            let imageName = "\(UUID().uuidString).jpg"
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
            return imageName
        }
        
        private func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
}
#endif


struct TransactionListView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @StateObject private var currencyService = CurrencyService.shared
    @State private var showingAddTransaction = false
    @State private var selectedTypeIndex: Int = 0 // 0 - costs, 1 - income
    @State private var showSettings = false
    @State private var showAddCategoryPopup = false
    @State private var newCategoryName: String = ""
    @State private var showingImagePicker = false
    @State private var capturedImageName: String?
    @State private var showingAddNewItem = false
    #if canImport(UIKit)
    @State private var inputImage: UIImage?
    #endif
    
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
                    VStack(spacing: 10) {
                        // Кнопка завжди зверху
                        HStack(alignment: .center) {
                            Spacer()
                            
                            NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                                Button(action: {
                                    showSettings = true
                                }) {
                                    Image("settttttting")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                }
                            }
                            .padding(.trailing, 16)
                            .padding(.top, 12)
                        }
                        .frame(maxWidth: .infinity)
                        TabView(selection: $viewModel.selectedTypeIndex) {
                            ForEach(0..<viewModel.types.count, id: \ .self) { idx in
                                VStack(spacing: 12) {
                                    Text(viewModel.types[idx] == .costs ? "Costs" : "Income")
                                        .font(.custom("Rubik-Regular", size: 23))
                                        .foregroundColor(.white)
                                    Text(viewModel.balanceString(for: viewModel.types[idx]))
                                        .font(.custom("Rubik-Regular", size: 42))
                                        .foregroundColor(.white)
                                }
                                .tag(idx)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 120)
                        
                        CustomIndicator(selectedIndex: $viewModel.selectedTypeIndex)
                            .padding(.bottom, 8)
                        HStack {
                            // Блок категорій
                            CategoriesWrapView(viewModel: _viewModel, sums: categorySums, showAddCategoryPopup: $viewModel.showAddCategoryPopup, addCategory: {
                                viewModel.showAddCategoryPopup = true
                            })
                            .padding(.top, 8)
                            Spacer()
                        }
                        
                        NavigationLink(destination: HistoryView()) {
                            Image("showalllllll")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                                .padding(.horizontal)
                                .padding(.bottom, -10)
                        }
                        
                        VStack(spacing: 0) {
                            if viewModel.filteredTransactions().isEmpty {
                                Color.white
                                    .opacity(0.05)
                                    .frame(height: 400)
                                
                            } else {
                                ScrollView {
                                    VStack(spacing: 8) {
                                        ForEach(viewModel.filteredTransactions()) { transaction in
                                            HStack {
                                                if let imageName = transaction.imageName {
                                                    if let image = loadImage(imageName) {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 50, height: 50)
                                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    }
                                                } else {
                                                    Image(transaction.type == .income ? "income" : "cost")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                }
                                                
                                                VStack(alignment: .leading) {
                                                    Text(transaction.name)
                                                        .font(.custom("Rubik-Regular", size: 16))
                                                    if let category = transaction.category {
                                                        Text(category)
                                                            .font(.custom("Rubik-Regular", size: 12))
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                VStack(alignment: .trailing) {
                                                    Text(currencyService.formatAmount(transaction.amount))
                                                        .foregroundColor(.black)
                                                        .font(.custom("Rubik-Regular", size: 16))

                                                    Text(formatDate(transaction.date))
                                                        .font(.custom("Rubik-Regular", size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.vertical, 8)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                        }
                                        Color.white
                                            .opacity(0.05)
                                            .frame(height: 300)
                                    }
                                    .padding(.vertical, 8)
                                    .scrollIndicators(.hidden)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.bottom)
                        .padding(.bottom , -40)
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                    .scrollIndicators(.hidden)
                    .edgesIgnoringSafeArea(.bottom)
                }
                VStack {
                    
                    Spacer()
                    Spacer()
                    HStack(spacing: 8) {
                        Button(action: {
                            checkCameraPermission()
                        }) {
                            Image("Buuton")
                                .resizable()
                                .frame(width: 75, height: 78)
                        }
                        
                        Button(action: {
                            showingAddNewItem = true
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
                
                if showingAddNewItem {
                    if capturedImageName != nil {
                        AddNewItemView(isPresented: $showingAddNewItem, imageName: capturedImageName)
                            .onDisappear {
                                capturedImageName = nil
                            }
                    } else {
                        AddNewItemView(isPresented: $showingAddNewItem)
                    }
                }
            }
            .onAppear {
                viewModel.updateCategories()
            }
            #if canImport(UIKit)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, onImageSaved: { imageName in
                    capturedImageName = imageName
                    showingAddNewItem = true
                })
            }
            #endif
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
    
    private func checkCameraPermission() {
        #if canImport(UIKit)
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showingImagePicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        showingImagePicker = true
                    }
                }
            }
        case .denied, .restricted:
            // Показати повідомлення про те, що потрібен доступ до камери
            break
        @unknown default:
            break
        }
        #endif
    }
    
    private func loadImage(_ imageName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
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


struct CategoriesWrapView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @StateObject private var currencyService = CurrencyService.shared
    let sums: [String: Double]
    @Binding var showAddCategoryPopup: Bool
    var addCategory: () -> Void
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let minItemWidth: CGFloat = 120
        let spacing: CGFloat = 8
        let countInRow = 2
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
                                    .font(.custom("Rubik-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(currencyService.formatAmount(sums[item] ?? 0))
                                    .font(.custom("Rubik-Regular", size: 16))
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


