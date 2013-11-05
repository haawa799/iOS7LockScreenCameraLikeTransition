//
//  ViewController.h
//  InteractiveTransitionPlayground
//
//  Created by Andrew K. on 10/25/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIButton *handleButton;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@end
