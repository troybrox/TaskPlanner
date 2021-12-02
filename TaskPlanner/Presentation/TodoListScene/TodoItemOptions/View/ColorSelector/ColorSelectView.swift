//
//  ColorSelectView.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 01.12.2021.
//

import UIKit

class ColorSelectView: UIViewController {
    
    var selectColorDelegate: SelectColorDelegate?
    var viewHeight: CGFloat {
        self.mainStackView.bounds.height + 38
    }
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var blueColorView: UIView!
    @IBOutlet weak var redColorView: UIView!
    @IBOutlet weak var greenColorView: UIView!
    @IBOutlet weak var yellowColorView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }

    // MARK: - Private
    
    private func setupViews() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        blueColorView.layer.cornerRadius = 12.0
        blueColorView.backgroundColor = .systemBlue
        let blueTapGesture = UITapGestureRecognizer(target: self, action: #selector(blueDidSelect))
        blueColorView.addGestureRecognizer(blueTapGesture)
        
        redColorView.layer.cornerRadius = 12.0
        redColorView.backgroundColor = .systemRed
        let redTapGesture = UITapGestureRecognizer(target: self, action: #selector(redDidSelect))
        redColorView.addGestureRecognizer(redTapGesture)
        
        greenColorView.layer.cornerRadius = 12.0
        greenColorView.backgroundColor = .systemGreen
        let greenTapGesture = UITapGestureRecognizer(target: self, action: #selector(greenDidSelect))
        greenColorView.addGestureRecognizer(greenTapGesture)
        
        yellowColorView.layer.cornerRadius = 12.0
        yellowColorView.backgroundColor = .systemYellow
        let yellowTapGesture = UITapGestureRecognizer(target: self, action: #selector(yellowDidSelect))
        yellowColorView.addGestureRecognizer(yellowTapGesture)
    }
    
    @objc private func blueDidSelect() {
        selectColorDelegate?.blueColorDidSelect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func redDidSelect() {
        selectColorDelegate?.redColorDidSelect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func greenDidSelect() {
        selectColorDelegate?.greenColorDidSelect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func yellowDidSelect() {
        selectColorDelegate?.yellowColorDidSelect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}


// MARK: - Height of view

extension ColorSelectView {
    
    func getHeight() -> CGFloat {
        return self.view.bounds.height
    }
}
