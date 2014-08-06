//
//  ShrinkDismissAnimationController.m
//  ILoveCatz
//
//  Created by Perry on 14-8-5.
//  Copyright (c) 2014年 com.razeware. All rights reserved.
//

#import "ShrinkDismissAnimationController.h"

@implementation ShrinkDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    
    // 1
    /**
     *  This time the to- view controller is stationary while the from- view controller slides down to reveal it. Hence, the initail position for the to- view controller is the same as its final position.
     */
    toViewController.view.frame = finalFrame;
    toViewController.view.alpha = 0.5;
    
    // 2
    /**
     *  Again, you are always responsible for adding the to- view to the container view. You want to slide out the from- view to reveal the underlying view, so the to- view is sent to the back.
     */
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    // 1. Determine the intermediate and final frame for the from view
    /**
     *  Calculate the intermediate and final frame for the from- view. The first step is to shrink it to half its size, and the second step is to move it to the bottom of the screen.
     */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect shrunkenFrame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width/4, fromViewController.view.frame.size.height/4);
    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // create a snapshot
    UIView *intermediateView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    intermediateView.frame = fromViewController.view.frame;
    [containerView addSubview:intermediateView];
    
    // remove the real view
    [fromViewController.view removeFromSuperview];
    
    // 2. animate with keyframes
    /**
     *  Initialize a key frame animation
     */
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  // 3a. keyframe one
                                  /**
                                   *    key frame one starts at a relative time of 0.0, with a relative duration of 0.5;
                                   */
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    intermediateView.frame = shrunkenFrame;
//                                                                    fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                                                    toViewController.view.alpha = 0.5;
                                                                }];
                                  // 3b. keyframe two
                                  /**
                                   *
                                   */
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    intermediateView.frame = fromFinalFrame;
//                                                                    fromViewController.view.frame = fromFinalFrame;
                                                                    toViewController.view.alpha = 1.0;
                                                                }];
                              } completion:^(BOOL finished) {
                                    // 4. inform the context of completion
                                    /**
                                     *
                                     */
                                  [intermediateView removeFromSuperview];
                                  [transitionContext completeTransition:YES];
                              }];
    
}

@end
