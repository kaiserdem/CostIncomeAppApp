import SwiftUI


struct ManageCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var categories: [String] = []
    @State private var editingCategory: String?
    @State private var showingEditPopup = false
    @State private var newCategoryName = ""
    
    init() {
        _categories = State(initialValue: UserDefaults.standard.stringArray(forKey: "categories") ?? [])
    }
    
    var body: some View {
        ZStack {
            Image("bfwefewwg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            Color.white
                .opacity(0.6) 
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("CaretLeft")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                    
                    Spacer()
                    Text("Manage Categories")
                        .font(.custom("CabinetGrotesk-Variable", size: 24))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            ZStack {
                                GeometryReader { geometry in
                                    HStack {
                                        Text(category)
                                            .font(.custom("CabinetGrotesk-Variable", size: 16))
                                            .foregroundColor(.black)
                                            .frame(width: geometry.size.width - 170, height: 20)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                        
                                        Button(action: {
                                            editingCategory = category
                                            showingEditPopup = true
                                        }) {
                                            Image("Frame 553")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 45, height: 45)
                                        }
                                        
                                        Button(action: {
                                            if let index = categories.firstIndex(of: category) {
                                                categories.remove(at: index)
                                                UserDefaults.standard.set(categories, forKey: "categories")
                                            }
                                        }) {
                                            Image("Frame 554")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 45, height: 45)
                                        }
                                    }
                                    .padding(.trailing, 28)
                                }
                                .frame(height: 45)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .overlay(
            Group {
                if showingEditPopup, let category = editingCategory {
                    EditCategoryPopup(
                        isPresented: $showingEditPopup,
                        categories: $categories,
                        oldCategory: category
                    )
                }
            }
        )
    }
}
