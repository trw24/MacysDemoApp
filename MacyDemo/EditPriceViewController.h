//
//  EditPriceViewController.h
//  MacyDemo
//
//  Created by troy on 7/30/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import "ProductModel.h"



@interface EditPriceViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *regularPriceTextField;
@property (strong, nonatomic) IBOutlet UITextField *salePriceTextField;


- (IBAction)saveButton:(UIButton *)sender;


@end




