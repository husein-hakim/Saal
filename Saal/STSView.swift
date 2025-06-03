//
//  STSView.swift
//  Saal
//
//  Created by Husein Hakim on 02/06/25.
//

import SwiftUI

struct STSView: View {
    @EnvironmentObject var stspipeline: STSPipeline
    @State private var audioLevel: CGFloat = 0
    @State private var pulseAnimation = false
    @State private var loadingAnimation: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.9),
                    Color.gray.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !stspipeline.modelLoading {
                VStack(spacing: 40) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.red.opacity(0.6),
                                        Color.red.opacity(0.1)
                                    ]),
                                    center: .center,
                                    startRadius: 60,
                                    endRadius: 120
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 220, height: 220)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                            .opacity(pulseAnimation ? 0.7 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.red.opacity(0.8),
                                        Color.red.opacity(0.4)
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 90
                                )
                            )
                            .frame(width: circleSize, height: circleSize)
                            .shadow(color: Color.red.opacity(0.5), radius: 20, x: 0, y: 0)
                            .animation(.easeInOut(duration: 0.1), value: audioLevel)
                    }
                    
                    Spacer()
                    
                    Button {
                        if stspipeline.stsstate == .idle {
                            stspipeline.startListening()
                        } else if stspipeline.stsstate == .listening {
                            Task {
                                await stspipeline.generateResponse()
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            
                            Image(systemName: buttonIcon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: pulseAnimation)
                    }
                    .disabled(stspipeline.stsstate == .processing)

                    
                    Spacer()
                }
            } else {
                
            }
        }
        .onAppear {
            stspipeline.loadModels()
            pulseAnimation = true
            audioAnimation()
        }
    }
    
    var circleSize: CGFloat {
        let expansion = stspipeline.stsstate == .listening ? audioLevel * 50 : 0
        return 180 + expansion
    }
    
    var buttonIcon: String {
        switch stspipeline.stsstate {
        case .idle: return "mic"
        case .listening: return "stop.fill"
        case .processing: return "hourglass"
        case .speaking: return "speaker.2"
        }
    }
    
    func audioAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if stspipeline.stsstate == .listening {
                withAnimation(.easeInOut(duration: 0.1)) {
                    audioLevel = CGFloat.random(in: 0.2...1.0)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    audioLevel = 0
                }
            }
        }
    }
}
