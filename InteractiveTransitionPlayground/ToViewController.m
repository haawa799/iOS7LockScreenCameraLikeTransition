//
//  ToViewController.m
//  InteractiveTransitionPlayground
//
//  Created by Andrew K. on 10/22/13.
//  Copyright (c) 2013 Andrew Kharchyshyn. All rights reserved.
//

#import "ToViewController.h"

@interface ToViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ToViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor orangeColor]];
}

-(IBAction)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
