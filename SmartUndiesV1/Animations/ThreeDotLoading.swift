//
//  ThreeDotLoading.swift
//  SmartUndiesV1
//
//  Created by David on 7/25/23.
//

import Foundation
import SwiftUI

struct ThreeDotLoadingAnimation: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .scaleEffect(isAnimating ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: 1)
            Circle()
                .scaleEffect(isAnimating ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.5).delay(0.2).repeatForever(), value: 1)
            Circle()
                .scaleEffect(isAnimating ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.5).delay(0.2).repeatForever(), value: 1)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
