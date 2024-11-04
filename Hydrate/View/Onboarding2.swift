//
//  Onboarding2.swift
//  Hydrate
//
//  Created by Raghad on 21/10/2024.
//
import SwiftUI
import UserNotifications

struct OnboardingSecondView: View {
    
    @AppStorage("startHour") private var startHourData: Date = Date.distantPast
    @AppStorage("endHour") private var endHourData: Date = Date.distantPast
    
    // Convert Data to Date
    @State private var startHour: Date = Date()
    @State private var endHour: Date = Date()
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
    
    @Binding var showOnboarding: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            // Notification Preferences
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
                        .frame(maxWidth: .infinity,minHeight: 42, alignment: .leading)
                }.frame(maxWidth: .infinity,alignment: .leading)
           
                VStack(alignment: .center){
                
                    // Start time
                    HStack{
                        Text("Start hour")
                            .font(.system(size: 17))
                        Spacer()
                        
                        timePickerButton(title: "Start Time", isStartTime: true)
                    }.padding(.horizontal)
                    .frame(minHeight: 44,alignment: .center)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // End time
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
                requestNotificationPermission()
                
                print(startHourData)
                print(endHourData)
                print(selectedInterval)

                // Call the notification scheduling function with StartHour and EndHour
                scheduleNotification(startTime: startHourData, endTime: endHourData, repeatInterval: selectedInterval)
                
            }){
                Text("Start")
                    .frame(maxWidth: .infinity,maxHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.skyBlue)  // Replaced with default blue for clarity
                    .cornerRadius(12)
                    .padding(.vertical)
                    .padding(.bottom, 18)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Load the saved dates if available
        }
    }
    
    // LazyVGrid text attribute
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
    
    // Function to request notification permissions
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
    
    // Function to schedule notifications based on selected preferences
    func scheduleNotification(startTime: Date, endTime: Date, repeatInterval: Int) {
        // Set up the notification content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time for your scheduled reminder!"
        content.sound = .default
        
        // Calculate the difference between start and end time in minutes
        let interval = Int(endTime.timeIntervalSince(startTime) / 60)
        
        // Ensure the repeat interval is smaller than the total time range
        guard interval >= repeatInterval else {
            print("The repeat interval is too large for the specified time range.")
            return
        }
        
        // Create multiple notification requests based on the repeat interval
        for i in stride(from: 0, to: interval, by: repeatInterval) {
            // Calculate the upcoming notification time
            let triggerTime = Calendar.current.date(byAdding: .minute, value: i, to: startTime)!
            
            // Set up date components for the trigger time
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerTime)
            
            // Create the trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            // Create the notification request
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Schedule the notification
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled at \(triggerTime)")
                }
            }
        }
    }
    
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
                HStack {
                    Text(isStartTime ? formattedTime(for: startHour) : formattedTime(for: endHour)) // Displays the selected time
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Display AM/PM
                    Text(isStartTime ? selectedStartPeriod : selectedEndPeriod)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: isStartTime ? $showStartTimePicker : $showEndTimePicker) {
            // Time picker view
            TimePickerView(selectedHour: isStartTime ? $startHour : $endHour, selectedPeriod: isStartTime ? $selectedStartPeriod : $selectedEndPeriod)
        }
    }

    // Format the time for display
    func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm" // Format for hour and minute
        return formatter.string(from: date)
    }
}

struct TimePickerView: View {
    @Binding var selectedHour: Date
    @Binding var selectedPeriod: String
    
    // State variables for picker values
    @State private var selectedHourValue: Int = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinuteValue: Int = Calendar.current.component(.minute, from: Date())
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Picker("Hour", selection: $selectedHourValue) {
                    ForEach(1..<13) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Picker("Minute", selection: $selectedMinuteValue) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(["AM", "PM"], id: \.self) { period in
                        Text(period).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            Button("Done") {
                // Update the selected hour based on the picker values and period
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: selectedHour)
                components.hour = selectedHourValue % 12 + (selectedPeriod == "PM" ? 12 : 0) // Adjust for AM/PM
                components.minute = selectedMinuteValue
                if let newDate = calendar.date(from: components) {
                    selectedHour = newDate
                }
                
                // Dismiss the view
                dismiss()
            }
            .padding()
        }
    }
}
