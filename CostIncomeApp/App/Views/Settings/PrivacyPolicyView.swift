
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    let privacyText = """

    Introduction
    
    Welcome to Cost & income. We value your trust and are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.

    Information We Collect
    
    - Personal Information: When you register or use our services, we may collect your name, email address, phone number, and other contact details.
    - Financial Data: We may collect information related to your financial transactions, accounts, and related details to facilitate our services.
    - Device Information: We collect device details such as device type, operating system, and IP address for security and analytics.
    - Usage Data: We monitor your interactions within the app to improve user experience.

    How We Use Your Data
    
    - To provide, maintain, and improve our services
    - To authenticate your identity and secure your account
    - To communicate with you about updates or relevant information
    - To comply with legal obligations

    Sharing Your Data
    
    We do not sell or rent your personal data. We may share your information with:
    - Service Providers: Trusted partners that help us operate the app.
    - Legal Authorities: When required by law or to protect our rights.
    - Furthermore, we ensure all third parties comply with appropriate confidentiality and data security standards.

    Your Rights
    
    You have control over your data:
    - Access, update, or delete your personal information
    - Opt out of marketing communications
    - Request data portability or object to certain uses

    Data Security
    
    We implement industry-standard security measures to protect your information from unauthorized access, alteration, disclosure, or destruction.

    Changes to This Policy
    
    We may update this Privacy Policy periodically. Changes will be posted within the app, and the "Effective Date" will be revised accordingly.

    Contact Us
    
    If you have any questions or concerns regarding this Privacy Policy, please contact us at costincome@gmail.com.
    """

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
                // Header with back button and title
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
                        .font(.custom("Rubik-Regular", size: 24))
                        .foregroundColor(.black)
                        .offset(x: -15)


                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60)

                // Divider line
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)

                // Основний текст політики у ScrollView
                ScrollView {
                    Text(privacyText)
                        .padding()
                        .foregroundColor(.black)
                        .font(.custom("Rubik-Regular", size: 20))
                        .lineLimit(nil)
                }
                .cornerRadius(12)
                .scrollIndicators(.hidden)
                .padding()

                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
