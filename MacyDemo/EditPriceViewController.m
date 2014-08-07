//
//  EditPriceViewController.m
//  MacyDemo
//
//  Created by troy on 7/30/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "EditPriceViewController.h"



@interface EditPriceViewController ()
@end



@implementation EditPriceViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set number keyboards for the number fields
    // rather than the regular alpha-keyboard
    self.regularPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.salePriceTextField.keyboardType    = UIKeyboardTypeDecimalPad;
    
    // Set the fields:
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    
    // Create new local strings and set them
    self.regularPriceTextField.text = [NSString stringWithString:productObject.regularPrice];
    self.salePriceTextField.text    = [NSString stringWithString:productObject.salePrice];
    
    [self.regularPriceTextField setDelegate:self];
    [self.salePriceTextField    setDelegate:self];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.regularPriceTextField resignFirstResponder];
    [self.salePriceTextField    resignFirstResponder];
    [super viewWillDisappear:animated];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // NSLog(@"EditProductViewController: textFieldShouldReturn");
    [self.regularPriceTextField resignFirstResponder];
    [self.salePriceTextField    resignFirstResponder];
    return YES;
}


- (IBAction)saveButton:(UIButton *)sender {
    
    // This is only place we modify the data.
    
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    
    // convert to string and back to make sure it is a good ("legit") number
    double  tempDouble;
    tempDouble = [[NSDecimalNumber decimalNumberWithString:self.regularPriceTextField.text] doubleValue];
    productObject.regularPrice = [NSString stringWithFormat:@"%.2f", tempDouble];
    
    tempDouble = [[NSDecimalNumber decimalNumberWithString:self.salePriceTextField.text] doubleValue];
    productObject.salePrice = [NSString stringWithFormat:@"%.2f", tempDouble];

    [productModel addObjectToModel:productObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end









