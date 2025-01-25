import SwiftUI

struct MainView: View {
    
    @State var shouldDimControls = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Root
                SpeedoView()
            }
            .overlay(alignment: .topTrailing) {
                NavigationLink(destination: {
                    SettingsView()
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0) // image size
                        .frame(width: 50.0, height: 50.0) // tap target
                        .opacity(shouldDimControls ? 0.1 : 1.0)
                        .tint(Color.white)
                        .alignmentGuide(.top, computeValue: { d in d[.bottom] })
                        .alignmentGuide(.leading, computeValue: { d in d[HorizontalAlignment.trailing] })
                })
            }
            .onAppear {
                shouldDimControls = false 
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        shouldDimControls = true
                    }
                }
            }
            .padding()
            .background(Color.black)
        }
    }
}

#Preview {
    MainView()
}
