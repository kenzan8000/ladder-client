import SwiftUI

// MARK: - LDRPinView
struct LDRPinView: View {
    // MARK: - property

    @ObservedObject var pinViewModel: LDRPinViewModel
    
    // MARK: - view

    var body: some View {
        NavigationView {
            self.list()
        }
        .onAppear {
            self.pinViewModel.loadPinsFromLocalDB()
        }
        .sheet(isPresented: pinViewModel.isPresentingSafariView) {
            self.safariView()
        }
        .alert(isPresented: pinViewModel.isPresentingAlert) {
            var title = ""
            if let error = self.pinViewModel.error {
                title = error.localizedDescription
            }
            return Alert(title: Text(title))
        }
    }
    
    func loginButton() -> some View {
        Button(
            action: {
                self.pinViewModel.isPresentingLoginView.toggle()
            },
            label: {
                Image(systemName: "person.circle")
                .foregroundColor(.blue)
                Text("Login")
                .foregroundColor(.blue)
            }
        )
    }
    
    func reloadButton() -> some View {
        Button(
            action: {
                self.pinViewModel.loadPinsFromAPI()
            },
            label: {
                Text("Reload")
                .foregroundColor(.blue)
                Image(systemName: "arrow.clockwise")
                .foregroundColor(.blue)
            }
        )
    }
    
    func list() -> some View {
        List(pinViewModel.pins) { pin in
            LDRPinRow(title: pin.title) {
                self.pinViewModel.delete(pin: pin)
            }
        }
        .navigationBarTitle("\(pinViewModel.pins.count) Pins", displayMode: .large)
        .navigationBarItems(
            leading: loginButton(),
            trailing: reloadButton()
        )
        .sheet(isPresented: $pinViewModel.isPresentingLoginView) {
            LDRLoginView().environmentObject(LDRLoginViewModel())
        }
    }
    
    func safariView() -> some View {
        guard let url = self.pinViewModel.safariUrl else {
            return AnyView(EmptyView())
        }
        return AnyView(SafariView(url: url))
    }
}

// MARK: - LDRPinView_Previews
struct LDRPinView_Previews: PreviewProvider {
    static var previews: some View {
        LDRPinView(pinViewModel: LDRPinViewModel())
    }
}
