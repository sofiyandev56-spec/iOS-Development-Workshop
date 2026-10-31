import SwiftUI
import Combine

/// Master Duo Foldable Container: Renders dynamic dual screens with realistic 3D hinge physics
public struct DuoFoldableContainerView<LeftContent: View, RightContent: View>: View {
    @ObservedObject var foldableManager = FoldableDeviceManager.shared
    
    let leftContent: () -> LeftContent
    let rightContent: () -> RightContent
    
    public init(
        @ViewBuilder leftContent: @escaping () -> LeftContent,
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) {
        self.leftContent = leftContent
        self.rightContent = rightContent
    }
    
    public var body: some View {
        GeometryReader { geo in
            if foldableManager.isDualScreen {
                if foldableManager.currentPosture == .tabletop {
                    // Tabletop (Horizontal 90° Laptop Fold)
                    VStack(spacing: 0) {
                        // Top Screen (Monitor)
                        leftContent()
                            .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.52)
                            .rotation3DEffect(
                                Angle(degrees: (180.0 - foldableManager.hingeAngle) * 0.25),
                                axis: (x: 1.0, y: 0.0, z: 0.0),
                                anchor: .bottom
                            )
                        
                        // Horizontal Hinge Divider
                        ZStack {
                            Rectangle()
                                .fill(ArcadeTheme.hingeSilver)
                                .frame(height: max(6, foldableManager.creaseWidth))
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1.5)
                        }
                        
                        // Bottom Screen (Haptic Gamepad & Controls)
                        rightContent()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .rotation3DEffect(
                                Angle(degrees: -(180.0 - foldableManager.hingeAngle) * 0.35),
                                axis: (x: 1.0, y: 0.0, z: 0.0),
                                anchor: .top
                            )
                    }
                } else {
                    // Book & Flat Mode (Vertical Fold)
                    HStack(spacing: 0) {
                        // Left Screen Panel
                        leftContent()
                            .frame(width: geo.size.width * foldableManager.splitRatio - (foldableManager.creaseWidth / 2))
                            .rotation3DEffect(
                                Angle(degrees: (180.0 - foldableManager.hingeAngle) * 0.25),
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .trailing
                            )
                        
                        // Central Dynamic Hinge Crease
                        HingeDividerView(creaseWidth: foldableManager.creaseWidth)
                        
                        // Right Screen Panel
                        rightContent()
                            .frame(width: geo.size.width * (1.0 - foldableManager.splitRatio) - (foldableManager.creaseWidth / 2))
                            .rotation3DEffect(
                                Angle(degrees: -(180.0 - foldableManager.hingeAngle) * 0.25),
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .leading
                            )
                    }
                }
            } else {
                // Single Screen Mode (iPhone 18 Pro Max or Closed Cover)
                leftContent()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

