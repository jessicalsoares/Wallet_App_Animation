//
//  CustomCorner.swift
//  Wallet App
//
//  Created by Jessica Soares on 03/11/2023.
//

import SwiftUI

struct CustomCorner: Shape{
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width:radius, height:radius))
        return Path(path.cgPath)
    }
}
