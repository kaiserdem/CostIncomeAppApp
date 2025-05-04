
import SwiftUI
import UIKit

struct EditCategoryPopup: View {
    @Binding var isPresented: Bool
    @Binding var categories: [String]
    let oldCategory: String
    @State private var newCategoryName: String
    
    init(isPresented: Binding<Bool>, categories: Binding<[String]>, oldCategory: String) {
        self._isPresented = isPresented
        self._categories = categories
        self.oldCategory = oldCategory
        self._newCategoryName = State(initialValue: oldCategory)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    
                    Text("Enter a new category\n name")
                        .font(.custom("Rubik-Regular", size: 20))
                        .multilineTextAlignment(.center)
                        .padding(.top, -40)
                    
                    TextField("Enter a name", text: $newCategoryName)
                        .font(.custom("Rubik-Regular", size: 16))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 20)
                        .padding(.horizontal, 30)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Button(action: {
                        if !newCategoryName.isEmpty {
                            if let index = categories.firstIndex(of: oldCategory) {
                                categories[index] = newCategoryName
                                UserDefaults.standard.set(categories, forKey: "categories")
                            }
                            isPresented = false
                        }
                    }) {
                        Text("Edit")
                            .font(.custom("Rubik-Regular", size: 16))
                            .foregroundColor(.purple)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.purple, lineWidth: 1))
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
                .frame(width: geometry.size.width - 50)
                .background(Color.white)
                .cornerRadius(15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

