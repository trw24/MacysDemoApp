//
//  EditDescriptionViewController.m
//  MacyDemo
//
//  Created by troy on 7/30/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "EditDescriptionViewController.h"


@interface EditDescriptionViewController ()
@end



@implementation EditDescriptionViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    
    // Create new local strings and set them
    self.descriptionTextView.text          = [NSString stringWithString:productObject.description];
    
    [self.descriptionTextView setDelegate:self];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        // this needed to get editable text to appear near top of scroll area
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.descriptionTextView resignFirstResponder];
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
    productObject.description = self.descriptionTextView.text;
    [productModel addObjectToModel:productObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end





