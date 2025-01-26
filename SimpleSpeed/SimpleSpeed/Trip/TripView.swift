import SwiftUI

struct TripsView: View {
    
    @StateObject var viewModel = TripViewModel()
    
    var body: some View {
        ScrollView([.horizontal]) {
            HStack {
                ForEach(viewModel.trips, id: \.id) { trip in
                    TripView(trip: trip)
                        .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    TripView(trip: Trip(id: UUID(), current: 123.3, target: 140.6, targetType: .countUp, showTarget: true))
        .background(Color.black)
}

struct TripView: View {
    
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .center) {
            Text(trip.formatted ?? "?")
                .font(.system(.body, design: .serif))
                .foregroundStyle(Color.white)
            if let target = trip.target {
                Text("of \(target)")
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Color.white)
            }
        }
        .padding()
        .border(Color.white)
    }
}
