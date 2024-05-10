import SwiftUI

struct StrokedCircularProgressViewStyle: ProgressViewStyle {
    @State private var rotation: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .square))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: rotation))
                .animation(
                    Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                    value: rotation
                )
        }
        .frame(width: 24, height: 24)
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            rotation = 360.0
        }
    }
}


