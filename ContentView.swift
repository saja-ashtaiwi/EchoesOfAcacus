import SwiftUI

// 1. The Journal Entry Data
struct JournalEntry: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var date: String
    var imageName: String
}

struct ContentView: View {
    @State private var showMission: Bool = false
    @State private var journalEntries: [JournalEntry] = []
    
    // Audio connections
    @StateObject private var audioManager = AudioManager.shared
    @State private var showVolumeSlider: Bool = false // Controls if the mini-slider is visible
    
    var body: some View {
        ZStack {
            
            // ==========================================
            // LAYER 1: THE SCREENS (Menu or Mission)
            // ==========================================
            if showMission {
                // The actual game view
                MissionView(journalEntries: $journalEntries, showMission: $showMission)
                    .transition(.opacity)
            } else {
                // MAIN MENU
                ZStack {
                    // Background Image
                    Image("acacus_arch")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    // The Title Box and Button
                    VStack {
                        Spacer()
                        
                        // White Center Box
                        VStack(spacing: 8) {
                            Text("ECHOES OF ACACUS")
                                .font(.system(size: 40, weight: .heavy, design: .default))
                                .foregroundColor(.black)
                                .tracking(1.5)
                            
                            Text("Expedition to the Green Sahara")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .padding(.vertical, 40)
                        .padding(.horizontal, 60)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                        
                        Spacer()
                        
                        // Start Button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showMission = true
                            }
                        }) {
                            Text("START JOURNEY")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.1, green: 0.4, blue: 0.8))
                                .cornerRadius(30)
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 60)
                    }
                    
                    // The Expedition Journal
                    if !journalEntries.isEmpty {
                        VStack {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("DIGITAL DIARY")
                                        .font(.headline.bold())
                                        .foregroundColor(.primary)
                                    
                                    ForEach(journalEntries) { entry in
                                        HStack(spacing: 12) {
                                            Image(entry.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 45, height: 45)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            VStack(alignment: .leading) {
                                                Text(entry.title).font(.subheadline.bold())
                                                Text(entry.date).font(.caption).foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .padding(.leading, 30)
                                .padding(.bottom, 30)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            
            // ==========================================
            // LAYER 2: GLOBAL OVERLAY (Always on top!)
            // ==========================================
            VStack {
                HStack(alignment: .top) {
                    
                    // --- SLEEK VOLUME CONTROL ---
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                showVolumeSlider.toggle()
                            }
                        }) {
                            Image(systemName: audioManager.bgmVolume > 0 ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        
                        if showVolumeSlider {
                            Slider(value: $audioManager.bgmVolume, in: 0.0...1.0)
                                .accentColor(Color(red: 0.8, green: 0.4, blue: 0.2))
                                .frame(width: 130)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(20)
                                .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    
                    Spacer()
                }
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            AudioManager.shared.playBackgroundMusic(filename: "bg_music.mp3")
        }
    }
}

#Preview {
    ContentView()
}
