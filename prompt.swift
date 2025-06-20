import Foundation
import SwiftUI
import AppKit

// ✅ User Input Model
struct UserInput: Codable, Identifiable {
    var id: UUID
    var Platform: String = "Xbox"
    var matchDate: Date = Date()
    var matchType: String = ""
    var playerID: String = ""
    var premadeSquad: Bool = false
    var teamComp: String = ""
    var rankBefore: String = ""
    var jumpMaster: Bool = false
    var fullSquad: Int = 1
    var damageDealt: Int = 0
    var kills: Int = 0
    var standing: String = ""
    var poi: String = ""
    var notes: String = ""


    init() {
        id = UUID()
    }
}

struct SearchableLabeledField: View {
    let label: String
    @Binding var text: String
    let options: [String]

    @State private var filteredOptions: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.red)
                .font(.system(size: 18, weight: .medium))

            TextField("", text: $text)
                .onChange(of: text) { newValue in
                    filteredOptions = options.filter {
                        $0.lowercased().hasPrefix(newValue.lowercased()) && !newValue.isEmpty
                    }
                }
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(8)
                .frame(height: 36)
                .background(Color(red: 0.94, green: 0.92, blue: 0.88))
                .cornerRadius(8)

            if !filteredOptions.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(filteredOptions, id: \.self) { suggestion in
                        Text(suggestion)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .onTapGesture {
                                text = suggestion
                                filteredOptions = []
                            }
                    }
                }
                .background(Color.white)
                .cornerRadius(6)
                .shadow(radius: 2)
            }
        }
    }
}


// ✅ Input Form View
struct InputFormView: View {
    @State private var userInput = UserInput()
    @State private var showAlert = false

    func saveUserInput() {
        DatabaseHelper.shared.insertGameData(userInput: userInput)
        showAlert = true
    }

    func resetForm() {
        userInput = UserInput()
    }
    
    let poiOptions = [
        "Skull Town", "Airbase", "Caustic Treatment", "Relay", "Hydro Dam", "Artillery", "Runoff", "The Cage", "Swamp", "Bunker", "The Pit", "Repulsor", "Spotted Lakes",
        "Skyhook", "Countdown", "Lava Fissure", "The Dome", "Harvester", "Sorting Factory", "Fragment East", "Fragment West", "Lava City", "Trials", "The Epicenter", "Lava Siphon", "Tree", "Overlook", "Climatizer", "Lava Fissure", "The Geyser", "The Dome", "The Tree",
        "Estates", "Labs", "Hammond Labs", "Bonsai Plaza", "Solar Array", "Hydroponics", "Rift", "Turbine", "Carrier", "Power Grid", "Docks", "Grow Towers", "Oasis", "Golden Gardens",
        "The Mill", "North Pad", "Command Center", "Fish Farms", "Checkpoint", "Launch Pad", "North Pad", "The Wall", "Echo HQ", "Devastated Coast", "Coastal Camp", "Barometer", "Ceto Station", "Cascade Falls", "Antenna", "Lightning Rod", "Wattson Town", "Cenote Cave", "Downed Beast", "Zeus Station", "Storm Catcher", "Gale Station", "The Promenade", "The Pylon",
        "Atmostation", "The Core", "Eternal Gardens", "Production Yard", "Terraformer", "Stasis Array", "Cultivation", "The Foundry", "Solar District", "Breaker Wharf", "The Divide", "Alpha Base", "Bionomics", "The Foundry", "The Divide", "Backup Atmo", "North Promenade", "Kinetic Battery"
]
    let playerOptions = ["Derptron4000", "kalgiri", "rjoon", "ArjunTD", "Bheodore", "MrBigsafe", "MrPandaBear28", "CTCW4"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0/255, green: 0/255, blue: 128/255)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        SectionView(title: "Before Matches") {
                            DatePicker("Match Date", selection: $userInput.matchDate, displayedComponents: .date)
                                .datePickerStyle(.field)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Platform")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))
                                
                                Picker("", selection: $userInput.Platform) {
                                    Text("PC").tag("PC")
                                    Text("Xbox").tag("Xbox")
                                    Text("PlayStation").tag("PlayStation")
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: 300)
                            }
                            Toggle("Premade Squad?", isOn: $userInput.premadeSquad)
                            SearchableLabeledField(label: "Who is Playing?", text: $userInput.playerID, options: playerOptions)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Match Type")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))

                                Picker("", selection: $userInput.matchType) {
                                    Text("Ranked").tag("ranked")
                                    Text("Norms").tag("norms")
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: 200)
                            }

                        }

                        SectionView(title: "Match Start Details") {
                            LabeledField(label: "Rank Before Match", text: $userInput.rankBefore)
                            Toggle("Jumpmaster?", isOn: $userInput.jumpMaster)
                            LabeledField(label: "Team Composition", text: $userInput.teamComp)
                            SearchableLabeledField(label: "Where we Droppin?", text: $userInput.poi, options: poiOptions)
                        }

                        SectionView(title: "Match Finish Details") {
                            Stepper("Active Members: \(userInput.fullSquad)", value: $userInput.fullSquad, in: 1...3)
                            LabeledField(
                                label: "Damage Dealt",
                                text: Binding(
                                    get: { String(userInput.damageDealt) },
                                    set: { userInput.damageDealt = Int($0) ?? 0 }
                                )
                            )
                            LabeledField(
                                label: "Kills",
                                text: Binding(
                                    get: { String(userInput.kills) },
                                    set: { userInput.kills = Int($0) ?? 0 }
                                )
                            )

                            LabeledField(label: "Placement", text: $userInput.standing)
                            LabeledField(label: "Notes", text: $userInput.notes)
                        }

                        Button("Save & Reset") {
                            saveUserInput()
                            resetForm()
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .alert("Data Saved!", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                    .padding(32)
                }
            }
        }
    }
}

// ✅ Styled Section Wrapper
struct SectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            content()
                .font(.system(size: 20))
        }
    }
}

// ✅ Consistent Input Field With Visible Label
struct LabeledField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))

            TextField("", text: $text)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(8)
                .frame(height: 36)
                .background(Color(red: 0.94, green: 0.92, blue: 0.88))
                .cornerRadius(8)
        }
    }
}

