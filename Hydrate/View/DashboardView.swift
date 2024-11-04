//
//  DashboardView.swift
//  Hydrate
//
//  Created by Raghad on 17/10/2024.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var userDefaults: UserDefaultViewModel
    @State private var showOnboarding: Bool = false
    var body: some View {
        
        VStack(alignment: .center){
            
            
            VStack(alignment: .leading,spacing: 8){
                Text("Today's Water Intake")
                    .font(.system(size:16))
                    .foregroundStyle(Color.darkGray)
                    .padding(.top,15.5)
                HStack{
                    if userDefaults.litersTaken == userDefaults.waterPerDay{
                        Text("\(String(format: "%.1f", userDefaults.litersTaken)) liter")
                            .font(.system(size:22 , weight: .bold))
                            .lineLimit(28)
                            .foregroundStyle(Color.green)
                    }else{
                        Text("\(String(format: "%.1f", userDefaults.litersTaken)) liter")
                            .font(.system(size:22 , weight: .bold))
                            .lineLimit(28)
                    }
                   
                    Text("/ \(String(format: "%.1f", userDefaults.waterPerDay)) liter")
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
                    .trim(from: 0.0, to: max(0.01, CGFloat(userDefaults.litersTaken / userDefaults.waterPerDay)))
                                //.trim(from: 0.01, to: CGFloat(litersTaken / waterPerDay))
                                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                                .foregroundColor(.skyBlue)
                                .rotationEffect(Angle(degrees: -90))// Rotate to start at the top
                                .frame(width: 313, height: 313)
                
                if userDefaults.litersTaken == userDefaults.waterPerDay {
                    Image(systemName: "hands.clap.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if userDefaults.litersTaken <= 0.4 * userDefaults.waterPerDay && userDefaults.litersTaken > 0.0 {
                    
                    
                    Image(systemName: "tortoise.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if userDefaults.litersTaken > 0.4 * userDefaults.waterPerDay && userDefaults.litersTaken > 0.0 && userDefaults.litersTaken < userDefaults.waterPerDay {
                    Image(systemName: "hare.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }else if userDefaults.litersTaken==0.0 {
                    Image(systemName: "zzz")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 76, weight: .light))
                }
            }.padding(.top, 15)
            

            Spacer()
            
            VStack(spacing: 16){
                Text("\(String(format: "%.1f", userDefaults.litersTaken)) L")
                    .font(.system(size:22 , weight: .bold))
                
                if userDefaults.litersTaken < userDefaults.waterPerDay {
                    Stepper("",
                            value:$userDefaults.litersTaken, in:0...userDefaults.waterPerDay,step: 0.1 ) .labelsHidden()
                }
            }.padding(.bottom,45)
        }//main vstack
        .padding()
        
        .onAppear {
            if !userDefaults.hasSeenOnboarding {showOnboarding = true}
            userDefaults.resetIfNewDay()
                }
        .fullScreenCover(isPresented: $showOnboarding , onDismiss:{
            // Once dismissed, update the storage so it won't show again
            userDefaults.hasSeenOnboarding = true
        }) {
            OnboardingStartView(showOnboarding: $showOnboarding)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
