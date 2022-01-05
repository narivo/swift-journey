//
//  Extensions.swift
//  Challenge8
//
//  Created by MadiApps on 05/01/2022.
//

import UIKit


extension Int {
    func times(_ closure: (_ element: Int) -> Void) {
        for i in 0..<self {
            closure(i)
        }
    }
}

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: []) { [weak self] in
        //UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(_ item: Element) {
        for (idx, elem) in self.enumerated() {
            if elem == item {
                self.remove(at: idx)
            }
        }
    }
}
