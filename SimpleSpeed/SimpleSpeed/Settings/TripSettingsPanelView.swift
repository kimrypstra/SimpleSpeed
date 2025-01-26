import SwiftUI

struct TripSettingsPanelView: View {
    
    let trip: Trip
    let onSetTargetType: (Trip.TripTargetType, Trip) -> ()
    let onSetTarget: (String, Trip) -> ()
    let onSetShowTarget: (Bool, Trip) -> ()
    
    @State var targetBinding: String
    @State var targetTypeBinding: Trip.TripTargetType
    @State var showTargetBinding: Bool
    
    init(
        trip: Trip,
        onSetTargetType: @escaping (Trip.TripTargetType, Trip) -> (),
        onSetTarget: @escaping (String, Trip) -> (),
        onSetShowTarget: @escaping (Bool, Trip) -> ()
    ) {
        self.trip = trip
        self.onSetTargetType = onSetTargetType
        self.onSetTarget = onSetTarget
        self.onSetShowTarget = onSetShowTarget
        
        self.targetBinding = trip.target.toStringZeroIsNone
        self.targetTypeBinding = trip.targetType
        self.showTargetBinding = trip.showTarget
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Picker(
                selection: $targetTypeBinding,
                content: {
                    ForEach(Trip.TripTargetType.allCases, id:\.displayTitle) { tripTargetType in
                        Text(tripTargetType.displayTitle).tag(tripTargetType)
                    }
                },
                label: { Text("Target type") }
            )
            .onChange(of: targetTypeBinding) {
                onSetTargetType(targetTypeBinding, trip)
            }
            HStack {
                Text("Target")
                Spacer()
                TextField(
                    text: $targetBinding,
                    label: { Text("Target") }
                )
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .onSubmit {
                    onSetTarget($targetBinding.wrappedValue, trip)
                }
            }
            Toggle(
                isOn: $showTargetBinding,
                label: {
                    Text("Show target")
                }
            )
            .onChange(of: showTargetBinding) {
                onSetShowTarget(showTargetBinding, trip)
            }
        }
    }
}

