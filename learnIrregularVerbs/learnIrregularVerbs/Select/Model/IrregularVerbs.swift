//
//  IrregularVerbs.swift
//  Verb(сториборд)
//
//  Created by User on 19.11.2023.
//

import Foundation

final class IrregularVerbs {
    
    //Singleton
    static var shared = IrregularVerbs()
    private init() {
        configureVerbs()
    }
    
    // MARK: - Properties
    var selectedVerbs: [Verb] = []
    private(set) var verbs: [Verb] = []
    
    // MARK: - Methods
    private func configureVerbs(){
        verbs = [
            Verb(infinitive: "blow", pastSimple: "blew", participle: "blown"),
            Verb(infinitive: "draw", pastSimple: "drew", participle: "drawn"),
            Verb(infinitive: "break", pastSimple: "broke", participle: "broken"),
            Verb(infinitive: "come", pastSimple: "came", participle: "come"),
            Verb(infinitive: "do", pastSimple: "did", participle: "done"),
            Verb(infinitive: "drink", pastSimple: "drank", participle: "drunk")
        ]
    }
}
