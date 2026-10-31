import SwiftUI
import Combine

@main
struct SwiftArcade_DuoApp: App {
    @StateObject private var foldableManager = FoldableDeviceManager.shared
    @StateObject private var profileManager = ArcadeProfileManager.shared
    @StateObject private var aiTutor = AITutorEngine.shared
    
    init() {
        // Initialize sound and haptics
        _ = SoundEngine.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(foldableManager)
                .environmentObject(profileManager)
                .environmentObject(aiTutor)
                .preferredColorScheme(.dark)
        }
    }
}

