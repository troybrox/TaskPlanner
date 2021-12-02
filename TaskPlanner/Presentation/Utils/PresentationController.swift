//
//  PresentationController.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 30.11.2021.
//

import UIKit

class PresentationController: UIPresentationController {

    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.3),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                0.7))
    }

    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.95
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
      presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}


class SelectColorPresentationController : PresentationController {
    
    var heigntOfContentView: Int!
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: Int) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.heigntOfContentView = height
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard heigntOfContentView != nil else {
            return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.5),
                          size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.5))
        }
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - CGFloat(heigntOfContentView)),
               size: CGSize(width: self.containerView!.frame.width, height: CGFloat(heigntOfContentView)))
    }
}
