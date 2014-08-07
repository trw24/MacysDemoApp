//
//  ShowProductsViewController.m
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "ShowProductsViewController.h"


@interface ShowProductsViewController ()
@end


@implementation ShowProductsViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath = [self.outletTableView indexPathForSelectedRow];
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getObjectAtIndexPath:indexPath];

    [productModel setCurrentProductObject:productObject];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getObjectAtIndexPath:indexPath];
    
    NSString * reuseIdentifier = @"reuseIdentifier";
    
    UITableViewCell * thisCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (thisCell == nil)
    {
        thisCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    // Set the Text
    UILabel * label;
    label = (UILabel *)[thisCell viewWithTag:10];
    label.text = productObject.name;

    //
    // Set the Thumbnail Image:  is in the asset catalog
    //
    UIImageView * imageView;
    imageView = (UIImageView *)[thisCell viewWithTag:30];
    [imageView setImage:[UIImage imageNamed:productObject.imageThumb]];
    
    return thisCell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProductModel * productModel = [ProductModel getProductModel];
    return ([productModel getNumberOfObjectsInModel]);
}


#define SECTION_COUNT       1
#define TITLE_FOR_SECTION   @"Women -- Wear to Work"


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_COUNT;           // hard coded for this demo
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ( TITLE_FOR_SECTION );   // hard coded for this demo
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (CGFloat) 50.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.outletTableView reloadData];
}


@end







