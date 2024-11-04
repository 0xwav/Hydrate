//
//  ViewModel.swift
//  Hydrate
//
//  Created by Raghad on 01/11/2024.
//

import SwiftUI

final class UserDefaultViewModel: ObservableObject {
    
    @AppStorage(Keys.litersTaken.id) var litersTaken: Double = 0.0
    @AppStorage(Keys.waterPerDay.id) var waterPerDay: Double = 0.0
    
    @AppStorage(Keys.lastWaterGoalDate.id) var lastWaterGoalDate: Date = Date.distantPast
    
    @AppStorage(Keys.hasSeenOnboarding.id) var hasSeenOnboarding: Bool = false
    @AppStorage(Keys.weight.id) var weight: String = ""
    @AppStorage(Keys.literPerDay.id) var literPerDay: Double = 0
   
    enum Keys {
        case litersTaken
        case waterPerDay
        case literPerDay
        case lastWaterGoalDate
        case hasSeenOnboarding
        case weight
        
        var id: String {
            "\(self)"
        }
    }
    
    
    //first page
    
    //rounds only the fractional part of a number
    func roundFractionalPartToTenth(_ value: Double) -> Double {
        let integerPart = floor(value)
        let fractionalPart = value - integerPart
        let roundedFractionalPart = round(fractionalPart * 10) / 10
        return integerPart + roundedFractionalPart
    }
    
    //the formula
    func getLiterPerDay()->Double{
        let W = Double(weight)
        literPerDay=roundFractionalPartToTenth((W ?? 0)*0.03)
        return literPerDay
    }
    
    
    //dashbourd func
    func resetIfNewDay() {
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
