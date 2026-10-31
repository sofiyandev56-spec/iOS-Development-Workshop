import SwiftUI

/// Cupertino & Apple Arcade Visual Design System (iOS 26 Liquid Glass)
public struct ArcadeTheme {
    // Primary Arcade Brand Colors
    public static let arcadeCrimson = Color(red: 1.0, green: 0.16, blue: 0.35)
    public static let swiftOrange   = Color(red: 1.0, green: 0.42, blue: 0.08)
    public static let cupertinoCyan = Color(red: 0.05, green: 0.78, blue: 0.95)
    public static let neuralViolet  = Color(red: 0.62, green: 0.28, blue: 1.00)
    public static let siliconGreen  = Color(red: 0.12, green: 0.88, blue: 0.54)
    public static let liquidGold    = Color(red: 1.0, green: 0.80, blue: 0.15)
    
    // Backgrounds & Surface Depths
    public static let backgroundDark = Color(red: 0.04, green: 0.04, blue: 0.08)
    public static let surfaceDark    = Color(red: 0.09, green: 0.10, blue: 0.16)
    public static let cardSurface    = Color(white: 0.12).opacity(0.65)
    public static let hingeSilver    = Color(red: 0.22, green: 0.24, blue: 0.30)
    
    // Radiant Gradients
    public static let arcadeGradient = LinearGradient(
        colors: [arcadeCrimson, swiftOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let neuralGradient = LinearGradient(
        colors: [neuralViolet, cupertinoCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let siliconGradient = LinearGradient(
        colors: [siliconGreen, cupertinoCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let glassBorder = LinearGradient(
        colors: [Color.white.opacity(0.40), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Apple Intelligence Radiant Iris Aura
    public static let appleIntelligenceGlow = AngularGradient(
        gradient: Gradient(colors: [arcadeCrimson, swiftOrange, liquidGold, siliconGreen, cupertinoCyan, neuralViolet, arcadeCrimson]),
        center: .center
    )
}

// MARK: - View Modifiers

/// iOS 26 Liquid Glass Material with Specular Rim Highlight
public struct LiquidGlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var tint: Color = .clear
    var strokeOpacity: CGFloat = 0.35
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Deep Dark Glass Base
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(ArcadeTheme.cardSurface)
                    
                    // Chromatic tint refraction
                    if tint != .clear {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(tint.opacity(0.09))
                    }
                    
                    // Specular Highlight Bevel (Light hitting from top-left at 135 deg)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(strokeOpacity),
                                    tint.opacity(0.6),
                                    Color.white.opacity(0.04),
                                    Color.black.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                }
            )
            .shadow(color: tint == .clear ? Color.black.opacity(0.40) : tint.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}

/// Apple Machined Double-Bezel (Concentric outer tray + inner glass core)
public struct DoubleBezelCardModifier: ViewModifier {
    var outerRadius: CGFloat = 24
    var tint: Color = ArcadeTheme.arcadeCrimson
    
    public func body(content: Content) -> some View {
        let paddingAmount: CGFloat = 3.5
        let innerRadius: CGFloat = max(8, outerRadius - paddingAmount)
        
        return content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: innerRadius, style: .continuous)
                    .fill(ArcadeTheme.surfaceDark.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: innerRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
            .padding(paddingAmount)
            .background(
                RoundedRectangle(cornerRadius: outerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: outerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.35), tint.opacity(0.4), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )
            )
            .shadow(color: tint.opacity(0.2), radius: 18, x: 0, y: 10)
    }
}

public struct NeonGlowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat = 12
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.7), radius: radius * 0.5, x: 0, y: 0)
            .shadow(color: color.opacity(0.3), radius: radius, x: 0, y: 0)
    }
}

public struct ArcadePressButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.68), value: configuration.isPressed)
    }
}

public struct SpringPressModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .buttonStyle(ArcadePressButtonStyle())
    }
}

public extension View {
    func liquidGlassCard(cornerRadius: CGFloat = 20, tint: Color = .clear, strokeOpacity: CGFloat = 0.35) -> some View {
        modifier(LiquidGlassCardModifier(cornerRadius: cornerRadius, tint: tint, strokeOpacity: strokeOpacity))
    }
    
    func doubleBezel(outerRadius: CGFloat = 24, tint: Color = ArcadeTheme.arcadeCrimson) -> some View {
        modifier(DoubleBezelCardModifier(outerRadius: outerRadius, tint: tint))
    }
    
    func neonGlow(color: Color, radius: CGFloat = 12) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius))
    }
    
    func springPress() -> some View {
        modifier(SpringPressModifier())
    }
}
