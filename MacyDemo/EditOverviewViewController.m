//
//  EditOverviewViewController.m
//  MacyDemo
//
//  Created by troy on 8/6/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "EditOverviewViewController.h"


@interface EditOverviewViewController ()
@end


@implementation EditOverviewViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // change default button to display text "Cancel" (rather than "back")
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    self.navigationItem.backBarButtonItem = customBarItem;
}


@end







