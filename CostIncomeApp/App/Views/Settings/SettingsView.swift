#if canImport(UIKit)
import UIKit
#endif
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var currencyService = CurrencyService.shared
    
    @State private var isToggled = true
    @State private var showCurrencyPicker = false
    @State private var showCurrencySheet = false
    @State private var showManageCategoriesView = false
    @State private var privacyPolicyView = false

    init() {
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
                    Text("Settings")
                        .font(.custom("Rubik-Regular", size: 20))
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
                    VStack(spacing: 16) {
                        // Перша кнопка
                        HStack {
                            Text("Always add photos")
                                .foregroundColor(.black)
                                .font(.custom("Rubik-Regular", size: 16))
                                .lineLimit(nil)
                                .minimumScaleFactor(0.5)

                                .padding(.leading, 20)
                            Spacer()
                            Toggle("", isOn: $isToggled)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "8948FF")))
                                .padding(.trailing, 20)
                        }
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .onChange(of: isToggled) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "AlwaysAddPhotos")
                        }
                        
                        // Друга кнопка
                        Button(action: {
                            showCurrencySheet = true
                        }) {
                            HStack {
                                Text("Currency")
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                                    .font(.custom("Rubik-Regular", size: 16))

                                Spacer()
                                
                                Text(currencyService.selectedCurrency.rawValue)
                                    .foregroundColor(.gray)
                                    .font(.custom("Rubik-Regular", size: 15))

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
                                    Text("Manage Categories")
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                        .font(.custom("Rubik-Regular", size: 16))

                                        .lineLimit(nil)
                                        .minimumScaleFactor(0.5)
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
                        
                        // Четверта кнопка
                       
                        NavigationLink(destination: PrivacyPolicyView(), isActive: $privacyPolicyView) {
                            Button(action: {
                                privacyPolicyView = true
                            }) {
                                HStack {
                                    Text("Privacy Policy")
                                        .foregroundColor(.black)
                                        .font(.custom("Rubik-Regular", size: 16))

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
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $showCurrencySheet) {
            CurrencyPickerSheet(selectedCurrency: $currencyService.selectedCurrency, isPresented: $showCurrencySheet)
        }
    }
}

struct CurrencyPickerSheet: View {
    @Binding var selectedCurrency: TransactionCurrency
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Currency")
                    .font(.custom("Rubik-Regular", size: 20))
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
            
            Picker("Currency", selection: $selectedCurrency) {
                ForEach(TransactionCurrency.allCases, id: \.self) { currency in
                    HStack {
                        Text(currency.symbol)
                            .frame(width: 30)
                            .foregroundStyle(.purple)
                            .font(.custom("Rubik-Regular", size: 20))

                        Text(currency.rawValue)
                            .foregroundStyle(.purple)
                            .font(.custom("Rubik-Regular", size: 20))

                    }
                    .tag(currency)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            .onChange(of: selectedCurrency) { newValue in
                CurrencyService.shared.updateCurrency(newValue)
            }
            .tint(.purple)
        }
        .background(Color.red.opacity(0.05))
        .presentationDetents([.fraction(0.33)])
    }
}


