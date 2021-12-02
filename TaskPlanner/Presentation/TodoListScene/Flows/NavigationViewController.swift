//
//  NavigationViewController.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 27.10.2021.
//

import UIKit

class NavigationViewController: UINavigationController {

    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Next Demi Bold", size: 18)!]
    }
}
