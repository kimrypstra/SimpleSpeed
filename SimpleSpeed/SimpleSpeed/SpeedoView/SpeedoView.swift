import SwiftUI

struct SpeedoView: View {
    
    @StateObject private var viewModel = SpeedoViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.speed)
                .font(Font.system(size: 128.0, weight: .black, design: .serif))
                .foregroundStyle(Color.white)
            
            if let units = viewModel.units {
                Text(units)
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Color.white)
            }
            
            if viewModel.showTrip {
                TripsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SpeedoView()
}
