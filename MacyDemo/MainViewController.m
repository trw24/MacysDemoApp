//
//  MainViewController.m
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()
@end


@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Activate Model as soon as possible
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel copyAllRecordsFromDatabaseToDataModel];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel unsetCurrentProductObject];
}


@end




