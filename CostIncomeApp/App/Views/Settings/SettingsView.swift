import SwiftUI
import Foundation

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isToggled = true
    @State private var selectedCurrency: TransactionCurrency = .usd
    @State private var showCurrencyPicker = false
    @State private var showCurrencySheet = false
    @State private var showManageCategoriesView = false
    @State private var privacyPolicyView = false

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
                                showCurrencySheet = true
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
                    NavigationLink(destination: ManageCategoriesView(), isActive: $showManageCategoriesView) {
                        Button(action: {
                            showManageCategoriesView = true
                        }) {
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
                        .padding(.top, 12)
                        .padding(.trailing, 0)
                        
                    }
                       
                           
                            // Четверта кнопка
                    NavigationLink(destination: PrivacyPolicyView(), isActive: $privacyPolicyView) {
                        Button(action: {
                            privacyPolicyView = true
                        }) {
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
                        .padding(.top, 12)
                        .padding(.trailing, 0)
                        
                    }
                        }
                        .padding()
                
                Spacer()
                
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showCurrencySheet) {
            CurrencyPickerSheet(selectedCurrency: $selectedCurrency, isPresented: $showCurrencySheet)
        }
    }
}

struct CurrencyPickerSheet: View {
    @Binding var selectedCurrency: TransactionCurrency
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
                        
            HStack {
                Spacer()

                
                Text("Currency")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .offset(x: 25)
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Пікер валют
            Picker("Currency", selection: $selectedCurrency) {
                ForEach(TransactionCurrency.allCases, id: \.self) { currency in
                    HStack {
                        Text(currency.symbol)
                            .frame(width: 30)
                            .foregroundStyle(.purple)
                        Text(currency.rawValue)
                            .foregroundStyle(.purple)
                    }
                    .tag(currency)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            .onChange(of: selectedCurrency) { newValue in
                UserDefaults.standard.set(newValue.rawValue, forKey: "SelectedCurrency")
            }
            .tint(.purple)
        }
        .background(Color.red.opacity(0.05)) // Світло-сірий фон
        .presentationDetents([.fraction(0.33)])
        //.presentationDragIndicator(.visible)
    }
}
