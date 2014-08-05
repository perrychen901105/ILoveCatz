//
//  SwipeInteractionController.m
//  ILoveCatz
//
//  Created by Perry on 14-8-5.
//  Copyright (c) 2014年 com.razeware. All rights reserved.
//

#import "SwipeInteractionController.h"

@implementation SwipeInteractionController
{
    BOOL _shouldCompleteTransition;
    UINavigationController *_navigationController;

}

- (void)prepareGestureRecognizerInView:(UIView *)view
{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

- (void)wireToViewController:(UIViewController*)viewController
{
    _navigationController = viewController.navigationController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (CGFloat)completionSpeed
{
    NSLog(@"percent complete is %f", self.percentComplete);
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Start an interactive transition!
            /**
             *  When the gesture first starts, set the interactionInProgress property to YES and initiate a pop navigation. You'll see shortly how the wire-up code uses this property.
             */
            self.interactionInProgress = YES;
            [_navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. compute the current position
            /**
             *  While the gesture is in progress, compute a fraction that indicates how complete the transition is. In this case, a swipe of 200 points will cause the transition to be 100% complete, and should fully navigate to the to- view.
             */
            CGFloat fraction = - (translation.x / 200.0);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            
            // 3. should we complete?
            /**
             *  Determine whether the transition should complete if the gesture finishes at this location. In this case, if the users swipes at least halfway before releasing, then complete the transition.
             */
            _shouldCompleteTransition = (fraction > 0.5);
            
            // 4. update the animation
            /**
             *  Inform the object of the current position, This is all you need to do to ensure the animation from your animation controller plays correctly.
             */
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            // 5. finish or cancel
            /**
             *  Finally, invoke the finish or cancel methods of UIPercentDrivenInteractiveTransition based on the _shouldCompleteTransition instance variable set in step3.
             */
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
