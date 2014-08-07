//
//  ProductDetailViewController.h
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import "ProductModel.h"
#import "ImageDetailViewController.h"
#import "ImageButton.h"



@interface ProductDetailViewController : UIViewController <UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel  *labelName;
@property (strong, nonatomic) IBOutlet UILabel  *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel  *regularPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel  *salePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel  *wasPriceLabel;

@property (strong, nonatomic) IBOutlet ImageButton *imageButton;


- (IBAction)buttonColors:   (UIButton *)sender;
- (IBAction)buttonStores:   (UIButton *)sender;
- (IBAction)buttonEdit:     (UIButton *)sender;
- (IBAction)buttonDelete:   (UIButton *)sender;


@end




