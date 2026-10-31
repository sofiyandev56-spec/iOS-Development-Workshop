import SwiftUI
import AudioToolbox
import AVFoundation

/// Sound & Haptics Engine for Arcade Polished Tactile Experience
public final class SoundEngine {
    public static let shared = SoundEngine()
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    private var isMuted: Bool = false
    
    private init() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationFeedback.prepare()
        selectionFeedback.prepare()
    }
    
    public func setMuted(_ muted: Bool) {
        self.isMuted = muted
    }
    
    // MARK: - Haptic and Audio Triggers
    
    public func playTap() {
        impactLight.impactOccurred()
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1104) // keyboard tap / light tick
    }
    
    public func playSelect() {
        selectionFeedback.selectionChanged()
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1157)
    }
    
    public func playSuccess() {
        notificationFeedback.notificationOccurred(.success)
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1025) // arcade positive tone
    }
    
    public func playError() {
        notificationFeedback.notificationOccurred(.error)
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1073) // low buzz / error
    }
    
    public func playCombo() {
        impactMedium.impactOccurred(intensity: 0.9)
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1054) // chime / powerup
    }
    
    public func playHingeSnap() {
        impactHeavy.impactOccurred(intensity: 1.0)
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1105) // mechanical snap
    }
    
    public func playLevelUp() {
        notificationFeedback.notificationOccurred(.success)
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1026) // fanfare
    }
}

