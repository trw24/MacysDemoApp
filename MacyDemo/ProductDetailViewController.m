//
//  ProductDetailViewController.m
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "ProductDetailViewController.h"

#define MAGNIFYING_GLASS_FILE_NAME @"magnifyingGlass"

@interface ProductDetailViewController ()
@end


@implementation ProductDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];
    double regularPrice = [productObject.regularPrice doubleValue];
    double salePrice = [productObject.salePrice doubleValue];
    double wasPrice = (regularPrice + salePrice)/2;
    
    self.labelName.text = productObject.name;
    self.labelDescription.text = productObject.description;
    self.regularPriceLabel.text = [NSString stringWithFormat:@"$%@", productObject.regularPrice];
    self.wasPriceLabel.text = [NSString stringWithFormat:@"$%.2f", wasPrice];
    self.salePriceLabel.text = [NSString stringWithFormat:@"$%@", productObject.salePrice];
    
    UIImage * productImage = [UIImage imageNamed:productObject.imageThumb];
    
    //  ==================================================
    //
    //  These lines inserted to add magnifying glass to thumbnail image
    //
    
    CGSize productImageSize = productImage.size;
    
    UIGraphicsBeginImageContext(productImageSize); // Create/begin virtual image
    
    CGRect productImageRect = CGRectMake(0, 0, productImageSize.width, productImageSize.height);
    
    [productImage drawInRect:productImageRect];
    
    int magWidth = 30;
    int magHeight = 30;
    
    UIImage * magnifyingGlassImage = [UIImage imageNamed:MAGNIFYING_GLASS_FILE_NAME];
    
    CGRect magnifyingGlassRect = CGRectMake((productImageSize.width - magWidth), (productImageSize.height - magHeight), magWidth, magHeight);
    
    [magnifyingGlassImage drawInRect:magnifyingGlassRect];
    
    UIImage *modifiedProductImage = UIGraphicsGetImageFromCurrentImageContext();    // Capture the virtual image
    
    [self.imageButton setBackgroundImage:modifiedProductImage forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:modifiedProductImage forState:UIControlStateSelected];
    [self.imageButton setBackgroundImage:modifiedProductImage forState:UIControlStateHighlighted];
    
    //  ==================================================
    
    //
    //    [self.imageButton setBackgroundImage:productImage forState:UIControlStateNormal];
    //    [self.imageButton setBackgroundImage:productImage forState:UIControlStateSelected];
    //    [self.imageButton setBackgroundImage:productImage forState:UIControlStateHighlighted];
    //
    
    //  ==================================================
    
    // CALayer * layer = [self.buttonThumbImage layer];
    // [layer setMasksToBounds:YES];
    // [layer setCornerRadius:0.01f];

}


- (IBAction)buttonColors:(UIButton *)sender {
    
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];

    unsigned long numberOfColors = [productObject.colorArray count];
    NSString * stringOfColors;
    NSString * messageString;
    UIAlertView * alertView;

    if ( numberOfColors == 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Available Colors"
                                               message:@"This product is NOT available in any colors."
                                              delegate:self
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles:nil];

    }
    else if ( numberOfColors == 1)
    {
        stringOfColors = productObject.colorArray[0];
        messageString = [NSString stringWithFormat:@"This product is only available in %@", stringOfColors];
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Available Colors"
                                               message:messageString
                                              delegate:self
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles:nil];
    }
    else
    {
        stringOfColors = productObject.colorArray[0];

        for (int i=1; i<numberOfColors; i++)
        {
            stringOfColors = [NSString  stringWithFormat:@"%@, %@", stringOfColors, productObject.colorArray[i]];
        }
        
        messageString = [NSString stringWithFormat:@"This product is available in these colors: %@", stringOfColors];
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Available Colors"
                                               message:messageString
                                              delegate:self
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles:nil];
    }
    [alertView show];

}


- (IBAction)buttonStores:(UIButton *)sender {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Stores"
                                                         message:@"Great News.  This item is available at all Macy's stores"
                                                        delegate:self
                                               cancelButtonTitle:@"Excellent"
                                               otherButtonTitles:nil];
    [alertView show];
}


- (IBAction)buttonEdit:(UIButton *)sender {
    
    // Segue goes to dedicated Edit views
    // so nothing to do here
    return;
}


- (IBAction)buttonDelete:(UIButton *)sender {
    
    // put up alert to confirm this action
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion"
                                                         message:@"Are you sure you want to Delete this item?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancil"
                                               otherButtonTitles:@"Delete", nil];
    [alertView show];
}

#define BUTTON_FOR_CANCELING    0
#define BUTTON_FOR_DELETION     1

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == BUTTON_FOR_DELETION)
    {
        // then, do deletion
        ProductModel * productModel = [ProductModel getProductModel];
        [productModel deleteCurrentProductObjectFromModel];
        [productModel unsetCurrentProductObject];
        
        // since this entry no longer in data model, we just go back to previous view
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end






