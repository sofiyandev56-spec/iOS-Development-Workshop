import SwiftUI
import Combine

/// Type of concurrency task packet
public enum ConcurrencyTaskType: String, CaseIterable {
    case uiRender = "SwiftUI 120Hz Render"
    case jsonParse = "Background JSON Parse"
    case neuralInference = "ANE Matrix Compute"
    case gestureEvent = "Duo Touch Injection"
    
    public var targetActor: String {
        switch self {
        case .uiRender, .gestureEvent: return "MainActor (Right Screen)"
        case .jsonParse, .neuralInference: return "Background Actor (Left Screen)"
        }
    }
    
    public var icon: String {
        switch self {
        case .uiRender: return "sparkles.tv.fill"
        case .jsonParse: return "arrow.triangle.2.circlepath"
        case .neuralInference: return "brain.head.profile"
        case .gestureEvent: return "hand.tap.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .uiRender: return ArcadeTheme.arcadeCrimson
        case .jsonParse: return ArcadeTheme.cupertinoCyan
        case .neuralInference: return ArcadeTheme.siliconGreen
        case .gestureEvent: return ArcadeTheme.swiftOrange
        }
    }
}

/// A live active packet in flight
public struct InFlightPacket: Identifiable {
    public let id = UUID()
    public let type: ConcurrencyTaskType
    public var yOffset: CGFloat
    public var currentSide: ScreenSide // .left or .right
    
    public enum ScreenSide {
        case left
        case right
    }
}

/// Hinge Hack Concurrency Engine
public final class HingeHackEngine: ObservableObject {
    @Published public var score: Int = 0
    @Published public var fpsMeter: Double = 120.0
    @Published public var dataRacesAvoided: Int = 0
    @Published public var droppedFrames: Int = 0
    @Published public var isPlaying: Bool = true
    @Published public var playfieldHeight: CGFloat = 460.0
    @Published public var currentPackets: [InFlightPacket] = []
    @Published public var statusAlert: String = "Route tasks: Background tasks -> LEFT, UI tasks -> RIGHT!"
    @Published public var statusColor: Color = ArcadeTheme.cupertinoCyan
    
    private var gameLoopTimer: AnyCancellable?
    private var spawnTimer: AnyCancellable?
    
    public init() {
        start()
    }
    
    public func start() {
        score = 0
        fpsMeter = 120.0
        dataRacesAvoided = 0
        droppedFrames = 0
        isPlaying = true
        currentPackets.removeAll()
        statusAlert = "System online: iPhone Duo High-Speed Hinge Bus Active"
        statusColor = ArcadeTheme.siliconGreen
        
        startGameLoop()
    }
    
    private func startGameLoop() {
        gameLoopTimer?.cancel()
        spawnTimer?.cancel()
        
        // Spawn packet every 1.5 seconds
        spawnTimer = Timer.publish(every: 1.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.isPlaying else { return }
                self.spawnPacket()
            }
        
        // Frame update loop (60 ticks/sec)
        gameLoopTimer = Timer.publish(every: 0.033, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.isPlaying else { return }
                self.tick()
            }
    }
    
    private func spawnPacket() {
        guard let randomType = ConcurrencyTaskType.allCases.randomElement() else { return }
        let initialSide: InFlightPacket.ScreenSide = Bool.random() ? .left : .right
        let packet = InFlightPacket(type: randomType, yOffset: 10, currentSide: initialSide)
        currentPackets.append(packet)
    }
    
    private func tick() {
        for index in currentPackets.indices {
            currentPackets[index].yOffset += 4.5
        }
        
        // Check packets reaching bottom receiver gateway
        let threshold = max(280.0, playfieldHeight - 75.0)
        if let first = currentPackets.first, first.yOffset >= threshold {
            evaluatePacket(first)
            currentPackets.removeFirst()
        }
    }
    
    /// User flips packet across the Hinge Bridge
    public func toggleSide(for packetID: UUID) {
        if let idx = currentPackets.firstIndex(where: { $0.id == packetID }) {
            currentPackets[idx].currentSide = (currentPackets[idx].currentSide == .left) ? .right : .left
            SoundEngine.shared.playTap()
        }
    }
    
    private func evaluatePacket(_ packet: InFlightPacket) {
        let isCorrect: Bool
        if packet.currentSide == .left {
            // Left is Background Actor
            isCorrect = (packet.type == .jsonParse || packet.type == .neuralInference)
        } else {
            // Right is MainActor UI
            isCorrect = (packet.type == .uiRender || packet.type == .gestureEvent)
        }
        
        if isCorrect {
            score += 150
            dataRacesAvoided += 1
            ArcadeProfileManager.shared.addXP(25)
            SoundEngine.shared.playSuccess()
            statusAlert = "Thread Safe! \(packet.type.rawValue) isolated correctly."
            statusColor = ArcadeTheme.siliconGreen
        } else {
            droppedFrames += 1
            fpsMeter = max(45.0, fpsMeter - 12.0)
            SoundEngine.shared.playError()
            statusAlert = "WARNING: Concurrency bottleneck! \(packet.type.rawValue) in wrong domain!"
            statusColor = ArcadeTheme.arcadeCrimson
            
            AITutorEngine.shared.diagnoseMistake(
                concept: packet.type.rawValue,
                selectedAnswer: packet.currentSide == .left ? "Background Actor" : "MainActor",
                correctAnswer: packet.type.targetActor
            )
        }
        
        if score > ArcadeProfileManager.shared.hingeHackHighScore {
            ArcadeProfileManager.shared.hingeHackHighScore = score
        }
    }
}

/// Hinge Hack Mini-Game View
public struct HingeHackView: View {
    @StateObject private var engine = HingeHackEngine()
    @ObservedObject private var foldableManager = FoldableDeviceManager.shared
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Active Playfield
                ZStack {
                    // Dual Display Background Panels
                    HStack(spacing: 0) {
                        // Left Panel: Background Actor Domain
                        VStack {
                            Label("BACKGROUND ACTOR POOL", systemImage: "cpu.fill")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(ArcadeTheme.cupertinoCyan)
                                .padding(.top, 10)
                            
                            Text("JSON • CoreML • Storage")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(ArcadeTheme.cupertinoCyan.opacity(0.04))
                        
                        // Center Physical Hinge Crease
                        HingeDividerView(creaseWidth: foldableManager.creaseWidth)
                        
                        // Right Panel: MainActor UI Domain
                        VStack {
                            Label("MAINACTOR UI DOMAIN", systemImage: "sparkles.tv.fill")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(ArcadeTheme.arcadeCrimson)
                                .padding(.top, 10)
                            
                            Text("SwiftUI • 120Hz ProMotion • Gestures")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(ArcadeTheme.arcadeCrimson.opacity(0.04))
                    }
                    
                    // In-Flight Packets Flowing Down
                    GeometryReader { geo in
                        ZStack(alignment: .bottom) {
                            // Bottom Receiver Gateways
                            HStack(spacing: 0) {
                                // Left Gateway
                                VStack(spacing: 4) {
                                    Image(systemName: "arrow.down.to.line.compact")
                                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                                    Text("ACTOR POOL")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(ArcadeTheme.cupertinoCyan.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ArcadeTheme.cupertinoCyan.opacity(0.4), lineWidth: 1)
                                )
                                .padding(.horizontal, 12)
                                .padding(.bottom, 6)
                                
                                // Right Gateway
                                VStack(spacing: 4) {
                                    Image(systemName: "sparkles.tv.fill")
                                        .foregroundStyle(ArcadeTheme.arcadeCrimson)
                                    Text("120Hz MAIN")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundStyle(ArcadeTheme.arcadeCrimson)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(ArcadeTheme.arcadeCrimson.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ArcadeTheme.arcadeCrimson.opacity(0.4), lineWidth: 1)
                                )
                                .padding(.horizontal, 12)
                                .padding(.bottom, 6)
                            }
                            
                            // Live In-Flight Packets
                            ForEach(engine.currentPackets) { packet in
                                let xPos: CGFloat = packet.currentSide == .left
                                    ? (geo.size.width * 0.25)
                                    : (geo.size.width * 0.75)
                                
                                Button {
                                    engine.toggleSide(for: packet.id)
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: packet.type.icon)
                                            .foregroundStyle(.white)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(packet.type.rawValue)
                                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                .foregroundStyle(.white)
                                            Text("Tap to route across Hinge ↔")
                                                .font(.system(size: 8))
                                                .foregroundStyle(.white.opacity(0.75))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)
                                    .background(packet.type.color.opacity(0.92))
                                    .clipShape(Capsule())
                                    .neonGlow(color: packet.type.color, radius: 10)
                                }
                                .position(x: xPos, y: packet.yOffset)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: packet.currentSide)
                            }
                        }
                        .onAppear {
                            engine.playfieldHeight = geo.size.height
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                // Bottom Telemetry & Foldable Posture Bar
                bottomTelemetryBar
            }
        }
    }
    
    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("HINGE HACK")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundStyle(ArcadeTheme.arcadeGradient)
                Text("iPhone Duo Concurrency Balancer")
                    .font(.system(size: 9))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Score Display
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(ArcadeTheme.liquidGold)
                Text("\(engine.score)")
                    .font(.system(.headline, design: .monospaced, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .liquidGlassCard(cornerRadius: 14, tint: ArcadeTheme.liquidGold)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Bottom Telemetry Bar
    private var bottomTelemetryBar: some View {
        VStack(spacing: 8) {
            // Status alert banner
            Text(engine.statusAlert)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(engine.statusColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(engine.statusColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack(spacing: 16) {
                // FPS Meter
                HStack(spacing: 4) {
                    Image(systemName: "speedometer")
                        .foregroundStyle(engine.fpsMeter > 100 ? ArcadeTheme.siliconGreen : ArcadeTheme.arcadeCrimson)
                    Text("\(Int(engine.fpsMeter)) FPS")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
                
                // Data races eliminated
                HStack(spacing: 4) {
                    Image(systemName: "shield.lefthalf.filled")
                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                    Text("\(engine.dataRacesAvoided) Safe")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Dynamic Hinge Angle Readout
                HStack(spacing: 4) {
                    Image(systemName: foldableManager.currentPosture.iconName)
                        .foregroundStyle(ArcadeTheme.swiftOrange)
                    Text("\(Int(foldableManager.hingeAngle))° Hinge")
                        .font(.system(.caption, design: .monospaced, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
    }
}

