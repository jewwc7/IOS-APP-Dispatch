//
//  MyDatePicker.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/26/24.
//

import SwiftUI

struct MyDatePicker: View {
    // @State private var date = Date()
    @Binding var date: Date
    var title: String = ""

    let dateRange: ClosedRange<Date> = {
        let daysPastToday = 30
        let calendar = Calendar.current
        let now = Date()
        let startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(byAdding: .day, value: daysPastToday, to: startDate)!
        return startDate ... endDate // CLosedRange Operator,  It creates a range that includes both the lower bound (startDate) and the upper bound ( endDate )
    }()

    var body: some View {
        DatePicker(
            title,
            selection: $date,
            in: dateRange,
            displayedComponents: [.date, .hourAndMinute]
        )
    }
}

// #Preview {
//    MyDatePicker()
// }
