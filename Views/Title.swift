//
//  Title.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import SwiftUI

struct Title: View {
    var titleVar: String
    
    var body: some View {
        HStack {
            Text(titleVar)
                .font(.title)
                .bold()
                .padding(.top, 15)
                .padding(.leading, 3)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
