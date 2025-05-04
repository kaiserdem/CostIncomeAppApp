import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AddItemState: String, CaseIterable {
    case fields = "fields"
    case category = "category"
    case camera = "camera"
    
    var heightMultiplier: CGFloat {
            switch self {
            case .fields:
                return 0.60
            case .category:
                return 0.60
            case .camera:
                return 0.45
            }
        }
    
    var title: String {
            switch self {
            case .fields:
                return "Add Amount"
            case .category:
                return "Add Amount"
            case .camera:
                return "Add picture"
            }
        }

}

#if canImport(UIKit)
class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: AddNewItemView
    
    init(_ parent: AddNewItemView) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("1. ImagePickerController didFinishPickingMediaWithInfo")
        if let image = info[.originalImage] as? UIImage {
            print("2. Got image from picker")
            let imageName = saveImage(image)
            print("3. Saved image with name: \(imageName)")
            DispatchQueue.main.async {
                print("4. Inside DispatchQueue.main.async")
                self.parent.imageName = imageName
                print("5. Set imageName to parent: \(String(describing: self.parent.imageName))")
                self.parent.writeTramsaction(type: .costs)
                print("6. Called writeTransaction")
                self.parent.isPresented = false
                print("7. Set isPresented to false")
            }
        }
        print("8. Before picker.dismiss")
        picker.dismiss(animated: true)
        print("9. After picker.dismiss")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func saveImage(_ image: UIImage) -> String {
        print("A. Starting saveImage")
        guard let data = image.jpegData(compressionQuality: 0.8) else { 
            print("B. Failed to get jpeg data")
            return "" 
        }
        let imageName = "\(UUID().uuidString).jpg"
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)
        try? data.write(to: filename)
        print("C. Saved image to: \(filename.path)")
        return imageName
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension AddNewItemView {
    var coordinator: ImagePickerCoordinator {
        ImagePickerCoordinator(self)
    }
}
#endif


struct AddNewItemView: View {
    @Binding var isPresented: Bool
    @State var imageName: String?
    @State private var name: String = ""
    @State private var amount: String = ""
    @State var state: AddItemState = .fields
    @State private var selectedCategory: String = ""
    @EnvironmentObject var viewModel: TransactionViewModel
    @FocusState private var isAmountFocused: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    let withPhotos = UserDefaults.standard.object(forKey: "AlwaysAddPhotos") as? Bool ?? true
    
    init(isPresented: Binding<Bool>, imageName: String? = nil) {
        self._isPresented = isPresented
        self._imageName = State(initialValue: imageName)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        
                        Text(state.title)
                            .font(.custom("Rubik-Regular", size: 22))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.custom("Rubik-Regular", size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    switch state {
                    case .fields:
                        TextField("Enter amount", text: $amount)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                            .padding(.horizontal, 30)
                            .keyboardType(.decimalPad)
                            .focused($isAmountFocused)
                        
                        TextField("Enter name", text: $name)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                            .padding(.horizontal, 30)
                        
                        
                        Button(action: {
                                state = .category
                        }) {
                            Text("+ Add")
                                .foregroundColor(.white)
                                .font(.custom("Rubik-Regular", size: 20))
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "8948FF"))
                                .cornerRadius(15)
                                .padding(.horizontal, 28)
                                .shadow(color: Color(hex: "14062C3D"), radius: 8, x: 0, y: 8)
                        }
                        
                        Spacer()
                    case .category:
                        Text("Choose which category you want \n your costs to fall into")
                            .multilineTextAlignment(.center)
                            .font(.custom("Rubik-Regular", size: 20))
                            .padding(.horizontal, 30)
                            .foregroundColor(.gray)
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        categoryTapped()
                                        
                                    }) {
                                        Text(category)
                                            .foregroundColor(Color(hex: "D44891"))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .font(.custom("Rubik-Regular", size: 20))

                                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "D44891"), lineWidth: 1))
                                    }
                                    .padding(.horizontal, 30)
                                }
                            }
                        }
                        .padding(.bottom, imageName == nil ? 0 : 70)
                        
                        if imageName == nil {
                            Button(action: {
                                writeTramsaction(type: .income)
                            }) {
                                Text("Income")
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "8948FF"))
                                    .font(.custom("Rubik-Regular", size: 20))

                                    .cornerRadius(15)
                                    .padding(.horizontal, 28)
                                    .padding(.bottom, 80)
                                    .shadow(color: Color(hex: "14062C3D"), radius: 8, x: 0, y: 8)
                            }
                        }
                        
                        case .camera:
                        
                        VStack {
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                Image("dqwdqwedqwed1")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            }
                            .padding(.top, 12)
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                Image("dqwdqwedqwed2")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            }
                            .padding(.top, 12)
                            
                            Button(action: {
                                writeTramsaction(type: .costs)
                            }) {
                                Image("dqwdqwedqwed3")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            }
                            .padding(.top, 12)
                        }
                        .padding(.bottom, 60)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * (state.heightMultiplier))
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .padding(.bottom, -40)
            }
        }
        .onAppear {
            isAmountFocused = true
            print("imageName:\(String(describing: imageName))")
            print("withPhotos \(String(describing: withPhotos))")
        }
        #if canImport(UIKit)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage, onImageSaved: { savedImageName in
                imageName = savedImageName
                writeTramsaction(type: .costs)
                isPresented = false
            })
        }
        #endif
    }
    
    func categoryTapped() {
            
            if withPhotos {
                if imageName == nil {
                    state = .camera
                } else {
                    writeTramsaction(type: .costs)
                }
            } else {
                writeTramsaction(type: .costs)
            }
    }
    
    
    func writeTramsaction(type: TransactionType) {
        print("X. Starting writeTransaction")
        guard let amountDouble = Double(amount) else { 
            print("Y. Failed to convert amount to Double")
            return 
        }
        
        var transaction: Transaction?
        
        if type == .income {
            print("Z1. Creating income transaction")
            transaction = Transaction(
                amount: amountDouble,
                type: .income,
                name: name.isEmpty ? "Transaction" : name,
                date: Date())
        } else {
            print("Z2. Creating costs transaction with imageName: \(String(describing: imageName))")
            transaction = Transaction(
               amount: amountDouble,
               type: .costs,
               name: name.isEmpty ? "Transaction" : name,
               category: selectedCategory.isEmpty ? nil : selectedCategory,
               date: Date(),
               imageName: imageName)
        }
        
        print("W. Adding transaction to manager")
        viewModel.transactionManager.addTransaction(transaction!)
        print("V. Setting isPresented to false")
        isPresented = false
    }
}
