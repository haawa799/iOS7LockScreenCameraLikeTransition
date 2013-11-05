//
//  PercentDrivenTransition.h
//  InteractiveTransitionPlayground
//
//  Created by Andrew K. on 10/23/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentDrivenTransition : UIPercentDrivenInteractiveTransition

@property(nonatomic,strong) UIPanGestureRecognizer *pan;
@property(nonatomic,strong) UIViewController *viewController;

-(void)fingerUpWithLastVelocity:(CGPoint)velocity
                 withPercentage:(CGFloat)percentage;

@end
