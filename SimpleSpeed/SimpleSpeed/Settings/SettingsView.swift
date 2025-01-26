import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.booleanSettings, id: \.key) { setting in
                VStack(alignment: .leading) {
                    Toggle(
                        isOn: Binding(
                            get: {
                                setting.value ?? false
                            },
                            set: { newValue in
                                viewModel.settingChanged(setting: setting.copy(newValue: newValue))
                            }),
                        label: {
                            Text(setting.title)
                        }
                    )
                    if let description = setting.description {
                        Text(description)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            
            if viewModel.booleanSettings[.showTrips]?.value == true {
                Section(header: Text("Trips")) {
                    TripSettingsView()
                }
                .headerProminence(.increased)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
