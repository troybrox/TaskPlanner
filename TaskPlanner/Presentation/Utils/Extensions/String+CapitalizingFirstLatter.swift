//
//  String+CapitalizingFirstLatter.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 02.12.2021.
//

import Foundation


extension String {
    
    func capitalizeFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
}
