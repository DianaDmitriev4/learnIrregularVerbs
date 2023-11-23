//
//  UIView + extens.swift
//  learnIrregularVerbs
//
//  Created by User on 21.11.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
