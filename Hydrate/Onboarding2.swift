//
//  Onboarding2.swift
//  Hydrate
//
//  Created by Raghad on 21/10/2024.
//
import SwiftUI

struct OnboardingSecondView: View {
    
    @AppStorage("startHour") private var startHourData: Data = Date().toData()
     @AppStorage("endHour") private var endHourData: Data = Date().toData()
     
     // Convert Data to Date
     @State private var startHour: Date = Date()
     @State private var endHour: Date = Date()
     @State private var selectedHour = 1
     @State private var selectedMinute = 0
     @State private var selectedStartPeriod = "AM"  // AM/PM for start time
     @State private var selectedEndPeriod = "AM"    // AM/PM for end time
     @State private var showStartTimePicker = false
     @State private var showEndTimePicker = false
     @State private var isSelectingStartTime = true  // Indicates which time picker is active
     
     // Data arrays for hours, minutes, and periods (AM/PM)
     let hours = Array(1...12)
     let minutes = Array(0..<60)
     let periods = ["AM", "PM"]

    
    @State private var selectedInterval = 15
    var intervals = [15, 30, 60, 90, 120, 180, 240, 300] // In minutes
    let interval: Int? = nil
    
    @Binding var showOnboarding: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            //Notification Preferences
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
                        // .lineLimit(nil) // لإظهار كل النص
                        .frame(maxWidth: .infinity,minHeight: 42, alignment: .leading)
                    
                }.frame(maxWidth: .infinity,alignment: .leading)
           
                VStack(alignment: .center){
                
                        //start time
                        HStack{
                            Text("Start hour")
                                .font(.system(size: 17))
                            Spacer()
                            
                            timePickerButton(title: "Start Time", isStartTime: true)
                            
                        }.padding(.horizontal)
                        .frame(minHeight: 44,alignment: .center)
                        
                        
                        Divider()
                            .padding(.horizontal)
                        
                        //end time
                        HStack{
                            Text("End hour")
                                .font(.system(size: 17))
                            Spacer()
                            
                            timePickerButton(title: "End Time", isStartTime: false)
                        }.padding(.horizontal)
                        .frame(minHeight: 44,alignment: .center)
                        
                   
                    
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
                                Text(attributedString(for: interval, isSelected: selectedInterval == interval))
                                    .font(.system(size: 17))
                                    .lineLimit(20)
                                    .frame(width: 77, height: 70)
                                    .foregroundColor(.clear)
                                //.foregroundColor(selectedInterval == interval ? .white : .gray)
                                    .background(selectedInterval == interval ? Color.skyBlue : Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                    }//LazyVGrid end
                }
            }
            
            Spacer()
            
            Button(action:{
                showOnboarding = false
                requestNotificationPermission()
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
       // .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
                    // Load the saved dates if available
                    if let storedStartHour = Date.fromData(startHourData) {
                        startHour = storedStartHour
                    }
                    if let storedEndHour = Date.fromData(endHourData) {
                        endHour = storedEndHour
                    }
                }
    }
    
    func printprint(){
        print("start hour: \(startHourData)")
        print("end hour: \(endHourData)")
    }
    
    //LazyVGrid text attribute
    func attributedString(for interval: Int, isSelected: Bool) -> AttributedString {
        let numberColor: Color = isSelected ? .white : .skyBlue
        let textColor: Color = isSelected ? .white : .black
        
        if interval < 120 {
            let minutesString = "\(interval)"
            let minText = "\n Mins"
            
            var attributedMinutes = AttributedString(minutesString)
            attributedMinutes.foregroundColor = numberColor  // Color for the number
            
            var attributedMinutesText = AttributedString(minText)
            attributedMinutesText.foregroundColor = textColor // Color for "Mins"
            
            return attributedMinutes + attributedMinutesText
        } else {
            let hoursString = "\(interval / 60)"
            let hoursText = "\n Hours"
            
            var attributedHours = AttributedString(hoursString)
            attributedHours.foregroundColor = numberColor // Color for the number
            
            var attributedHoursText = AttributedString(hoursText)
            attributedHoursText.foregroundColor = textColor // Color for "Hours"
            
            return attributedHours + attributedHoursText
        }
    }
    
    
    // Function to save the notification preferences (backend-like functionality)
    func saveNotificationPreferences() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let startHourString = formatter.string(from: startHour)
        let endHourString = formatter.string(from: endHour)
        
        // Saving preferences (you can modify this to save in UserDefaults or backend API)
        print("Start Hour: \(startHourString)")
        print("End Hour: \(endHourString)")
        print("Selected Interval: \(selectedInterval)")
        
        // Simulate saving to UserDefaults (or backend)
        UserDefaults.standard.set(startHourString, forKey: "startHour")
        UserDefaults.standard.set(endHourString, forKey: "endHour")
        UserDefaults.standard.set(selectedInterval, forKey: "notificationInterval")
    }
    
    // Function to schedule notifications based on selected preferences
    /* func scheduleNotifications() {
     // Request permission for notifications
     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
     if granted {
     // Remove any previously scheduled notifications
     UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
     
     let calendar = Calendar.current
     
     // Calculate interval in minutes from the selected interval string
     let intervalMinutes: Int = {
     let parts = selectedInterval.components(separatedBy: " ")
     if let value = Int(parts[0]) {
     return parts[1].lowercased().contains("hour") ? value * 60 : value
     }
     return 15
     }()
     
     var currentDate = startHour
     
     while currentDate < endHour {
     let components = calendar.dateComponents([.hour, .minute], from: currentDate)
     
     let content = UNMutableNotificationContent()
     content.title = "Stay Hydrated!"
     content.body = "Remember to drink water and stay hydrated."
     content.sound = UNNotificationSound.default
     
     // Schedule the notification for the current time
     let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
     let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
     UNUserNotificationCenter.current().add(request)
     
     // Increment the currentDate by the interval chosen by the user
     currentDate = calendar.date(byAdding: .minute, value: intervalMinutes, to: currentDate) ?? currentDate
     }
     } else if let error = error {
     print("Notification permission denied: \(error.localizedDescription)")
     }
     }
     }
     */
    
    //--------------------------------------------------------------------
    // TESTING 5 SEC
    func scheduleNotifications() {
        // Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                // Remove any previously scheduled notifications
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
                // Set the interval to 5 seconds for testing purposes
                let intervalSeconds = 5
                
                // For testing, schedule 10 notifications with a 5-second interval
                let numberOfNotifications = 10
                
                for i in 0..<numberOfNotifications {
                    let content = UNMutableNotificationContent()
                    content.title = "Stay Hydrated!"
                    content.body = "Remember to drink water and stay hydrated."
                    content.sound = UNNotificationSound.default
                    
                    // Use UNTimeIntervalNotificationTrigger, making sure the timeInterval is greater than 0
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((i + 1) * intervalSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            print("Scheduled notification \(i + 1)")
                        }
                    }
                }
            } else if let error = error {
                print("Notification permission denied: \(error.localizedDescription)")
            }
        }
    }
    
    
    ///------------------------------------------------------------------------------------------------
    
    // Button that shows the time picker in a sheet
       func timePickerButton(title: String, isStartTime: Bool) -> some View {
           HStack {
               Button(action: {
                   // Toggle the appropriate time picker sheet
                   isSelectingStartTime = isStartTime
                   if isStartTime {
                       showStartTimePicker.toggle()
                   } else {
                       showEndTimePicker.toggle()
                   }
               }) {
                   Text(isStartTime ? formattedTime(for: startHour) : formattedTime(for: endHour)) // Displays the selected time
                       .font(.system(size: 17))
                       .padding()
                       .frame(maxWidth: 74, maxHeight: 34, alignment: .trailing)
                       .background(Color.gray.opacity(0.2))
                       .foregroundStyle(.black)
                       .cornerRadius(8)
               }
               .padding()
               .sheet(isPresented: isStartTime ? $showStartTimePicker : $showEndTimePicker) {
                   // Show the appropriate time picker in a modal sheet
                   timePickerSheet()
               }
               
               // Separate AM/PM picker for start and end time
               Picker("AM/PM", selection: isStartTime ? $selectedStartPeriod : $selectedEndPeriod) {
                   ForEach(periods, id: \.self) { period in
                       Text(period).tag(period)
                   }
               }
               .pickerStyle(SegmentedPickerStyle())
               .frame(maxWidth: 100, minHeight: 34)
               .cornerRadius(10)
           }
       }
       
       // Time picker sheet with wheel-style pickers for hours and minutes
       func timePickerSheet() -> some View {
           VStack {
               HStack {
                   Picker("Select Hour", selection: $selectedHour) {
                       ForEach(hours, id: \.self) { hour in
                           Text("\(hour)").tag(hour)
                       }
                   }
                   .pickerStyle(WheelPickerStyle())
                   .frame(minWidth: 28, minHeight: 28, alignment: .trailing)
                   .clipped()
                   
                   Picker("Select Minute", selection: $selectedMinute) {
                       ForEach(minutes, id: \.self) { minute in
                           Text(String(format: "%02d", minute)).tag(minute)
                       }
                   }
                   .pickerStyle(WheelPickerStyle())
                   .frame(minWidth: 28, minHeight: 28, alignment: .trailing)
                   .clipped()
               }
               .padding()
               
               // Done button to save selected time and close the picker
               Button("Done") {
                   convertTo24HourFormat()
                   saveTimeToStorage()
                   if isSelectingStartTime {
                       showStartTimePicker.toggle()
                   } else {
                       showEndTimePicker.toggle()
                   }
               }
               .padding()
           }
       }
       
       // Converts selected time into 24-hour format and updates the binding
       func convertTo24HourFormat() {
           var hourIn24Format = selectedHour
           
           // Check selected period for each time
           let selectedPeriod = isSelectingStartTime ? selectedStartPeriod : selectedEndPeriod
           if selectedPeriod == "PM" && selectedHour != 12 {
               hourIn24Format += 12
           } else if selectedPeriod == "AM" && selectedHour == 12 {
               hourIn24Format = 0
           }
           
           var components = Calendar.current.dateComponents([.year, .month, .day], from: isSelectingStartTime ? startHour : endHour)
           components.hour = hourIn24Format
           components.minute = selectedMinute
           
           if let newDate = Calendar.current.date(from: components) {
               if isSelectingStartTime {
                   startHour = newDate
               } else {
                   endHour = newDate
               }
           }
       }
       
       // Saves the selected time to storage
       func saveTimeToStorage() {
           startHourData = startHour.toData()
           endHourData = endHour.toData()
       }
       
       // Formats the selected time in 12-hour format
       func formattedTime(for date: Date) -> String {
           let components = Calendar.current.dateComponents([.hour, .minute], from: date)
           
           let hour = components.hour! % 12 == 0 ? 12 : components.hour! % 12
           let minute = String(format: "%02d", components.minute!)
           
           return "\(hour):\(minute)"
       }

// Extensions to convert Date to Data and vice versa

    
    
    //Notification
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
    
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time for your scheduled reminder!"
        content.sound = .default
        
        // Set a trigger for a specific date and time
        var dateComponents = DateComponents()
        dateComponents.second = 14 // Set your desired hour
        dateComponents.minute = 0 // Set your desired minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
}

extension Date {
    func toData() -> Data {
        try! JSONEncoder().encode(self)
    }
    
    static func fromData(_ data: Data) -> Date? {
        try? JSONDecoder().decode(Date.self, from: data)
    }
}
