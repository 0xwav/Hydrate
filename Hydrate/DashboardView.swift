//
//  DashboardView.swift
//  Hydrate
//
//  Created by Raghad on 17/10/2024.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("litersTaken") var litersTaken: Double = 0.0
    @AppStorage("waterPerDay") var waterPerDay: Double = 0.0
    
    @AppStorage("lastWaterGoalDate") var lastWaterGoalDate: Date = Date.distantPast
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showOnboarding: Bool = false
    var body: some View {
        
        VStack(alignment: .center){
            
            
            VStack(alignment: .leading,spacing: 8){
                Text("Today's Water Intake")
                    .font(.system(size:16))
                    .foregroundStyle(Color.darkGray)
                    .padding(.top,15.5)
                HStack{
                    if litersTaken == waterPerDay{
                        Text("\(String(format: "%.1f", litersTaken)) liter")
                            .font(.system(size:22 , weight: .bold))
                            .lineLimit(28)
                            .foregroundStyle(Color.green)
                    }else{
                        Text("\(String(format: "%.1f", litersTaken)) liter")
                            .font(.system(size:22 , weight: .bold))
                            .lineLimit(28)
                    }
                   
                    Text("/ \(String(format: "%.1f", waterPerDay)) liter")
                        .font(.system(size:22 , weight: .bold))
                        .lineLimit(28)
                }
            }.frame(maxWidth: .infinity,minHeight: 57,alignment: .leading)
            //progress circle
            Spacer()
            
            ZStack {
                        
                            Circle()
                                .stroke(lineWidth: 30)
                                .opacity(0.3)
                                .foregroundColor(.lightGray2)
                                .frame(width: 313, height: 313)
                            
                            Circle()
                                .trim(from: 0.0, to: max(0.01, CGFloat(litersTaken / waterPerDay)))
                                //.trim(from: 0.01, to: CGFloat(litersTaken / waterPerDay))
                                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                                .foregroundColor(.skyBlue)
                                .rotationEffect(Angle(degrees: -90))// Rotate to start at the top
                                .frame(width: 313, height: 313)
                
                if litersTaken == waterPerDay {
                    Image(systemName: "hands.clap.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if litersTaken <= 0.4 * waterPerDay && litersTaken > 0.0 {
                    
                    
                    Image(systemName: "tortoise.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if litersTaken > 0.4 * waterPerDay && litersTaken > 0.0 && litersTaken < waterPerDay {
                    Image(systemName: "hare.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if litersTaken==0.0 {
                    Image(systemName: "zzz")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }
            }.padding(.top, 15)
            

            Spacer()
            
            VStack(spacing: 16){
                Text("\(String(format: "%.1f", litersTaken)) L")
                    .font(.system(size:22 , weight: .bold))
                
                if litersTaken < waterPerDay {
                    Stepper("",
                            value:$litersTaken, in:0...waterPerDay,step: 0.1 ) .labelsHidden()
                }
            }.padding(.bottom,45)
        }//main vstack
        .padding()
        
        .onAppear {
            if !hasSeenOnboarding {showOnboarding = true}
            resetIfNewDay()
                }
        .fullScreenCover(isPresented: $showOnboarding , onDismiss:{
            // Once dismissed, update the storage so it won't show again
            hasSeenOnboarding = true
        }) {
            OnboardingStartView(showOnboarding: $showOnboarding)
        }
    }
    private func resetIfNewDay() {
            // Get the current date
            let currentDate = Date()
            
            // Check if the last goal date is different from today
            if Calendar.current.isDateInToday(lastWaterGoalDate) == false {
                // Reset the litersTaken and update the last goal date
                litersTaken = 0
                lastWaterGoalDate = currentDate
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
