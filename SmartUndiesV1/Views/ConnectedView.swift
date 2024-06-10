//
//  Success.swift
//  BLE_dataSend
//
//  Created by David on 7/12/23.
//

import SwiftUI
import UIKit


struct ConnectedView: View {
    @ObservedObject var bluetoothViewModel: BluetoothViewModel
    @State private var isLoading = true
    var body: some View {
            
        if(bluetoothViewModel.isComplete){
            CompleteView(bluetoothViewModel: bluetoothViewModel)
        }else{
            ZStack{
                Color(hex: "#262626").edgesIgnoringSafeArea(.all)
                VStack() {
                    Spacer()
                    Text("Please keep device close to phone")
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.title3)
                        .foregroundColor(.white)
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                        .frame(width: 100, height: 100) // Set your desired dimensions
                        .scaleEffect(3) // Scale by a factor of 3
                    Spacer()
                    Text("Connected to \(bluetoothViewModel.connectedPeripheral?.name ?? "Unnamed Device")")
                        .padding()
                        .foregroundColor(.white)
                    
                    //MAKW USER GO TO HOME SCREEN ON ERROR
                    Button(action: {
                        bluetoothViewModel.disconnectPeripheral()
                    }, label: {
                        Text("Disconnect")
                        .foregroundColor(.white)
                    })
                    .padding()
                    .cornerRadius(20)
                    Spacer()
                }
            }//Zstack
            
        }
                    
    }
        
}
struct storyboardview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "Home")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}



