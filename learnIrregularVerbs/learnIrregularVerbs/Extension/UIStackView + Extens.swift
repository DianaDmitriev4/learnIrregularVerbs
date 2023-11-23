//
//  UIStackView + Extens.swift
//  learnIrregularVerbs
//
//  Created by User on 21.11.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
