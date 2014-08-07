//
//  EditNameViewController.h
//  MacyDemo
//
//  Created by troy on 7/30/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import "ProductModel.h"


@interface EditNameViewController : UIViewController <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *nameTextView;


- (IBAction)saveButton:(UIButton *)sender;


@end





