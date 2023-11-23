//
//  Verb.swift
//  Verb(сториборд)
//
//  Created by User on 19.11.2023.
//

import Foundation

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    var translation: String {
        NSLocalizedString(self.infinitive, comment: "")
    }
}
