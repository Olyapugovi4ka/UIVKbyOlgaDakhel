//
//  Animator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 07/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    private let animationDuration: TimeInterval = 0.6
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        // 2. add it's view as a subview to the transition context container
        transitionContext.containerView.addSubview(destination.view)
        // 3. set view's anchor to the top right angle
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        // 4. set final target frame for destination view controller
        destination.view.frame = transitionContext.containerView.frame
        // 5. rotate view in order to set initial frame
        destination.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        // 6. run the animation
        UIView.animate(withDuration: animationDuration, animations: {
            destination.view.transform = .identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })    }
    
    
}
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning{
   
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        // 2. add it's view as a subview to the transition context container
        transitionContext.containerView.addSubview( destination.view)
        transitionContext.containerView.addSubview( source.view)
        // 3. set view's anchor to the top right angle
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        // 4. set final target frame for destination view controller
        source.view.frame = transitionContext.containerView.frame
        // 5. rotate view in order to set initial frame
        source.view.transform = .identity
        
        // 6. run the animation
        UIView.animate(withDuration: animationDuration, animations: {
            
            source.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                                            source.removeFromParent()
                                        } else if transitionContext.transitionWasCancelled {
                                            source.view.transform = .identity
                                        }
                                        transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
                        })

    }
    
}
