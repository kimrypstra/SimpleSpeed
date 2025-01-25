import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text(viewModel.speed)
                    .font(Font.system(size: 128.0, weight: .black, design: .serif))
                    .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: viewModel.settingsTapped, label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0) // image size
                    .frame(width: 50.0, height: 50.0) // tap target
                    .opacity(viewModel.shouldDimControls ? 0.1 : 1.0)
                    .tint(Color.white)
            })
        }
        .padding()
        .background(Color.black)
        .sheet(isPresented: $viewModel.shouldShowSettings) {
            SettingsView()
        }
    }
}

#Preview {
    MainView()
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
        }
    }
}
