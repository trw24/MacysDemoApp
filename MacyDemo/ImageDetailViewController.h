//
//  ImageDetailViewController.h
//  MacyDemo
//
//  Created by troy on 7/27/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import "ProductModel.h"



@interface ImageDetailViewController : UIViewController <UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView * imageView;


@end






