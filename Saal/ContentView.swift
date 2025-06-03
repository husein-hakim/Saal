//
//  ContentView.swift
//  Saal
//
//  Created by Husein Hakim on 03/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stspipeline = STSPipeline()
    
    var body: some View {
        if stspipeline.modelLoading {
            ProgressView()
                .environmentObject(stspipeline)
        } else {
            STSView()
                .environmentObject(stspipeline)
        }
    }
}

#Preview {
    ContentView()
}
