//
//  Home.swift
//  Wallet App
//
//  Created by Jessica Soares on 03/11/2023.
//

import SwiftUI
import Charts

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
            //Only used to Fetch the frame bounds and it's position in the screen
            CardsView()
            
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    BottomScrollContent()
                }
                .padding(.top, 30)
                .padding([.horizontal, .bottom], 15)
            }
            .frame(maxWidth: .infinity)
            .background{
                //Custom Corner
                CustomCorner(corners:[.topLeft, .topRight], radius: 30)
                    .fill(.white)
                    .ignoresSafeArea()
                //Adding Shadow
                    .shadow(color: .black.opacity(0.05), radius: 10, x:0, y:-5)
            }
        }
        .background{
            Rectangle()
                .fill(.black.opacity(0.05))
                .ignoresSafeArea()
        }
        .overlayPreferenceValue(CardRectKey.self) { preferences in
            if let cardPreference = preferences["CardRect"] {
                //Geometry reader is used to extract cgreact from the anchor
                GeometryReader { proxy in
                    let cardRect = proxy[cardPreference]
                    
                    CardContent()
                        .frame(width: cardRect.width, height: cardRect.height)
                    //Position it using offset
                        .offset(x: cardRect.minX, y:cardRect.minY)
                }
            }
        }
    }
    
    //Card Content
    func CardContent() -> some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(cards) { card in
                    CardView(card)
                        .frame(height: 200)
                }
            }
        }
    }
    
    //Card View
    @ViewBuilder
    func CardView(_ card: Card) -> some View{
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(card.cardColor.gradient)
                    .overlay(alignment: .top){
                        
                    }
            }
        }
    }
    
    //Cards View
    //Only used to Fetch the frame bounds and it's position in the screen
    @ViewBuilder
    func CardsView() -> some View{
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 245)
        //Fetching it's currente frame position via anchor preference
            .anchorPreference(key: CardRectKey.self, value: .bounds){ anchor in
                return["CardsRect":anchor]
                
            }
    }
    
    
    //Bottom scroll view content
    @ViewBuilder
    func BottomScrollContent() -> some View{
        VStack(spacing: 15){
            VStack(alignment: .leading, spacing: 8){
                Text("Insert Transfer")
                    .font(.title3.bold())
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 15){
                        ForEach(1...6, id: \.self){ index in
                            Image("Pic \(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55,height: 55)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                }
                //Removing horizontal padding and adding it inside the scrollview
                .padding(.horizontal, -15)
            }
            
            //swift charts - Displaying last four month Income/Expenses from overview model
            VStack(alignment:.leading, spacing: 8){
                HStack{
                    Text("Overview")
                        .font(.title3.bold())
                    
                    Spacer()
                    
                    Text("Last 4 Months")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Chart(sampleData){ overview in
                    ForEach(overview.value){ data in
                        BarMark(x: .value("Month", data.month, unit: .month), y: .value(overview.type.rawValue, data.amount))
                    }
                    .foregroundStyle(by: .value("Type", overview.type.rawValue))
                    //Positioning Bar Marks
                    .position(by: .value("Type", overview.type.rawValue))
                }
                //Custom chart foreground colors
                //We can also apply gradient directly from here
                .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
                .frame(height: 200)
                .padding(.top, 25)
            }
            .padding(.top, 15)
        }
    }
}

#Preview {
    ContentView()
}
