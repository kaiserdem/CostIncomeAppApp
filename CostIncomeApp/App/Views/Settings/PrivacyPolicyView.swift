
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    

    init() {
        
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
                    Text("Privacy Policy")
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
                
                Spacer()
                Spacer()
                Spacer()
                
            }
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
            }
    }
}
