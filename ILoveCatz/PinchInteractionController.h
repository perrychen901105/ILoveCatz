//
//  PinchInteractionController.h
//  ILoveCatz
//
//  Created by Perry on 14-8-5.
//  Copyright (c) 2014年 com.razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchInteractionController : UIPercentDrivenInteractiveTransition

- (void)wireToViewController:(UIViewController*)viewController;

@property (nonatomic, assign) BOOL interactionInProgress;

@end
