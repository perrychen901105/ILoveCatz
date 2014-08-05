//
//  FlipAnimationController.m
//  ILoveCatz
//
//  Created by Perry on 14-8-5.
//  Copyright (c) 2014年 com.razeware. All rights reserved.
//

#import "FlipAnimationController.h"

@implementation FlipAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (CATransform3D) yRotation:(CGFloat) angle {
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. the usual stuff...
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    [containerView addSubview:toVC.view];
    
    // 2. Add a perspective transform
    /**
     *  Add a perspective transform to the container view
     */
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // 3. Give both VCs the same start frame
    /**
     *  Give both the from- and to- view the same frame
     */
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    // 4. REVERSE
    /**
     *  Using the reverse property, create a factor that negates the rotation angles used later on in the transition.
     */
    float factor = self.reverse ? 1.0 : -1.0;
    
    // 5. flip the to VC halfway round - hiding it
    /**
     *  The to- view should not be visible initially. To achieve this, rotate it 90 degrees around its y-axis so that its zero-width edge is head-on.
     */
    toView.layer.transform = [self yRotation:factor * -M_PI_2];
    
    // 6. Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0 animations:^{
                                     [UIView addKeyframeWithRelativeStartTime:0.0
                                                             relativeDuration:0.5
                                                                   animations:^{
                                                                       // 7. rotate the from view
                                                                       /**
                                                                        *   The first step of the key-frame animation rotates the from- view by 90 degrees along its y-axis. Once it has reached this angle, it will be invisible.
                                                                        */
                                                                 fromView.layer.transform = [self yRotation:factor * M_PI_2];
                                                             }];
                                     [UIView addKeyframeWithRelativeStartTime:0.5
                                                             relativeDuration:0.5
                                                                   animations:^{
                                                                       // 8. rotate the to view
                                                                       /**
                                                                        *   The second step reveals the to- view by rotating it 90 degrees.
                                                                        */
                                                                       toView.layer.transform = [self yRotation:0.0];
                                                                   }];
                                 } completion:^(BOOL finished) {
                                     [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                 }];
    
}

@end
