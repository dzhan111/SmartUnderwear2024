import SwiftUI

struct WelcomeView: View {
    
    @State private var nextView = false
    @State private var showInstructions = false
    
    var body: some View {
        NavigationView{
            if(!nextView){
                VStack{
                    Spacer()
                    Image("Welcome") // Make sure to replace "photoName" with your actual image name
                        .resizable()
                        .scaledToFit()
                        .padding()
                    Spacer()
                    Button("Proceed to Instructions", action: {
                        nextView = true
                    })
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .font(.system(.body).bold())
                    Spacer()
                }
                .background(Color(hex: "#262626").edgesIgnoringSafeArea(.all))// Set the background to light grey
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showInstructions = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color.primary)
                            }
                        }
                }
            } else {
                InstructionView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showInstructions = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(Color.primary)
                                }
                            }
                    }
            }
        }
        .sheet(isPresented: $showInstructions) {
            InstructionSheetView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
