//
//  ProgressView.swift
//  Saal
//
//  Created by Husein Hakim on 03/06/25.
//

import Foundation
import SwiftUI

struct ProgressView: View {
    @State var loadingAnimation: Bool = false
    @EnvironmentObject var stspipeline: STSPipeline
    
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
            
            VStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(AngularGradient(gradient: Gradient(colors: [.red.opacity(0.1), .red.opacity(0.25), .red.opacity(0.5)]), center: .center, angle: .degrees(loadingAnimation ? 360 : 0)))
                    .mask {
                        Image(systemName: "circle.dotted")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                
                Text("Getting your models ready...")
            }
        }
        .onAppear {
            stspipeline.loadModels()
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                loadingAnimation.toggle()
            }
        }
    }
}
