//
//  Animator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 07/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
class Animator: NSObject,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    //MARK: Properties
    var presenting = true
    private let animationDuration: TimeInterval = 0.6
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let sourse = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        //let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        //let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        //if self.presenting {
         //   destination.view.transform = offScreenRight
        //} else {
        //    destination.view.transform = offScreenLeft
        //}
        
        
        // MARK: Rotate
        let pi = CGFloat(Double.pi)
        
        let offScreenRotateIn = CGAffineTransform(rotationAngle: -pi/2)
        let offScreenRotateOut = CGAffineTransform(rotationAngle: pi/2)
        
        destination.view.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        sourse.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        sourse.view.layer.position = CGPoint(x: 0, y: 0)
        
    
        
        container.addSubview(sourse.view)
        container.addSubview(destination.view)
        
        let duration = self.animationDuration
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.49,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: {
                        if self.presenting {
                            sourse.view.transform = offScreenRotateOut
                        } else {
                            sourse.view.transform = offScreenRotateIn
                        }
                            destination.view.transform = .identity},
                            completion: { finished in
                            transitionContext.completeTransition(finished)
                                })
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    private let animationDuration: TimeInterval = 0.6
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        // MARK: Rotate
        let pi = CGFloat(Double.pi)
        
        let offScreenRotateIn = CGAffineTransform(rotationAngle: -pi/2)
        //let offScreenRotateOut = CGAffineTransform(rotationAngle: pi/2)
        
        destination.view.transform = offScreenRotateIn
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        source.view.layer.position = CGPoint(x: 0, y: 0)
        
        container.addSubview(source.view)
        container.addSubview(destination.view)
        
        let duration = self.animationDuration
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.49,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: {
                            //sourse.view.transform = offScreenRotateOut
                        destination.view.transform = .identity},
                       completion: { finished in
                        transitionContext.completeTransition(finished)
        })
        
    }
    
    
}
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning{
   
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
       
        // MARK: Rotate
        let pi = CGFloat(Double.pi)
        
        //let offScreenRotateIn = CGAffineTransform(rotationAngle: -pi/2)
        let offScreenRotateOut = CGAffineTransform(rotationAngle: -pi/2)
        
        //source.view.transform = .identity //offScreenRotateOut
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        source.view.layer.position = CGPoint(x: 0, y: 0)
    
        
        container.addSubview(destination.view)
        container.addSubview(source.view)
        
        let duration = self.animationDuration
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.49,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: {
                        //sourse.view.transform = offScreenRotateOut
                        source.view.transform = offScreenRotateOut },
                       completion: { finished in
                        if finished && !transitionContext.transitionWasCancelled {
                            source.removeFromParent()
                        } else if transitionContext.transitionWasCancelled {
                            destination.view.transform = .identity
                        }
                        transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
        
    }
    
    
}
