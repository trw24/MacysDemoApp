//
//  EditNameViewController.m
//  MacyDemo
//
//  Created by troy on 7/30/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "EditNameViewController.h"



@interface EditNameViewController ()
@end



@implementation EditNameViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    
    // Create new local strings and set them
    self.nameTextView.text          = [NSString stringWithString:productObject.name];
    
    [self.nameTextView setDelegate:self];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        // this needed to get editable text to appear near top of scroll area
        // needed on ios 7 and later.  not available (nor needed) on ios 6.
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.nameTextView resignFirstResponder];
    [super viewWillDisappear:animated];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


- (IBAction)saveButton:(UIButton *)sender {
    
    // This is only place we modify the data.
    
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    productObject.name = self.nameTextView.text;
    [productModel addObjectToModel:productObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end





