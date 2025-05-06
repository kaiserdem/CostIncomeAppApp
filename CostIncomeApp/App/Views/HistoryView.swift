#if canImport(UIKit)
import UIKit
#endif
import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TransactionViewModel
    @StateObject private var currencyService = CurrencyService.shared
    var isSE: Bool {
           return UIScreen.main.bounds.height < 700
       }
    
    var body: some View {
        ZStack {
            Image("bfwefewwg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                        .fill(Color.white.opacity(0.5))
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
                        .font(.custom("Rubik-Regular", size: 24))
                        .foregroundColor(.black)
                        .offset(x: -15)
                    
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
                    }
                    .padding(.vertical, 8)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
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
