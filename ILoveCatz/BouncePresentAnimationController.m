//
//  BouncePresentAnimationController.m
//  ILoveCatz
//
//  Created by Perry on 14-8-4.
//  Copyright (c) 2014年 com.razeware. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController

/**
 *  the transitionContext parameter gives you access to the to and from view controllers, the containing UIView, and other bits of context, You could query these properties to animate your transitions differently depending on the view controllers involved, but in this case you're using a two second transition all around.
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // length of the transition animation
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1. obtain state from the context
    /**
     *  Using the transition context, retrieve the view controller you're navigating to and the final frame the transition context should have when the animation is completed.
     */
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // 2. obtain the container view
    /**
     *  The views that correspond to the from- and to- view controllers are hosted within this container view throughout the animation. It's your responsibility to add the to- view to the container view.
     */
    UIView *containerView = [transitionContext containerView];
    
    // 3. set initial state
    /**
     *  Position the to- view just below the bottom of the screen.
     */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    
    // 4. add the view
    /**
     *  Add the to- view to the container view.
     */
    [containerView addSubview:toViewController.view];
    
    // 5. animate
    /**
     *  Animate the to- view, and set its final frame to the location supplied by the transition context.
     Note that the animation duration comes from the first protocol method.
     */
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         toViewController.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         // 6. inform the context of completion
                         /**
                          * Inform the transition context when the animation completes. The framework then ensures the final state is consistent and removes the from- view from the container.
                          */
                         [transitionContext completeTransition:YES];
                     }];
}

@end
