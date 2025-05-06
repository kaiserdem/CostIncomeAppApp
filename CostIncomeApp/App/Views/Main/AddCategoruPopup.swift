import SwiftUI

struct AddCategoryPopup: View {
    @Binding var isPresented: Bool
    @State private var newCategoryName = ""
    @EnvironmentObject var viewModel: TransactionViewModel

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
                    .font(.custom("Rubik-Regular", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.top, -30)

                TextField("Enter a name", text: $newCategoryName)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .autocapitalization(.words)

                Button(action: {
                    if !newCategoryName.isEmpty {
                        viewModel.addCategory(newCategoryName)
                        viewModel.updateCategories()
                        newCategoryName = ""
                        isPresented = false
                    }
                }) {
                    Text("Create")
                        .font(.custom("Rubik-Regular", size: 16))
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.purple, lineWidth: 1))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .frame(width: UIScreen.main.bounds.width - 50)
            .background(Color.white)
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom) // Ignore keyboard safe area
    }
}
