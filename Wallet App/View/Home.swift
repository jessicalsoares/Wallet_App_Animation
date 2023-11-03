//
//  Home.swift
//  Wallet App
//
//  Created by Jessica Soares on 03/11/2023.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button{
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                }
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4){
                    Text("Your Balance")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("$2950.89")
                        .font(.title2.bold())
                    
                }
            }
            .padding([.horizontal, .top], 15)
            
            //Card view
            Rectangle()
                .fill(.clear)
                .frame(height: 200)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    
                }
                .padding(.top, 30)
                .padding([.horizontal, .bottom], 15)
            }
            .background{
                //Custom Corner
            }
        }
    }
}

#Preview {
    ContentView()
}
