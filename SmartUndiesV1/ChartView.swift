//
//  ChartView.swift
//  dataParserText
//
//  Created by David on 7/6/23.
//

//
//  ChartView.swift
//  lastChance
//
//  Created by David on 6/16/23.
//

import SwiftUI
import Charts
import CoreGraphics


public protocol ChartDataProvider {
    
    var chartXMin: Double { get set }
    var chartXMax: Double { get set }
    var chartYMin: Double { get set }
    var chartYMax: Double { get set }
    
    var maxHighlightDistance: CGFloat { get }
    var xRange: Double { get }
    var centerOffsets: CGPoint { get }
    var data: DataPoint? { get }
    var maxVisibleCount: Int { get }
}


struct LineChart: View {
    @StateObject private var chartData = LineChartData()
    @ObservedObject var bluetoothViewModel: BluetoothViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                //the title of the graph
                Text("Title")
                
                VStack{
                    Spacer()
                    HStack{
                        //Y Axis name  --------------
                        Text("Y axis label")
                            .rotationEffect(.degrees(-90.0))
                        
                        Chart {
                            ForEach(data1.indices, id: \.self) { index in
                                LineMark(
                                    x: .value("x", data1[index].x),
                                    y: .value("y", data1[index].y)
                                )
                            }
                        }
                        .onAppear {
                            configureChartDataProvider()
                        }
                        
                        
                        
                    }
                    //X axis name ---------------
                    Text("X axis label")
                    
                    Button("Back to home", action: {
                        bluetoothViewModel.graphAvailable = false
                        bluetoothViewModel.showingConnectedView = false
                    })
                }
                
                
            }
        }
        .navigationTitle("Ventogram")
        
    }
    
    func configureChartDataProvider() {
        chartData.chartXMin = 0
        chartData.chartXMax = 10
        chartData.chartYMin = 0
        chartData.chartYMax = 8
        
        // Set other properties of the chart data provider as needed
    }
    
    
}


class LineChartData: ObservableObject, ChartDataProvider {
    var data: DataPoint?
    
    @Published var chartXMin: Double = 0
    @Published var chartXMax: Double = 0
    @Published var chartYMin: Double = 0
    @Published var chartYMax: Double = 0

    let maxHighlightDistance: CGFloat = 20

    var xRange: Double {
        return chartXMax - chartXMin
    }

    let centerOffsets: CGPoint = .zero

    //@Published var data: [DataPoint]?

    var maxVisibleCount: Int = 0
}

//make data
