//
//  Onboarding2.swift
//  Hydrate
//
//  Created by Raghad on 21/10/2024.
//
import SwiftUI

struct OnboardingSecondView: View {
    
    //time picker func var
    @State private var selectedHour = 1
    @State private var selectedMinute = 0
    @State private var selectedPeriod = "AM"
    @State private var showTimePicker = false
    @State private var startHour = Date() // Internal 24-hour format
    
    let hours = Array(1...12)
    let minutes = Array(0..<60)
    let periods = ["AM", "PM"]
    
    ///
    

    @State private var StartHour = Date()
    @State private var endHour = Date()
    
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
                        
                }.frame(maxWidth: .infinity,alignment: .leading)
                VStack{
                    
                    //start time
                    HStack{
                        Text("Start hour")
                            .font(.system(size: 17))
                        Spacer()
                        
                        timePickerButton()
                        
                    }.padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //end time
                    HStack{
                        Text("End hour")
                            .font(.system(size: 17))
                        Spacer()
                        timePickerButton()
                        
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
        .onAppear{
            checkForPermission()
        }
        
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

    
    // Time Picker functions
    // Function to encapsulate the Time Picker Button with AM/PM Picker
    func timePickerButton() -> some View {
        HStack {
            // Button to display the time picker
            Button(action: {
                showTimePicker.toggle()
            }) {
                Text(formattedTime())
                    .font(.system(size: 16))
                    .padding()
                    .frame(maxWidth: 74, maxHeight: 34, alignment: .trailing)
                    .background(Color.lightGray2)
                    .foregroundStyle(.black)
                    .cornerRadius(8)
            }
            .padding()
            .sheet(isPresented: $showTimePicker) {
                timePickerSheet()
                    .presentationDetents([.medium]) // Adjust the sheet height to medium
            }

            // AM/PM Picker
            Picker("AM/PM", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 100, minHeight: 34)
            .cornerRadius(10)
        }
    }

    // Function to encapsulate the Time Picker Sheet
    func timePickerSheet() -> some View {
        VStack {
            HStack {
                // Hour Picker
                Picker("Select Hour", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 28, minHeight: 28, alignment: .trailing)
                .clipped()
                .font(.system(size: 13))

                // Minute Picker
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

            // Confirm button to save the selected time
            Button("Done") {
                convertTo24HourFormat()
                showTimePicker.toggle() // Close the sheet
            }
            .padding()
        }
    }

    // Convert the selected time to 24-hour format
    func convertTo24HourFormat() {
        var hourIn24Format = selectedHour
        if selectedPeriod == "PM" && selectedHour != 12 {
            hourIn24Format += 12 // Convert PM hours to 24-hour
        } else if selectedPeriod == "AM" && selectedHour == 12 {
            hourIn24Format = 0 // Handle 12 AM as midnight (00:00)
        }

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: startHour)
        components.hour = hourIn24Format
        components.minute = selectedMinute

        if let newDate = calendar.date(from: components) {
            startHour = newDate
        }
    }

    // Custom formatter to display only hour and minute, without AM/PM
    func formattedTime() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startHour)

        let hour = components.hour! % 12 == 0 ? 12 : components.hour! % 12 // Handle 12-hour format
        let minute = String(format: "%02d", components.minute!)

        return "\(hour):\(minute)" // Only display hour:minute, no AM/PM
    }
    
    
    
    
    
    //notification permission
    func checkForPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{ settings in
            switch settings.authorizationStatus {
            case .authorized:
                return
                //self.dispatchNotification(startHour: startHour, endHour: endHour, intervalMinutes: selectedInterval)
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        //self.dispatchNotification(startHour: startHour, endHour: endHour, intervalMinutes: selectedInterval)
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification(startHour: Date,_: (), endHour: Date,_: (), intervalMinutes: Int){
        let identifier = "myNotification1"
        let title = "Time to drink"
        let body = "It's time to drink water"
        let hour = 19 //4 PM
        let minute = 50
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calender = Calendar.current
        var dateComponents = DateComponents(calendar: calender, timeZone: TimeZone.current)
        
        for hour in stride(from: startHour, to: endHour, by: Date.Stride(intervalMinutes / 60)) {
            let minute = intervalMinutes % 60
            
            dateComponents.hour = minute
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
            let request = UNNotificationRequest(identifier: "\(identifier)_\(hour)_\(minute)", content: content, trigger: trigger)
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(identifier)_\(hour)_\(minute)"])
            notificationCenter.add(request){ error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
            
        }
    }
}
