import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var categories: [String] = []
    @State private var editingCategory: String?
    @State private var showingEditPopup = false
    @State private var newCategoryName = ""
    
    var body: some View {
        ZStack {
            Image("bfwefewwg")
                .resizable()
                .aspectRatio(contentMode: .fill)
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
                    Text("History")
                        .font(.custom("Rubik-VariableFont_wght", size: 24))
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
                    VStack(spacing: 8) {
                        ForEach(viewModel.transactionManager.transactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .padding(.horizontal)
                        }
                       
                    }
                    .padding(.vertical, 8)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
