//
//  SwiftUIView.swift
//  Hydrate
//
//  Created by Raghad on 29/10/2024.
//

import SwiftUI

struct splashScreen: View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .font(.largeTitle)
                    .foregroundStyle(.skyBlue)
                    .padding(.bottom,7.7)
                    .padding(.leading,4.2)
                Text("Hydrate")
                    .font(.title)
                    .foregroundStyle(.black)
    
            Spacer()
        }
    }
}

#Preview {
    splashScreen()
}
