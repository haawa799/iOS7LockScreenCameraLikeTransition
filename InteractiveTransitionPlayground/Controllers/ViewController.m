//
//  ViewController.m
//  InteractiveTransitionPlayground
//
//  Created by Andrew K. on 10/22/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import "ViewController.h"
#import "ToViewController.h"
#import "AnimatedTransitioning.h"
#import "PercentDrivenTransition.h"

@interface ViewController ()

@property(nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong) ToViewController *to;
@property(nonatomic,strong) PercentDrivenTransition *percentDT;
@property(nonatomic,strong) AnimatedTransitioning *animatedTransitioning;


@end

@implementation ViewController

-(void)presentSecondController
{
    self.to = [[ToViewController alloc]initWithNibName:@"ToViewController"
                                                bundle:nil];
    self.to.transitioningDelegate = self;
    self.to.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:self.to animated:YES completion:NULL];
}

-(IBAction)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint pointInPanView = [pan translationInView:pan.view];
    CGPoint pointInControllerView = CGPointMake(pointInPanView.x + pan.view.frame.origin.x,
                                                pointInPanView.y + pan.view.frame.origin.y + (self.view.bounds.size.height - self.handleButton.center.y));
    
    CGFloat height = self.view.bounds.size.height;
    CGFloat percentage = 1 - pointInControllerView.y / height;
    
    CGPoint velocity = [pan velocityInView:self.view];
    //    CGFloat distanceToGo = pointInControllerView.y;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self presentSecondController];
            break;
        case UIGestureRecognizerStateChanged:
            [self.percentDT updateInteractiveTransition:percentage];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateRecognized:
            [self.percentDT fingerUpWithLastVelocity:velocity
                                      withPercentage:percentage];
            break;
            
        default:
            break;
    }
}

//==========================================================
#pragma mark - UIViewControllerTransitioningDelegate
//==========================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    AnimatedTransitioning *transitioning = [[AnimatedTransitioning alloc]init];
    self.animatedTransitioning = transitioning;
    return transitioning;
}

-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    AnimatedTransitioning *transitioning = [[AnimatedTransitioning alloc]init];
    self.animatedTransitioning = transitioning;
    transitioning.reverse = YES;
    return transitioning;
}


- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    self.percentDT = [[PercentDrivenTransition alloc]init];
    return self.percentDT;
}


@end
