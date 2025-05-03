
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isToggled = true
    @State private var selectedCurrency: TransactionCurrency = .usd
    @State private var showCurrencyPicker = false

    init() {
           if let savedValue = UserDefaults.standard.string(forKey: "SelectedCurrency"),
              let savedCurrency = TransactionCurrency(rawValue: savedValue) {
               _selectedCurrency = State(initialValue: savedCurrency)
           }
        
      
            if let savedValue = UserDefaults.standard.object(forKey: "AlwaysAddPhotos") as? Bool {
                _isToggled = State(initialValue: savedValue)
            } else {
                _isToggled = State(initialValue: true)
            }
        
    }
    
    var body: some View {
        ZStack {
            Image("bfwefewwg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            Color.white
                .opacity(0.6) // налаштовуємо прозорість
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
                    Text("Settings")
                        .font(.custom("CabinetGrotesk-Variable", size: 24))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1) // тонка лінія
                    .edgesIgnoringSafeArea(.horizontal)
                
                
                
                VStack(spacing: 16) {
                            // Перша кнопка
        
                            Button(action: {
                                print("перед зміною: \(isToggled)")
                                isToggled.toggle()
                                print("після зміни: \(isToggled)")
                                UserDefaults.standard.set(isToggled, forKey: "AlwaysAddPhotos")
                                print("Збережено: \(isToggled)")
                                
                            }) {
                                HStack {
                                    Text("Always add photos")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                    Spacer()
                                    Image(isToggled ? "Toggle" : "Toggle-3")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 30)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 20)
                                        
                                }
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                    
                    
                    
                            // Друга кнопка
                            Button(action: {
                                
                                showCurrencyPicker = true
                            }) {
                                HStack {
                                    Text("Currency")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                    Spacer()
                                    
                                    Text(selectedCurrency.symbol)
                                        .foregroundColor(.black)
                                        .padding(.leading, 5)
                                    
                                    Image("23432CaretLeft")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 20)
                                }
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                    
                    
                    
                    
                    
                            // Третя кнопка
                            Button(action: {}) {
                                HStack {
                                    Text("Manage categories")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                    Spacer()
                                    Image("23432CaretLeft")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 20)
                                }
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            // Четверта кнопка
                            Button(action: {}) {
                                HStack {
                                    Text("Privacy Policy")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                    Spacer()
                                    Image("23432CaretLeft")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 20)
                                }
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                
                Spacer()
                
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
