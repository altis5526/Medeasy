//
//  EquationView.swift
//  MedEasy
//
//  Created by 陳祺侑 on 2023/12/27.
//

import SwiftUI

struct EquationView: View {
    @State private var ph: String = ""
    @State private var Paco2: String = ""
    @State private var HCO3: String = ""
    @State private var na: String = ""
    @State private var chloride: String = ""
    @State private var result: String = ""
    @State private var albumin: String = ""
    @State private var showResult: Bool = false
    @State private var VBG: Bool = false

//    var respiratory: Bool
//    var metabolic: Bool
//    var acidosis: Bool
//    var alkalosis: Bool
//    var mixed: Bool
//    var secondary: Bool
    @Binding var DefaultDict: [String: Double]
//    @Binding var ph_high: Double
//    @Binding var ph_low: Double
//    @Binding var co2_high: Double
//    @Binding var co2_low: Double
//    @Binding var co2_normal: Double
//    @Binding var hco3_high: Double
//    @Binding var hco3_low: Double
//    @Binding var hco3_normal: Double
//    @Binding var AG_high: Double
//    @Binding var AG_low: Double
//    @Binding var AG_normal: Double
    
    let ph_key_words: [Int: String] = [1: "代謝性鹼中毒", 2: "代謝性酸中毒"]
    let co2_key_words: [Int: String] = [1: "呼吸性酸中毒", 2: "呼吸性鹼中毒"]
    
    private func stage_one_calculate(ph: String, co2: String, hco3: String, vbg: Bool) -> Void {
        var ph = Double(ph) ?? 0.0
        var co2 = Double(co2) ?? 0.0
        var hco3 = Double(hco3) ?? 0.0
        let ph_abnormal: Int // 0: normal; 1: too high; 2: too low
        let co2_abnormal: Int // 0: normal; 1: too high; 2: too low
        
        if vbg {
            ph = ph + 0.03
            co2 = co2 - 5
            hco3 = hco3 - 1
        }
            
        if ph > DefaultDict["ph_high"]! {
            ph_abnormal = 1
        } else if ph < DefaultDict["ph_low"]! {
            ph_abnormal = 2
        } else {
            ph_abnormal = 0
        }
        
        if co2 > DefaultDict["co2_high"]! {
            co2_abnormal = 1
        } else if co2 < DefaultDict["co2_low"]! {
            co2_abnormal = 2
        } else {
            co2_abnormal = 0
        }
        
        if ph_abnormal + co2_abnormal == 0 {
            result = "病人很好放心"
        } else if ph_abnormal > 0 && co2_abnormal > 0 {
            if ph_abnormal + co2_abnormal == 3 {
                if let keyword = co2_key_words[co2_abnormal] {
                    result += keyword
                    complement_calc(co2: co2, hco3: hco3, ph: ph, type: "res")
                }
            } else {
                if let keyword = ph_key_words[ph_abnormal] {
                    result += keyword
                    complement_calc(co2: co2, hco3: hco3, ph: ph, type: "meta")
                }
            }
        } else {
            if ph_abnormal > 0 {
                if let keyword = ph_key_words[ph_abnormal] {
                    result += keyword
                }
                if let keyowrd = co2_key_words[3-ph_abnormal] {
                    result += "合併\(keyowrd)"
                }
            } else if co2_abnormal > 0 {
                if let keyword = co2_key_words[co2_abnormal] {
                    result += keyword
                }
                if let keyowrd = ph_key_words[3-co2_abnormal] {
                    result += "合併\(keyowrd)"
                }
            }
        }
    }
    
    private func AG_calculate(na: String, hco3: String, chloride: String, albumin: String) -> Void {
        let hco3_normal = (DefaultDict["hco3_high"]! + DefaultDict["hco3_low"]!) / 2
        let AG_normal = (DefaultDict["AG_high"]! + DefaultDict["AG_low"]!) / 2
        let na = Double(na) ?? 0.0
        let hco3 = Double(hco3) ?? 24
        let chloride = Double(chloride) ?? 0.0
        
        if na == 0.0 && chloride == 0.0 {
            result = result
        }
        
        else {
            var albumin = Double(albumin) ?? 0.0
            if albumin > 4.5 || albumin == 0.0 {
                albumin = 4.5
            }
            let AG = na - hco3 - chloride + 2.5 * (4.5 - albumin)
            let GGratio = (AG - AG_normal) / (hco3_normal - hco3)
            
            if AG > DefaultDict["AG_high"]! {
                result = "高陰離子間隙" + result
                if GGratio < 1 {
                    result += "合併正常陰離子間隙代謝性酸中毒"
                } else if GGratio > 1 {
                    result += "合併正常陰離子間隙代謝性鹼中毒"
                }
            }
        }
    }
    
    private func complement_calc(co2: Double, hco3: Double, ph: Double, type: String) -> Void {
        let hco3_normal = (DefaultDict["hco3_high"]! + DefaultDict["hco3_low"]!) / 2
        let co2_normal = (DefaultDict["co2_high"]! + DefaultDict["co2_low"]!) / 2
        if type == "res" {
            if hco3 < DefaultDict["hco3_high"]! && hco3 > DefaultDict["hco3_low"]! {
                result = "急性" + result
            } else {
                result = "慢性" + result
                let expected_hco3 = hco3_normal + 0.4 * (co2 - (co2_normal))
                if hco3 > expected_hco3 {
                    result += "續發性代謝性鹼中毒(預期hco3值\(expected_hco3))"
                } else if hco3 < expected_hco3 {
                    result += "續發性代謝性酸中毒(預期hco3值\(expected_hco3))"
                } else {
                    result += "完全代償性反應"
                }
            }
        } else if type == "meta" {
            let expected_co2: Double
            if ph > DefaultDict["ph_high"]! {
                expected_co2 = 40 + 0.7 * (hco3 - 24)
            } else {
                expected_co2 = 40 - 1.2 * (24 - hco3)
            }
            
            if co2 > expected_co2 {
                result += "續發性呼吸性酸中毒(預期PaCO2值\(expected_co2))"
            } else if co2 < expected_co2 {
                result += "續發性呼吸性鹼中毒(預期PaCO2值\(expected_co2))"
            } else {
                result += "完全代償性反應"
            }
        }
    }
    
    var body: some View {
        Text("Please enter following information:")
            .padding(.bottom)
            .font(.title)
        Toggle("VBG mode", isOn: $VBG)
            .padding(5)
        VStack {
            TextField("pH value", text: $ph)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            TextField("PaCO2", text: $Paco2)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            TextField("HCO3", text: $HCO3)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            TextField("Na", text: $na)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            TextField("Chloride", text: $chloride)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            TextField("Albumin", text: $albumin)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            Button("確定"){
                stage_one_calculate(ph: ph, co2: Paco2, hco3: HCO3, vbg: VBG)
                AG_calculate(na: na, hco3: HCO3, chloride: chloride, albumin: albumin)
                showResult = true
            }
            .font(.title)
            .padding()
        }
        .alert(result, isPresented: $showResult, actions: {
                    Button("OK") {
                        ph = ""
                        Paco2 = ""
                        HCO3 = ""
                        na = ""
                        chloride = ""
                        albumin = ""
                        result = ""}})
        .padding()
    
    }
}

struct EquationView_Previews: PreviewProvider {
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
        EquationView(DefaultDict: .constant(DefaultDict))
    }
}
