//
//  ShowProductsViewController.h
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"



@interface ShowProductsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *outletTableView;


@end




