//
//  DEAnimatedTransitioning.m
//  Shout!
//
//  Created by Andrew K. on 10/22/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import "AnimatedTransitioning.h"
#import <QuartzCore/QuartzCore.h>

static NSTimeInterval const AnimatedTransitionDuration = 0.9f;

@interface AnimatedTransitioning ()<UICollisionBehaviorDelegate>

@property(nonatomic) UIInterfaceOrientation orientation;

@end

@implementation AnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController  *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController  *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    NSLog(@"Rect = %@",NSStringFromCGRect(container.bounds));
    
    CGRect fromFrame = fromViewController.view.frame;
    CGRect toFrame = toViewController.view.frame;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    
    if(self.reverse)
    {
        toFrame = container.bounds;
        fromFrame = container.bounds;
        
        CGPoint toCurrentCenter;
        
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                toCurrentCenter = CGPointMake(CGRectGetMidX(container.bounds),
                                              -CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                toCurrentCenter = CGPointMake(CGRectGetMidX(container.bounds),
                                              3*CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationLandscapeLeft:
                toCurrentCenter = CGPointMake(-CGRectGetMidX(container.bounds),
                                              CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationLandscapeRight:
                toCurrentCenter = CGPointMake(3*CGRectGetMidX(container.bounds),
                                              CGRectGetMidY(container.bounds));
                break;
                
            default:
                break;
        }
        
        toViewController.view.center = toCurrentCenter;
        [container addSubview:fromViewController.view];
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:AnimatedTransitionDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            toViewController.view.center = CGPointMake(CGRectGetMidX(container.bounds),
                                                         CGRectGetMidY(container.bounds));
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }else
    {
        toFrame = container.bounds;
        fromFrame = container.bounds;
        toViewController.view.frame = toFrame;
        fromViewController.view.frame = fromFrame;
        [container addSubview:toViewController.view];
        [container addSubview:fromViewController.view];
        
        CGPoint newCenter;
        
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                newCenter = CGPointMake(CGRectGetMidX(container.bounds),
                                        -CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                newCenter = CGPointMake(CGRectGetMidX(container.bounds),
                                        3*CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationLandscapeLeft:
                newCenter = CGPointMake(-CGRectGetMidX(container.bounds),
                                        CGRectGetMidY(container.bounds));
                break;
            case UIInterfaceOrientationLandscapeRight:
                newCenter = CGPointMake(3*CGRectGetMidX(container.bounds),
                                        CGRectGetMidY(container.bounds));
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:AnimatedTransitionDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.center = newCenter;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimatedTransitionDuration;
}



@end
