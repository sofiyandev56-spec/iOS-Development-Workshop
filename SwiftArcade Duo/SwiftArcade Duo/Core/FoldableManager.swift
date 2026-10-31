import SwiftUI
import Combine

/// Supported device postures for foldable Apple hardware (iPhone Duo) and flagship single-screen (iPhone 18 Pro Max)
public enum FoldPosture: String, CaseIterable, Identifiable {
    case unfoldedFlat = "Dual Flat (180°)"
    case book = "Book Posture (120°)"
    case tabletop = "Tabletop Posture (90°)"
    case tent = "Tent Posture (300°)"
    case closedCover = "Cover / iPhone 18 Pro Max"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .unfoldedFlat: return "rectangle.split.2x1.fill"
        case .book: return "book.closed.fill"
        case .tabletop: return "laptopcomputer"
        case .tent: return "triangle.fill"
        case .closedCover: return "iphone"
        }
    }
    
    public var description: String {
        switch self {
        case .unfoldedFlat:
            return "Unified 7.9\" Dual-OLED display. Full widescreen arcade & dual-pane code studio."
        case .book:
            return "Held like a book. Left page: Lesson & Terminal. Right page: Game action canvas."
        case .tabletop:
            return "Resting on a desk at 90°. Top screen is Arcade Monitor; bottom screen is Haptic Gamepad."
        case .tent:
            return "Standing upright. Head-to-head developer trivia & flashcard showdown."
        case .closedCover:
            return "Optimized for single-screen: iPhone 18 Pro Max Super Retina XDR with Dynamic Island 3.0."
        }
    }
}

/// Simulated target device
public enum TargetDeviceType: String, CaseIterable, Identifiable {
    case iphoneDuo = "iPhone Duo (Dual-OLED Foldable)"
    case iphone18ProMax = "iPhone 18 Pro Max (6.9\" Flagship)"
    
    public var id: String { rawValue }
}

/// Foldable Device Manager: Controls hinge physics, posture detection, and seamless live fold transitions
public final class FoldableDeviceManager: ObservableObject {
    public static let shared = FoldableDeviceManager()
    
    /// Target device simulation
    @Published public var deviceType: TargetDeviceType = .iphoneDuo {
        didSet {
            updatePostureFromAngle()
        }
    }
    
    /// Hinge angle in degrees (0° closed to 180° completely flat)
    @Published public var hingeAngle: Double = 180.0 {
        didSet {
            updatePostureFromAngle()
        }
    }
    
    /// Active ergonomic posture
    @Published public var currentPosture: FoldPosture = .unfoldedFlat
    
    /// Left / Right split ratio in dual screen (0.5 = 50/50 balance)
    @Published public var splitRatio: CGFloat = 0.50
    
    /// Whether the hinge is actively being folded/manipulated
    @Published public var isFoldingInProgress: Bool = false
    
    /// Shows the on-screen foldable developer inspector
    @Published public var showHingeInspector: Bool = true
    
    /// Sound & haptic triggers
    private let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    private let hapticRigid = UIImpactFeedbackGenerator(style: .rigid)
    
    private init() {
        hapticImpact.prepare()
        hapticRigid.prepare()
    }
    
    /// Automatically derives posture from hinge angle
    private func updatePostureFromAngle() {
        let previous = currentPosture
        let newPosture: FoldPosture
        
        if deviceType == .iphone18ProMax {
            newPosture = .closedCover
        } else {
            switch hingeAngle {
            case 0..<45:
                newPosture = .closedCover
            case 45..<105:
                newPosture = .tabletop
            case 105..<165:
                newPosture = .book
            case 165...180:
                newPosture = .unfoldedFlat
            default:
                newPosture = .unfoldedFlat
            }
        }
        
        if previous != newPosture {
            currentPosture = newPosture
            hapticRigid.impactOccurred()
        }
    }
    
    /// Sets a specific posture with smooth animation & haptic detent
    public func setPosture(_ posture: FoldPosture) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            currentPosture = posture
            switch posture {
            case .unfoldedFlat:
                hingeAngle = 180.0
                deviceType = .iphoneDuo
            case .book:
                hingeAngle = 120.0
                deviceType = .iphoneDuo
            case .tabletop:
                hingeAngle = 90.0
                deviceType = .iphoneDuo
            case .tent:
                hingeAngle = 75.0
                deviceType = .iphoneDuo
            case .closedCover:
                hingeAngle = 0.0
                deviceType = .iphone18ProMax
            }
        }
        hapticImpact.impactOccurred()
    }
    
    /// Returns dynamic crease visual width based on hinge angle
    public var creaseWidth: CGFloat {
        if currentPosture == .closedCover { return 0 }
        let normalized = (180.0 - hingeAngle) / 180.0 // 0 when flat, 1 when folded
        return max(4.0, 6.0 + normalized * 18.0)
    }
    
    /// Returns 3D perspective rotation for the right screen panel
    public var rightPanelAngle: Double {
        if currentPosture == .closedCover { return 0 }
        return (180.0 - hingeAngle) * 0.45
    }
    
    /// Returns whether the UI should render dual panes or single pane
    public var isDualScreen: Bool {
        return deviceType == .iphoneDuo && currentPosture != .closedCover
    }
}

