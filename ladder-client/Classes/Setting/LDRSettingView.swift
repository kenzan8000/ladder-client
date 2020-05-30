import SwiftUI

struct LDRSettingView: View {
    @State private var urlDomain = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("URL")
            HStack {
                Text("https://")
                    .padding(6)
                    .background(Color.gray)
                TextField("", text: $urlDomain)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()
                .frame(height: 10)
            
            TextField("username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Button(
                    action: { },
                    label: { Text("Login") }
                )
                    .frame(width: 112)
                    .padding(8)
                    .border(Color.blue)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
    }
}

struct LDRSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRSettingView()
    }
}
