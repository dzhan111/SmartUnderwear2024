//
//  Analysis.swift
//  SmartUndiesV1
//
//  Created by David on 7/25/23.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        ZStack {
            Color(hex: "#262626").edgesIgnoringSafeArea(.all)
            Text("Analysis of graph goes here")
                .foregroundColor(.white) // Make text color white
        }
    }
}

struct Analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
