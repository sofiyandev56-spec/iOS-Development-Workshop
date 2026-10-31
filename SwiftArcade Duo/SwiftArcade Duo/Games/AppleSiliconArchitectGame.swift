import SwiftUI
import Combine

/// Hardware Subsystem in Apple Silicon
public enum SiliconBlock: String, CaseIterable, Identifiable {
    case cpu = "Performance Cores (CPU)"
    case gpu = "Metal 4 GPU Clusters"
    case ane = "Apple Neural Engine (ANE)"
    case enclave = "Secure Enclave & Crypto"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .cpu: return "cpu.fill"
        case .gpu: return "display"
        case .ane: return "brain.head.profile"
        case .enclave: return "lock.shield.fill"
        }
    }
    
    public var tint: Color {
        switch self {
        case .cpu: return ArcadeTheme.swiftOrange
        case .gpu: return ArcadeTheme.arcadeCrimson
        case .ane: return ArcadeTheme.siliconGreen
        case .enclave: return ArcadeTheme.cupertinoCyan
        }
    }
    
    public var specs: String {
        switch self {
        case .cpu: return "4.2 GHz • Low-Latency Branch"
        case .gpu: return "120 FPS • Hardware Mesh Shaders"
        case .ane: return "38 TOPS • FP16/INT8 Matrix"
        case .enclave: return "Hardware AES-256 • True RNG"
        }
    }
}

/// A Workload Task in Apple Silicon Architect
public struct SiliconWorkload: Identifiable {
    public let id = UUID()
    public let taskName: String
    public let detail: String
    public let targetBlock: SiliconBlock
    public let timeAllowed: Double = 5.0
}

/// Silicon Architect Game Engine
public final class SiliconArchitectEngine: ObservableObject {
    @Published public var score: Int = 0
    @Published public var combo: Int = 1
    @Published public var topsMeter: Double = 14.5
    @Published public var thermalPressure: Double = 0.2 // 0.0 cool to 1.0 thermal throttle
    @Published public var currentWorkloadIndex: Int = 0
    @Published public var isGameOver: Bool = false
    @Published public var bannerMessage: String = "Route incoming instructions to optimal silicon coprocessors!"
    @Published public var bannerColor: Color = ArcadeTheme.cupertinoCyan
    
    public let workloads: [SiliconWorkload] = [
        SiliconWorkload(
            taskName: "On-Device LLM Prompt Matrix Multiply",
            detail: "Execute 1024 token embedding tensor projection",
            targetBlock: .ane
        ),
        SiliconWorkload(
            taskName: "Liquid Glass Specular Ray-Marching",
            detail: "Render real-time blurred reflections across dual-OLED hinge",
            targetBlock: .gpu
        ),
        SiliconWorkload(
            taskName: "Swift ARC Retain Cycle Graph Traversal",
            detail: "Traverse non-isolated class reference dependencies",
            targetBlock: .cpu
        ),
        SiliconWorkload(
            taskName: "Face ID Biometric Hash Verification",
            detail: "Match 30,000 infrared dot projector depth mesh",
            targetBlock: .enclave
        ),
        SiliconWorkload(
            taskName: "CoreML Diffusion Image Synthesis Step",
            detail: "Run 16-bit float UNet systolic array pass",
            targetBlock: .ane
        ),
        SiliconWorkload(
            taskName: "Metal Shading Language (MSL) Vertex Compute",
            detail: "Rasterize 2.4 million polygons for 3D Arcade model",
            targetBlock: .gpu
        )
    ]
    
    public init() {}
    
    public var currentWorkload: SiliconWorkload {
        workloads[currentWorkloadIndex % workloads.count]
    }
    
    public func dispatch(to block: SiliconBlock) {
        guard !isGameOver else { return }
        
        let workload = currentWorkload
        if block == workload.targetBlock {
            // Correct block
            combo += 1
            let pts = 200 * combo
            score += pts
            topsMeter = min(38.0, topsMeter + 3.5)
            thermalPressure = max(0.1, thermalPressure - 0.05)
            ArcadeProfileManager.shared.addXP(pts / 3)
            
            SoundEngine.shared.playCombo()
            bannerMessage = "OPTIMAL ROUTING! +\(pts) XP • Bandwidth saturated at 800 GB/s"
            bannerColor = ArcadeTheme.siliconGreen
        } else {
            // Mismatch
            combo = 1
            thermalPressure = min(1.0, thermalPressure + 0.25)
            topsMeter = max(5.0, topsMeter - 4.0)
            SoundEngine.shared.playError()
            bannerMessage = "INEFFICIENT ROUTE! High thermal penalty dispatching \(workload.taskName) to \(block.rawValue)!"
            bannerColor = ArcadeTheme.arcadeCrimson
            
            AITutorEngine.shared.diagnoseMistake(
                concept: workload.taskName,
                selectedAnswer: block.rawValue,
                correctAnswer: workload.targetBlock.rawValue
            )
        }
        
        currentWorkloadIndex += 1
        if currentWorkloadIndex >= workloads.count * 2 {
            isGameOver = true
            SoundEngine.shared.playLevelUp()
            if score > ArcadeProfileManager.shared.siliconArchitectHighScore {
                ArcadeProfileManager.shared.siliconArchitectHighScore = score
            }
        }
    }
    
    public func restart() {
        score = 0
        combo = 1
        topsMeter = 14.5
        thermalPressure = 0.2
        currentWorkloadIndex = 0
        isGameOver = false
        bannerMessage = "Silicon Pipeline Ready"
        bannerColor = ArcadeTheme.cupertinoCyan
    }
}

/// Silicon Architect Mini-Game View
public struct AppleSiliconArchitectView: View {
    @StateObject private var engine = SiliconArchitectEngine()
    @ObservedObject private var foldableManager = FoldableDeviceManager.shared
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            if engine.isGameOver {
                VStack(spacing: 20) {
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                        .neonGlow(color: ArcadeTheme.siliconGreen, radius: 24)
                    
                    Text("Silicon Pipeline Mastered!")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text("Final Score: \(engine.score) pts")
                        .font(.system(.title2, design: .monospaced, weight: .bold))
                        .monospacedDigit()
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("Peak TOPS")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                            Text(String(format: "%.1f TOPS", engine.topsMeter))
                                .font(.headline.bold())
                                .monospacedDigit()
                                .foregroundStyle(ArcadeTheme.siliconGreen)
                        }
                        .padding()
                        .liquidGlassCard(cornerRadius: 14)
                        
                        VStack {
                            Text("Thermal State")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                            Text(engine.thermalPressure < 0.5 ? "Optimal (Cool)" : "Warm")
                                .font(.headline.bold())
                                .foregroundStyle(engine.thermalPressure < 0.5 ? ArcadeTheme.siliconGreen : ArcadeTheme.swiftOrange)
                        }
                        .padding()
                        .liquidGlassCard(cornerRadius: 14)
                    }
                    
                    Button {
                        engine.restart()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Run Another Dispatch")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(ArcadeTheme.siliconGradient)
                        .clipShape(Capsule())
                        .neonGlow(color: ArcadeTheme.siliconGreen, radius: 14)
                    }
                    .springPress()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Exit to Arcade")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                // Header
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
                        Text("SILICON ARCHITECT")
                            .font(.system(.headline, design: .monospaced, weight: .black))
                            .foregroundStyle(ArcadeTheme.siliconGradient)
                        Text("Unified Memory Hardware Dispatcher")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    // Score
                    Text("\(engine.score) pts")
                        .font(.system(.subheadline, design: .monospaced, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .liquidGlassCard(cornerRadius: 12, tint: ArcadeTheme.siliconGreen)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Hardware Telemetry Gauges
                HStack(spacing: 12) {
                    // Neural TOPS Gauge
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundStyle(ArcadeTheme.siliconGreen)
                            Text(String(format: "%.1f TOPS", engine.topsMeter))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)
                        }
                        ProgressView(value: min(1.0, engine.topsMeter / 38.0))
                            .tint(ArcadeTheme.siliconGreen)
                    }
                    .padding(10)
                    .liquidGlassCard(cornerRadius: 12, tint: ArcadeTheme.siliconGreen)
                    
                    // Thermal Pressure Gauge
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(engine.thermalPressure > 0.6 ? ArcadeTheme.arcadeCrimson : ArcadeTheme.swiftOrange)
                            Text("Thermal: \(Int(engine.thermalPressure * 100))%")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)
                        }
                        ProgressView(value: engine.thermalPressure)
                            .tint(engine.thermalPressure > 0.6 ? ArcadeTheme.arcadeCrimson : ArcadeTheme.swiftOrange)
                    }
                    .padding(10)
                    .liquidGlassCard(cornerRadius: 12, tint: ArcadeTheme.swiftOrange)
                }
                .padding(.horizontal)
                
                // Workload Instruction Card
                VStack(spacing: 8) {
                    HStack {
                        Label("INCOMING WORKLOAD QUEUE", systemImage: "tray.and.arrow.down.fill")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                        Spacer()
                        if engine.combo > 1 {
                            Text("Combo \(engine.combo)x 🔥")
                                .font(.caption.bold())
                                .foregroundStyle(ArcadeTheme.liquidGold)
                        }
                    }
                    
                    Text(engine.currentWorkload.taskName)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(engine.currentWorkload.detail)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.cupertinoCyan)
                .padding(.horizontal)
                
                // Banner
                Text(engine.bannerMessage)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(engine.bannerColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background(engine.bannerColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                
                // 4 Hardware Coprocessor Dispatch Pads
                VStack(spacing: 10) {
                    ForEach(SiliconBlock.allCases) { block in
                        Button {
                            engine.dispatch(to: block)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: block.icon)
                                    .font(.title3)
                                    .foregroundStyle(block.tint)
                                    .frame(width: 32)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(block.rawValue)
                                        .font(.system(.body, design: .monospaced, weight: .bold))
                                        .foregroundStyle(.white)
                                    Text(block.specs)
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundStyle(block.tint)
                            }
                            .padding()
                            .liquidGlassCard(cornerRadius: 16, tint: block.tint, strokeOpacity: 0.35)
                        }
                        .springPress()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
}

