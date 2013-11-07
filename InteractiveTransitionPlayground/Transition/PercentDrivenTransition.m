//
//  PercentDrivenTransition.m
//  InteractiveTransitionPlayground
//
//  Created by Andrew K. on 10/23/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import "PercentDrivenTransition.h"


#define GRAVITY_STRENGTH 8
#define FORCE_MULTIPLIER 4

#define FLOOR_COLISION_IDENTIFIER @"Bottom"
#define TOP_COLISION_IDENTIFIER @"TOP"


@interface PercentDrivenTransition ()<UICollisionBehaviorDelegate>

@property(nonatomic,strong) UIDynamicAnimator *animator;
@property(nonatomic,strong) id<UIViewControllerContextTransitioning> transitionContext;

@property(nonatomic,strong) UIViewController *fromViewController;
@property(nonatomic,strong) UIViewController *toViewController;
@property(nonatomic,strong) UIView *container;

@property(nonatomic) UIInterfaceOrientation orientation;

@property(nonatomic) BOOL isFalling;
@property(nonatomic) BOOL isUpdating;
@property(nonatomic) BOOL finishing;

@property(nonatomic) BOOL bouncedOnce;
@property(nonatomic) CGFloat heightToReleasePoint;

@end

@implementation PercentDrivenTransition

//======================================================
#pragma mark - UIPercentDrivenInteractiveTransition
//======================================================

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super startInteractiveTransition:transitionContext];
    self.transitionContext = transitionContext;
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.container = [transitionContext containerView];
}

-(void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];
    
    if(percentComplete >= 0.90)
    {
        [self finishInteractiveTransition];
        self.finishing = YES;
    }
}

-(void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    [self.animator removeAllBehaviors];
}

-(void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];
    [self.animator removeAllBehaviors];
}

-(void)fingerUpWithLastVelocity:(CGPoint)velocity
                 withPercentage:(CGFloat)percentage
{
    if(!self.finishing)
    {
        if(percentage <= 0.03)
            [self cancelInteractiveTransition];
        else
        {
            self.heightToReleasePoint = percentage * self.fromViewController.view.bounds.size.height;
            [self addGravityWithVelocity:velocity];
        }
    }
}

//=================================================
#pragma mark - UIDynamicsRelated
//=================================================

-(void)addGravityWithVelocity:(CGPoint)velocity
{
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.container];
    
    self.orientation = [[UIApplication sharedApplication]statusBarOrientation];
    
    [self addGravity];
    [self addFloorCollision];
    [self addTopCollision];
    [self addItemBehaviour];
    [self addForceForVelocity:velocity];
    
    self.isFalling = YES;
}

-(void)addFloorCollision
{
    CGPoint firstPoint;
    CGPoint secondPoint;
    
    CGFloat MARGIN = 1;
    
    switch (self.orientation) {
        case UIInterfaceOrientationPortrait:
            firstPoint =  CGPointMake(0,
                                      self.container.bounds.size.height+MARGIN);
            secondPoint = CGPointMake(self.container.bounds.size.width,
                                      self.container.bounds.size.height+MARGIN);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            firstPoint =  CGPointMake(0,
                                      0 - MARGIN);
            secondPoint = CGPointMake(self.container.bounds.size.width,
                                      0 - MARGIN);
            break;
        case UIInterfaceOrientationLandscapeRight:
            firstPoint =  CGPointMake(-MARGIN,
                                      0);
            secondPoint = CGPointMake(-MARGIN,
                                      self.container.bounds.size.height);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            firstPoint =  CGPointMake(self.container.bounds.size.width + MARGIN,
                                      0);
            secondPoint = CGPointMake(self.container.bounds.size.width + MARGIN,
                                      self.container.bounds.size.height);
            break;
            
        default:
            break;
    }
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.fromViewController.view]];
    collision.translatesReferenceBoundsIntoBoundary = NO;
    [collision addBoundaryWithIdentifier:FLOOR_COLISION_IDENTIFIER
                               fromPoint:firstPoint
                                 toPoint:secondPoint];
    
    [self.animator addBehavior:collision];
    collision.collisionDelegate = self;
}

-(void)addTopCollision
{
    CGPoint qFirst;
    CGPoint qSecond;
    
    
    switch (self.orientation) {
        case UIInterfaceOrientationPortrait:
            qFirst =  CGPointMake(0,
                                  -self.container.bounds.size.height - (self.container.bounds.size.height - self.heightToReleasePoint));
            qSecond = CGPointMake(self.container.bounds.size.width,
                                  -self.container.bounds.size.height - (self.container.bounds.size.height - self.heightToReleasePoint));
            
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            qFirst =  CGPointMake(0,
                                  2*self.container.bounds.size.height + (self.container.bounds.size.height - self.heightToReleasePoint));
            qSecond = CGPointMake(self.container.bounds.size.width,
                                  2*self.container.bounds.size.height + (self.container.bounds.size.height - self.heightToReleasePoint));
            break;
        case UIInterfaceOrientationLandscapeRight:
            qFirst =  CGPointMake(2*self.container.bounds.size.width + (self.container.bounds.size.width - self.heightToReleasePoint),
                                  0);
            qSecond = CGPointMake(2*self.container.bounds.size.width + (self.container.bounds.size.width - self.heightToReleasePoint),
                                  self.container.bounds.size.height);
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
            qFirst =  CGPointMake(-self.container.bounds.size.width - (self.container.bounds.size.width - self.heightToReleasePoint),
                                  0);
            qSecond = CGPointMake(-self.container.bounds.size.width - (self.container.bounds.size.width - self.heightToReleasePoint),
                                  self.container.bounds.size.height);
            break;
            
        default:
            break;
    }
    
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.fromViewController.view]];
    collision.translatesReferenceBoundsIntoBoundary = NO;
    [collision addBoundaryWithIdentifier:TOP_COLISION_IDENTIFIER
                               fromPoint:qFirst
                                 toPoint:qSecond];
    
    [self.animator addBehavior:collision];
    collision.collisionDelegate = self;
}


-(void)addGravity
{
    CGVector direction;
    switch (self.orientation) {
        case UIInterfaceOrientationPortrait:
            direction = CGVectorMake(0, GRAVITY_STRENGTH);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            direction = CGVectorMake(0, -GRAVITY_STRENGTH);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            direction = CGVectorMake(GRAVITY_STRENGTH,0);
            break;
        case UIInterfaceOrientationLandscapeRight:
            direction = CGVectorMake(-GRAVITY_STRENGTH,0);
            break;
            
        default:
            break;
    }
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.fromViewController.view]];
    gravity.gravityDirection = direction;
    [self.animator addBehavior:gravity];
}

-(void)addItemBehaviour
{
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc]initWithItems:@[self.fromViewController.view]];
    itemBehaviour.elasticity = 0.4f;
    [self.animator addBehavior:itemBehaviour];
}

-(void)addForceForVelocity:(CGPoint)velocity
{
    UIPushBehavior *force = [[UIPushBehavior alloc]initWithItems:@[self.fromViewController.view]
                                                            mode:UIPushBehaviorModeInstantaneous];
    
    CGVector direction;
    switch (self.orientation) {
        case UIInterfaceOrientationPortrait:
            direction = CGVectorMake(0, velocity.y*FORCE_MULTIPLIER);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            direction = CGVectorMake(0, -velocity.y*FORCE_MULTIPLIER);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            direction = CGVectorMake(velocity.y*FORCE_MULTIPLIER, 0);
            break;
        case UIInterfaceOrientationLandscapeRight:
            direction = CGVectorMake(-velocity.y*FORCE_MULTIPLIER, 0);
            break;
            
        default:
            break;
    }
        
    force.pushDirection = direction;
    [self.animator addBehavior:force];
}



//=================================================
#pragma mark - <UICollisionBehaviorDelegate>
//=================================================

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
{
    if([(NSString *)identifier isEqualToString:FLOOR_COLISION_IDENTIFIER])
    {
        NSLog(@"Bounce");
        if(!self.bouncedOnce)
            self.bouncedOnce = YES;
        [self performSelector:@selector(update:) withObject:nil afterDelay:0.2];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if([(NSString *)identifier isEqualToString:TOP_COLISION_IDENTIFIER])
    {
        NSLog(@"frame: %@",NSStringFromCGRect(self.fromViewController.view.frame));
        [self.animator removeAllBehaviors];
        [self finishInteractiveTransition];
    }
}

-(void)update:(id)sender
{
    if(CGPointEqualToPoint(self.fromViewController.view.center, self.container.center))
    {
        [self cancelInteractiveTransition];
    }
    else
    {
        
    }
}

@end
