//
//  ChooseDate.swift
//  EduChat
//
//  Created by Љубомир Мићић on 2.7.22..
//

import SwiftUI

struct ChooseDate: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker("Datum", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                    .shadow(radius: 5)
            )
            .padding()
    }
}

struct ChooseDate_Previews: PreviewProvider {
    @State static var datum = Date()
    
    static var previews: some View {
        ChooseDate(date: $datum)
    }
}

