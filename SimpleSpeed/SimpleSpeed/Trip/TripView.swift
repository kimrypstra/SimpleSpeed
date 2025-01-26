import SwiftUI

struct TripView: View {
    
    @StateObject var viewModel = TripViewModel()
    
    var body: some View {
        ScrollView([.horizontal]) {
            HStack {
                ForEach(viewModel.trips, id: \.id) { trip in
                    VStack(alignment: .center) {
                        if let distance = try? DistanceConverter.format(trip.current) {
                            Text(distance)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Color.white)
                        }
                        if let target = trip.target {
                            Text("of \(target)")
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                    .border(Color.white)
                    .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    TripView()
}
