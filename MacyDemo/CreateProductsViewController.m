//
//  CreateProductsViewController.m
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "CreateProductsViewController.h"

@interface CreateProductsViewController ()
@end


@implementation CreateProductsViewController


- (IBAction)buttonCreateProduct_1:(UIButton *)sender {

    ProductModel * productModel = [ProductModel getProductModel];
    [productModel createObjectFromJSONOFile:JSON_OBJECT_1];
}

- (IBAction)buttonCreateProduct_2:(UIButton *)sender {

    ProductModel * productModel = [ProductModel getProductModel];
    [productModel createObjectFromJSONOFile:JSON_OBJECT_2];
}

- (IBAction)buttonCreateProduct_3:(UIButton *)sender {

    ProductModel * productModel = [ProductModel getProductModel];
    [productModel createObjectFromJSONOFile:JSON_OBJECT_3];
}

- (IBAction)buttonCreateProduct_4:(UIButton *)sender {
    
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel createObjectFromJSONOFile:JSON_OBJECT_4];
}

- (IBAction)buttonCreateProduct_5:(UIButton *)sender {

    ProductModel * productModel = [ProductModel getProductModel];
    [productModel createObjectFromJSONOFile:JSON_OBJECT_5];
}

- (IBAction)describeModel:(UIButton *)sender {
    
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel describeModel];
}


@end








