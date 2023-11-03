//
//  ContentView.swift
//  Wallet App
//
//  Created by Jessica Soares on 03/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            Home(size: size)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
