//
//  TimerView.swift
//  SmartUndiesV1
//
//  Created by David on 7/20/23.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    
    var body: some View {
        
            Home()
            
        
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        
        TimerView()
    }
}

struct Home : View {
    @State private var showAlert = false
    @State private var showNextView = false
    @State var start = false
    @State var to : CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var totalTime: CGFloat = 1//14400
    
    var body: some View{
        
        if(showNextView){
            PeripheralView()
                .navigationTitle("Reconnect")
                .foregroundColor(.white)
        }else{
            ZStack{
                
                
                Color(hex: "#262626").edgesIgnoringSafeArea(.all)

                
                VStack{
                    
                    ZStack{
                        
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.white.opacity(0.4), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                            .frame(width: 280, height: 280)
                        
                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                            .frame(width: 280, height: 280)
                            .rotationEffect(.init(degrees: -90))
                        
                        
                        VStack{
                            
                            Text(formatTime(seconds: self.count))
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("4 Hours")
                                .font(.title)
                                .padding(.top)
                                .foregroundColor(.white)
                        }
                    }
                    
    
                    .padding(.top, 55)
                }
                
            }
            .onAppear(perform: {
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
                }
                //app starts immediately
                start = true
                count = Int(totalTime)
                
            })
            .onReceive(self.time) { (_) in
                
                if self.start{

                    if self.count != 0{
                        
                        self.count -= 1
                        
                        withAnimation(.default){
                            
                            self.to = CGFloat(self.count) / totalTime
                        }
                    }
        
                    else{
                        
                        self.start.toggle()
                        self.Notify()
                        showAlert = true

                        
                    }
                    
                }
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Time's Up!"),
                    message: Text("Please take off the Ventos and reconnect with the app."),
                    dismissButton: .default(Text("OK")){
                        showNextView = true
                    }
                )
            }
            
        }

    }
    
    func Notify(){
        let content = UNMutableNotificationContent()
        content.title = "Test period has expired."
        content.body = "Please take off the Ventos and reconnect with the app."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    func formatTime(seconds: Int) -> String{
        let second: Int = seconds % 60
        var minutes: Int =  seconds/60
        let hours: Int = minutes/60
        
        minutes = minutes-(hours*60)
        
        var sString: String = String(second)
        var mString: String =  String(minutes)
        var hString: String = String(hours)
        
        if(second < 10){
            sString = "0"+sString
            
        }
        if(minutes < 10){
            mString = "0" + mString
            
        }
        if(hours < 10){
            hString = "0" + hString
        }
        
        let formattedTime = "\(hString):\(mString):\(sString)"
        
        
        return formattedTime
    }
}
