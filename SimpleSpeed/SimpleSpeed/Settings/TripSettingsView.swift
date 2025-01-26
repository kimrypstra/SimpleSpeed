import SwiftUI

struct TripSettingsView: View {
    
    @StateObject var viewModel: TripSettingsViewModel
    
    init(viewModel: TripSettingsViewModel = .init()) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ForEach(viewModel.trips, id: \.hashValue) { trip in
            TripSettingsPanelView(
                trip: trip,
                onSetTargetType: viewModel.setTargetType,
                onSetTarget: viewModel.setTarget,
                onSetShowTarget: viewModel.setShowTarget
            )
        }
    }
}

#Preview {
    TripSettingsView(viewModel: TripSettingsViewModel(tripManager: MockTripManager()))
}
