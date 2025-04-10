//
//  ContentView.swift
//  Charts_SwiftUI
//
//  Created by Akshaya Gunnepalli on 06/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                GroupBox {
                    BarGraph()
                }
                GroupBox {
                    DonutChartView()
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
