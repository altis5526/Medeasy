//
//  EditDefaultValue.swift
//  MedEasy
//
//  Created by 陳祺侑 on 2023/12/30.
//

import SwiftUI

struct EditDefaultValue: View {
    @Binding var DefaultDict: [String: Double]

    var body: some View {
        Form {
            Section(header: Text("Default values")) {
                HStack{
                    Text("pH maximum")
                    Spacer()
                    TextField("pH maximum", value: $DefaultDict["ph_high"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("pH minimum")
                    Spacer()
                    TextField("pH minimum", value: $DefaultDict["ph_low"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("PaCO2 maximum")
                    Spacer()
                    TextField("PaCO2 maximum", value: $DefaultDict["co2_high"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("PaCO2 minimum")
                    Spacer()
                    TextField("PaCO2 minimum", value: $DefaultDict["co2_low"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("HCO3 maximum")
                    Spacer()
                    TextField("HCO3 maximum", value: $DefaultDict["hco3_high"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("HCO3 minimum")
                    Spacer()
                    TextField("HCO3 minimum", value: $DefaultDict["hco3_low"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("Anion gap maximum")
                    Spacer()
                    TextField("Anion gap maximum", value: $DefaultDict["AG_high"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
                HStack{
                    Text("Anion gap minimum")
                    Spacer()
                    TextField("Anion gap minimum", value: $DefaultDict["AG_low"], format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct EditDefaultValue_Previews: PreviewProvider {
    static var previews: some View {
        let DefaultDict = ["ph_high": 7.44,
                          "ph_low": 7.36,
                          "co2_high": 44,
                          "co2_low": 36,
                          "co2_normal": 40,
                          "hco3_high": 22,
                          "hco3_low": 26,
                          "hco3_normal": 24,
                          "AG_high": 16,
                          "AG_low": 8,
                          "AG_normal": 12]
        EditDefaultValue(DefaultDict: .constant(DefaultDict))
    }
}

