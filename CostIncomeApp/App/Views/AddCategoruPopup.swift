
import SwiftUI

struct AddCategoryPopup: View {
    @Binding var isPresented: Bool
    @State private var newCategoryName = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all) // Ensure full screen coverage

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

                Text("What do you want to\nname the category?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top, -40)

                TextField("Enter a name", text: $newCategoryName)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button(action: {
                    if !newCategoryName.isEmpty {
                        var savedCategories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
                        savedCategories.append(newCategoryName)
                        UserDefaults.standard.set(savedCategories, forKey: "categories")
                        newCategoryName = ""
                        isPresented = false
                    }
                }) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.purple, lineWidth: 1))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .frame(width: UIScreen.main.bounds.width - 50)
            .background(Color.white)
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom) // Ignore keyboard safe area
    }
}
