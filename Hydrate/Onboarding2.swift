//
//  Onboarding2.swift
//  Hydrate
//
//  Created by Raghad on 21/10/2024.
//
import SwiftUI

struct OnboardingSecondView: View {
    
    @State private var startHour = Date()
    @State private var endHour = Date()
    @State private var selectedInterval = 15
    
    
    var intervals = [15, 30, 60, 90, 120, 180, 240, 300] // In minutes
    let interval: Int? = nil
    
    @Binding var showOnboarding: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HStack{
                Text("Notification Preferences")
                    .font(.system(size: 22, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.bottom,32)
                    .padding(.top, 40)
                Spacer()
            }
            
            VStack(alignment: .leading,spacing: 32){
                VStack(alignment: .leading,spacing: 8){
                    Text("The start and End hour")
                        .fontWeight(.semibold)
                        .lineLimit(22)
                    Text("Specify the start and end date to receive the notifications ")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray)
                        
                }.frame(maxWidth: .infinity,alignment: .leading)
                VStack{
                    HStack{
                        Text("Start hour")
                            .font(.system(size: 17))
                        Spacer()
                        DatePicker("",
                                   selection: $startHour,
                                   displayedComponents: [.hourAndMinute]
                        )
                    }.padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack{
                        Text("End hour")
                            .font(.system(size: 17))
                        Spacer()
                        DatePicker("",
                                   selection: $startHour,
                                   displayedComponents: [.hourAndMinute]
                        )
                    }.padding(.horizontal)
                    
                }.frame(maxWidth: .infinity,maxHeight: 108)
                    
                    .background(Color.lightGray2)
                
                
            }.padding(.bottom,40)
            
            VStack(spacing: 21){
                VStack(alignment: .leading,spacing: 8){
                    Text("Notification interval")
                        .fontWeight(.semibold)
                        .lineLimit(22)
                    Text("How often would you like to receive notifications within the specified time interval")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity,minHeight: 42,alignment: .leading)
                }.frame(maxWidth: .infinity,maxHeight: 72,alignment: .leading)
                // Interval Grid
                VStack{
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        ForEach(intervals, id: \.self) { interval in
                            Button(action: {
                                selectedInterval = interval
                            }) {
//                                if interval >= 90 {
//                                    Text("\(interval) \n Mins")
//                                }else {
//                                    Text("\(interval / 60) \n Hours")
//                                }
                                Text(attributedString(for: interval))
                                    .font(.system(size: 17))
                                    .lineLimit(20)
                                    .frame(width: 77, height: 70)
                                    .foregroundColor(selectedInterval == interval ? .white : .skyBlue)
                                    .background(selectedInterval == interval ? Color.skyBlue : Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            
            Spacer()
           
            Button(action:{
                showOnboarding = false
                   }){
                Text("Start")
                    .frame(maxWidth: .infinity,maxHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.skyBlue)  // Replaced with default blue for clarity
                    .cornerRadius(12)
                    .padding(.vertical)
                    .padding(.bottom, 18)
            }
                   
                
        }//main vstack
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func attributedString(for interval: Int) -> AttributedString {
          var result = AttributedString()

          if interval < 120 {
              let minutesString = "\(interval) \n Mins"
              var attributedMinutes = AttributedString(minutesString)
              attributedMinutes.foregroundColor = .black // Color for "Mins"
              result += attributedMinutes
          } else {
              let hoursString = "\(interval / 60) \n Hours"
              var attributedHours = AttributedString(hoursString)
              attributedHours.foregroundColor = .black // Color for "Hours"
              result += attributedHours
          }

          return result
      }
}
