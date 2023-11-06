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
    
    //Animation Properties
    @State private var expandCards: Bool = false
    
    //Detail Card Properties
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button{
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
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
                .padding(.horizontal, 15)
            
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
            .padding(.top, 20)
        }
        .background{
            Rectangle()
                .fill(.black.opacity(0.05))
                .ignoresSafeArea()
        }
        .overlay(content:{
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    //top navigation
                    HStack{
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .contentShape(Rectangle())
                            .onTapGesture{
                                withAnimation(.easeInOut(duration: 0.3)){
                                    expandCards = false
                                }
                            }
                        Spacer()
                        
                        Text("All Cards")
                            .font(.title2.bold())
                    }
                    .padding(15)
                })
                .opacity(expandCards ? 1 : 0)
        })
        .overlayPreferenceValue(CardRectKey.self) { preferences in
            if let cardPreference = preferences["CardRect"] {
                //Geometry reader is used to extract cgreact from the anchor
                GeometryReader { proxy in
                    let cardRect = proxy[cardPreference]
                    
                    CardContent()
                        .frame(width: cardRect.width, height: expandCards ? nil : cardRect.height)
                    //Position it using offset
                        .offset(x: cardRect.minX, y:cardRect.minY)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                expandCards = true
                            }
                        }
                }
            }
        }
    }
    
    //Card Content
    func CardContent() -> some View{
        ScrollView(.vertical, showsIndicators: false) {
            //Expanding Cards when tapped
            VStack(spacing: 0) {
                //To show firts card on top
                //Simply reverse the array
                ForEach(cards.reversed()) { card in
                    let index = CGFloat(indexOf(card))
                    let reversedIndex = CGFloat(cards.count - 1) - index
                    
                    //Displaying first three cards on the stack
                    let displayingStackIndex = min(index, 2)
                    let displayScale = (displayingStackIndex / CGFloat(cards.count)) * 0.15
                    CardView(card)
                    //Aplying 3d rotation
                        .rotation3DEffect(.init(degrees: expandCards ? -15 : 0),
                                          axis: (x: 1, y: 0, z: 0), anchor: .top)
                        .frame(height: 200)
                    //Applying scaling
                        .scaleEffect(1 - (expandCards ? 0 : displayScale))
                        .offset(y: expandCards ? 0 : (displayingStackIndex * -15))
                    //Stacking one an Another
                        .offset(y: reversedIndex * -200)
                        .padding(.top, expandCards ? (reversedIndex == 0 ? 0 : 80) : 0)
                }
            }
            //Appling remaining height as padding
            .padding(.top, 45)
            //Reducing size
            .padding(.bottom, CGFloat(cards.count - 1) * -200)
        }
        //Disabling Scroll
        .scrollDisabled(!expandCards)
    }
    
    //Card Index
    func indexOf(_ card: Card) -> Int{
        return cards.firstIndex {
            card.id == $0.id
        } ?? 0
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
                        VStack{
                            HStack{
                                Image("Sim")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 55,height: 55)
                                
                                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Text(card.cardBalance)
                                .font(.title2.bold())
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                .offset(y:5)
                        }
                        .padding(20)
                        .foregroundColor(.black)
                    }
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3.5)
                
                //Card Details
                    .overlay{
                        HStack{
                            Text(card.cardName)
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                            
                            Image("Visa")
                                .resizable()
                                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                        .foregroundColor(.white)
                        .padding(15)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
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
                return["CardRect":anchor]
                
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
