//
//  LaunchScreenView.swift
//  Seemi's Spiritual Companion
//
//  Animated launch screen with greeting
//

import SwiftUI

struct LaunchScreenView: View {
    @Environment(AppState.self) private var appState
    @State private var animateFlower: Bool = false
    @State private var animateText: Bool = false
    @State private var petalRotations: [Double] = Array(repeating: 0, count: 8)
    
    var body: some View {
        ZStack {
            // Gradient Background - Pakistani Garden Theme
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#E8F5E9"),
                    Color(hex: "#C8E6C9"),
                    Color(hex: "#A5D6A7"),
                    Color(hex: "#81C784")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Greeting Text
                VStack(spacing: 12) {
                    Text("Assalamu Alaikum")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundStyle(.white)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : -20)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text("Seemi")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : -20)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(currentGreeting())
                        .font(.system(size: 24, weight: .light, design: .serif))
                        .foregroundStyle(.white.opacity(0.9))
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : -20)
                }
                .padding(.horizontal)
                
                // Animated Jasmine Flower
                JasmineFlowerView(isAnimating: $animateFlower)
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateFlower ? 1 : 0.3)
                    .opacity(animateFlower ? 1 : 0)
                
                Spacer()
                
                // Subtle Islamic Pattern Footer
                Text("بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(animateText ? 1 : 0)
                    .padding(.bottom, 50)
                    .accessibilityLabel("Bismillah ir-Rahman ir-Rahim")
                    .accessibilityHint("In the name of Allah, the Most Gracious, the Most Merciful")
            }
        }
        .onAppear {
            // Animate entrance
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateFlower = true
            }
            
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                animateText = true
            }
            
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appState.dismissLaunchScreen()
            }
        }
    }
    
    // MARK: - Time-based Greeting
    private func currentGreeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        // PKT timezone aware
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}

// MARK: - Jasmine Flower Animation
struct JasmineFlowerView: View {
    @Binding var isAnimating: Bool
    @State private var petalScales: [CGFloat] = Array(repeating: 0, count: 8)
    @State private var centerScale: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Center of flower (yellow)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#FFF59D"), Color(hex: "#F9A825")],
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
                .scaleEffect(centerScale)
            
            // 8 White Petals
            ForEach(0..<8, id: \.self) { index in
                PetalShape()
                    .fill(
                        LinearGradient(
                            colors: [Color.white, Color(hex: "#F5F5F5")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 60, height: 80)
                    .scaleEffect(petalScales[index])
                    .rotationEffect(.degrees(Double(index) * 45))
                    .offset(y: -50)
                    .rotationEffect(.degrees(Double(index) * 45))
            }
        }
        .onChange(of: isAnimating) { oldValue, newValue in
            if newValue {
                animatePetals()
            }
        }
    }
    
    private func animatePetals() {
        // Staggered petal bloom animation
        for index in 0..<8 {
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.6)
                .delay(Double(index) * 0.08)
            ) {
                petalScales[index] = 1
            }
        }
        
        // Center blooms last
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6)) {
            centerScale = 1
        }
    }
}

// MARK: - Petal Shape
struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: 0, y: height * 0.5)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control: CGPoint(x: width, y: height * 0.5)
        )
        
        return path
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LaunchScreenView()
        .environment(AppState())
}
