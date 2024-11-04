//
//  Onboarding1.swift
//  Hydrate
//
//  Created by Raghad on 21/10/2024.
//
import SwiftUI

struct OnboardingStartView: View {
    
    @EnvironmentObject private var userDefaults: UserDefaultViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var showOnboarding: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Spacer()
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 59)
                    .font(.largeTitle)
                    .foregroundStyle(.skyBlue)
                    .padding(.bottom,7.7)
                    .padding(.leading,4.2)
                
                VStack(alignment: .leading,spacing: 24){
                    
                    Text("Hydrate")
                        .font(.system(size: 22, weight: .semibold))
                        .lineLimit(28)
                    
                    Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated")
                        .font(.system(size: 17))
                        .lineLimit(22)
                        .foregroundStyle(.gray.opacity(0.8))
                        .frame(maxWidth: .infinity,minHeight: 66,alignment: .leading)
                        .padding(.bottom,11)
                    
                    HStack{
                        
                        Text("Body weight")
                            .lineLimit(22)
                            .padding(.horizontal)
                            .font(.system(size: 17))
                        
                        
                        TextField("Value", text: $userDefaults.weight)
                            .padding(.horizontal)
                            .frame(width:90 , height: 22)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        if !userDefaults.weight.isEmpty {
                            Button(action: {
                                userDefaults.weight = ""
                            }) {
                                Image(systemName: "x.circle.fill")
                                    .frame(width: 44, height: 44 ,alignment: .center)
                                    .font(.system(size: 17))
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .frame(width: 355,height: 44)
                    .background(Color.lightGray2)
                    
                }
                
                
                
                .padding(.bottom,110)
                Spacer()
                
                NavigationLink(
                    destination: OnboardingSecondView(showOnboarding: $showOnboarding),
                    label: {
                        Text("Calculate Now")
                            .frame(maxWidth: .infinity,maxHeight: 50)
                            .foregroundColor(.white)
                            .background(Color.skyBlue)  // Replaced with default blue for clarity
                            .cornerRadius(12)
                            .padding(.vertical)
                            .padding(.bottom, 18)

                    }).navigationBarBackButtonHidden(true)
                      .simultaneousGesture(
                        TapGesture().onEnded {
                            userDefaults.waterPerDay = userDefaults.getLiterPerDay() // Perform the calculation
                            print(userDefaults.waterPerDay) // Print result
                        }
                    )
            }
        }
        
        .padding()
        .ignoresSafeArea()
    }
    
}
