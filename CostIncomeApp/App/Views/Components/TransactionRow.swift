#if canImport(UIKit)
import UIKit
#endif
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @StateObject private var currencyService = CurrencyService.shared
    
    var body: some View {
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
                        .font(.custom("Rubik-Regular", size: 16))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(currencyService.formatAmount(transaction.amount))
                    .foregroundColor(.black)
                Text(formatDate(transaction.date))
                    .font(.custom("Rubik-Regular", size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        //.background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
    
    #if canImport(UIKit)
    private func loadImage(_ imageName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    #endif
} 
