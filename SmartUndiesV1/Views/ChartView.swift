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
    
    //@ObservedObject var bluetoothViewModel: BluetoothViewModel
    @State private var showNextView = false
    @State private var showAnalysis = false
    
    var body: some View {
        ZStack {
            Color(hex: "#262626").edgesIgnoringSafeArea(.all) // Set background color for the entire view
            
            if(showNextView){
                WelcomeView()
                    .navigationBarHidden(true)
            }else{
                VStack{
                    Text("Ventogram")
                        .foregroundColor(.white)
                    
                    Chart {
                        ForEach(data1.indices, id: \.self) { index in
                            PointMark(
                                x: .value("x", data1[index].x),
                                y: .value("y", data1[index].y)
                            )
                        }
                    }
                    
                    .onAppear {
                        configureChartDataProvider()
                    }
                    
                    .chartYAxis(){
                        AxisMarks(position: .leading)
                    }
                    .chartXAxisLabel(position: .bottom, alignment: .center)
                    {
                        Text("Time(s)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40) // Set the desired height of the graph
                    .border(Color.white, width: 1) // Add a border to the chart
                    //.clipped()
                    .chartYScale(domain: [yMin,yMax+yMax/10])
                    .chartXScale(domain: [0,xMax+xMax/10])
                    .padding(.bottom, 10.0)
                    .foregroundColor(.white)
        
                    
                    
                    Button("Show Analysis ", action:{
                        showAnalysis = true
                    })
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .padding(.bottom, 50.0)
                    .font(.system(.body).bold())
                    
                    
                    
                    HStack{
                        Button("Upload ", action:{
                            print("upload!")
                        })
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                        .font(.system(.body).bold())
                        Button("Restart", action: {
                            showNextView = true
                            
                        })
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                        .font(.system(.body).bold())
                        
                    }//end Hstack
                }.sheet(isPresented: $showAnalysis) {
                    AnalysisView()
                }
                
                
                
                
            }
        }
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
    
    @Published var dataPoints: [DataPoint] = data1
    
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

struct LineChart_Preview: PreviewProvider {
    static var previews: some View {
        LineChart()
    }
}

//make data


