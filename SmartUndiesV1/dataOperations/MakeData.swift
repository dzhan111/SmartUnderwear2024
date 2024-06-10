//
//  dataPlotter.swift
//  dataParserText
//
//  Created by David on 7/6/23.
//

import Foundation
import SwiftUI


public struct DataPoint {
    let x: Double
    let y: Double
}


var data1: [DataPoint] = []
var xMax: Int = 0
var yMax: Int = 0
var yMin: Int = Int.max


//this function takes in 2 strings and makes a new data array
//that is gonna be available for plotting
//returns an array for plotting
func makeDataPoint(arr: [(Double,Int,Int,Int)]) {
    
    for (time, sensor, _, _) in arr {
        
        let xValue = Double(time)
        let yValue = Double(sensor)
        
        if(Int(xValue) > xMax){
            xMax = Int(xValue)
        }
        
        if(Int(yValue) > yMax){
            yMax = Int(yValue)
        }
        
        if(Int(yValue) < yMin){
            yMin = Int(yValue)
        }
        
        let newDataPoint = DataPoint(x: xValue, y: yValue)
        data1.append(newDataPoint)
    }
    

}
