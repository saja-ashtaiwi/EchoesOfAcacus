import Foundation
import AVFoundation
import SwiftUI
import Combine

@MainActor // <--- THIS IS THE MAGIC WORD!
class AudioManager: ObservableObject {
    // This makes it a "Singleton", meaning the same audio manager is shared everywhere
    static let shared = AudioManager()
    
    var bgmPlayer: AVAudioPlayer?
    var sfxPlayer: AVAudioPlayer?
    var walkingPlayer: AVAudioPlayer? // Separated so walking doesn't cancel out other effects!
    
    // Changing this value will automatically adjust the music volume!
    @Published var bgmVolume: Float = 0.5 {
        didSet {
            bgmPlayer?.volume = bgmVolume
        }
    }
    
    init() {
        // --- APPLE HIG COMPLIANCE ---
        // .ambient respects the silent switch and mixes politely with other apps
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // --- 1. BACKGROUND MUSIC ---
    func playBackgroundMusic(filename: String) {
        guard let url = getURL(for: filename) else {
            print("Could not find BGM file: \(filename)")
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1 // -1 means loop FOREVER
            bgmPlayer?.volume = bgmVolume
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
        } catch {
            print("Could not create BGM player: \(error)")
        }
    }
    
    // --- 2. SOUND EFFECTS (Chimes, Dragging) ---
    func playSFX(filename: String) {
        guard let url = getURL(for: filename) else {
            print("Could not find SFX file: \(filename)")
            return
        }
        
        do {
            // Stop the previous SFX so we don't get messy overlapping echoes
            sfxPlayer?.stop()
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.play()
        } catch {
            print("Could not create SFX player: \(error)")
        }
    }
    
    // --- 3. WALKING SOUNDS ---
    func startWalkingSound(filename: String) {
        // Prevent stuttering by ignoring the command if it's already playing
        if walkingPlayer?.isPlaying == true { return }
        
        guard let url = getURL(for: filename) else { return }
        
        do {
            walkingPlayer = try AVAudioPlayer(contentsOf: url)
            walkingPlayer?.numberOfLoops = -1 // Loops while walking
            walkingPlayer?.play()
        } catch {
            print("Could not create walking player: \(error)")
        }
    }
    
    func stopWalkingSound() {
        walkingPlayer?.stop()
    }
    
    /// --- HELPER FUNCTION ---
    private func getURL(for filename: String) -> URL? {
        // 1. Strip away whatever extension the game asks for (like .wav)
        let name = (filename as NSString).deletingPathExtension
        
        // 2. Force the app to ONLY look for your new .mp3 files
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            return url
        }
        
        return nil
    }
}
