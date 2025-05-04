import SwiftUI



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

struct AddNewItemView: View {
    @Binding var isPresented: Bool
    var imageName: String?
    @State private var name: String = ""
    @State private var amount: String = ""
    @State var state: AddItemState = .fields
    @State private var selectedCategory: String = ""
    @EnvironmentObject var viewModel: TransactionViewModel
    @FocusState private var isAmountFocused: Bool
    
    
    let withPhotos = UserDefaults.standard.object(forKey: "AlwaysAddPhotos") as? Bool
    
    
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
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isPresented = false
                            
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
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
                            .padding(.horizontal, 30)
                            .foregroundColor(.gray)
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        state = .camera
                                        
                                    }) {
                                        Text(category)
                                            .foregroundColor(Color(hex: "D44891"))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "D44891"), lineWidth: 1))
                                    }
                                    .padding(.horizontal, 30)
                                }
                            }
                        }
                        .padding(.bottom, imageName == nil ? 0 : 70)
                        
                        if imageName == nil {
                            Button(action: {
                                state = .camera
                                // remove image
                                // write item
                                
                            }) {
                                Text("Income")
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "8948FF"))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 28)
                                    .padding(.bottom, 80)
                                    .shadow(color: Color(hex: "14062C3D"), radius: 8, x: 0, y: 8)
                            }
                        }
                        case .camera:
                        VStack {
                            Button(action: {
                                
                            }) {
                                Image("dqwdqwedqwed1")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            }
                            .padding(.top, 12)
                            
                            Button(action: {
                                
                            }) {
                                Image("dqwdqwedqwed2")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            }
                            .padding(.top, 12)
                            
                            Button(action: {
                                
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
            print(imageName)
        }
    }
    
    
    func writeTramsaction() {
       
    }
}
