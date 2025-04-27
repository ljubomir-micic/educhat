//
//  ErrorWrapper.swift
//  EduChat
//
//  Created by Љубомир Мићић on 18.6.22..
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
