//
//  ContentView.swift
//  MedEasy
//
//  Created by 陳祺侑 on 2023/12/27.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentingEditView = false
    @State private var DefaultDict = ["ph_high": 7.44,
                                      "ph_low": 7.36,
                                      "co2_high": 44,
                                      "co2_low": 36,
                                      "co2_normal": 40,
                                      "hco3_high": 22,
                                      "hco3_low": 26,
                                      "hco3_normal": 24,
                                      "AG_high": 12,
                                      "AG_low": 8,
                                      "AG_normal": 10]
    
    var body: some View {
        
        VStack {
            NavigationStack {
                NavigationLink(destination: EquationView(DefaultDict: $DefaultDict)) {
                    Text("Acid-Base Disturbance")
                        .padding()
                }
                .toolbar{
                    Button("Settings"){
                        isPresentingEditView = true
                    }
                }
                .font(.title)
                .background(.white)
                .cornerRadius(8)
                .navigationTitle("All tools")
            }
            
            .sheet(isPresented: $isPresentingEditView) {
                NavigationStack{
                    EditDefaultValue(DefaultDict: $DefaultDict)
                        .toolbar{
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingEditView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    isPresentingEditView = false
                                }
                            }
                        }
                }
            }
        }
        .padding()
        
    }
//    @State var ph: String = ""
//    @State var Paco2: String = ""
//    @State var HCO3: String = ""
//    @State var na: String = ""
//    @State var chloride: String = ""
//    
//    var body: some View {
//        VStack {
//            TextField("pH value", text: $ph)
//                .font(.title)
//                .background(.blue)
//                
//            
//            TextField("PaCO2", text: $Paco2)
//                .font(.title)
//            TextField("HCO3", text: $HCO3)
//            TextField("Na", text: $na)
//            TextField("Chloride", text: $chloride)
//        }
//        .padding()
//    }
}

#Preview {
    ContentView()
}
