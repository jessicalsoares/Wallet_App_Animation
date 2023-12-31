//
//  OverviewModel.swift
//  Wallet App
//
//  Created by Jessica Soares on 03/11/2023.
//

import SwiftUI

//Overview model wich is used to display last 4 months Income/Expens in the swift charts
struct OverviewModel: Identifiable{
    var id: UUID = .init()
    var type: OverviewType
    var value: [OverviewValue]
    
    struct OverviewValue: Identifiable{
        var id: UUID = .init()
        var month: Date
        var amount: Double
    }
}

enum OverviewType: String{
    case income = "Income"
    case expense = "Expense"
}

var sampleData: [OverviewModel] = [
    .init(type: .income, value: [
        .init(month: .addMonth(-4), amount: 3550),
        .init(month: .addMonth(-3), amount: 2984.6),
        .init(month: .addMonth(-2), amount: 1989.67),
        .init(month: .addMonth(-1), amount: 2987.3),
    ]),
    
    .init(type: .expense, value: [
        .init(month: .addMonth(-4), amount: 2891.6),
        .init(month: .addMonth(-3), amount: 1628.0),
        .init(month: .addMonth(-2), amount: 786),
        .init(month: .addMonth(-1), amount: 1987.3),
    ])
]

extension Date{
    static func addMonth(_ value: Int) -> Self {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: .init()) ?? .init()
    }
}
