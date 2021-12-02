//
//  UIView+ShadowCardView.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 30.11.2021.
//

import UIKit

extension UIView {
    
    func setShadowCardView() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
}
