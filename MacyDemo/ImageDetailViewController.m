//
//  ImageDetailViewController.m
//  MacyDemo
//
//  Created by troy on 7/27/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "ImageDetailViewController.h"


@interface ImageDetailViewController ()

-(void) displayImageSpecs;

@end



@implementation ImageDetailViewController


-(void) viewDidLoad
{
    [super viewDidLoad];

    /*
     //
     // Used to verify which image version is being used
     //
    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(displayImageSpecs)];
    
    self.navigationItem.rightBarButtonItem = actionButton;
    */
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        // Adjust the scrollview with nav bar for ios 7
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // DoubleTap Gesture will Toggle the Zoom
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTapGesture setNumberOfTapsRequired:(NSInteger)2];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [self.imageView setUserInteractionEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    
}


-(void) handleDoubleTap:(UIGestureRecognizer *)gesture
{
    // DoubleTap: Toggle the Zoom
    
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale)
    {
        [self.scrollView setZoomScale:[self.scrollView maximumZoomScale] animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:[self.scrollView minimumZoomScale] animated:YES];
    }
}


-(void) displayImageSpecs
{
    NSLog(@"==========================");
    NSLog(@"ImageView");
    NSLog(@"Size: Frame: (%5.f, %5.f).  Bounds: (%5.f, %5.f).", self.imageView.frame.size.width, self.imageView.frame.size.height, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    NSLog(@"Origin: Frame: (%5.f, %5.f).  Bounds: (%5.f, %5.f).", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.bounds.origin.x, self.imageView.bounds.origin.y);
    
    NSLog(@"ScrollView");
    NSLog(@"Size: Frame: (%5.f, %5.f).  Bounds: (%5.f, %5.f).", self.scrollView.frame.size.width, self.scrollView.frame.size.height, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    NSLog(@"Origin: Frame: (%5.f, %5.f).  Bounds: (%5.f, %5.f).", self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y);
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ProductModel * productModel = [ProductModel getProductModel];
    ProductObject * productObject = [productModel getCurrentProductObject];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:productObject.imageFull]];
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;   // start zoomed all the way "out"
    self.scrollView.clipsToBounds = YES;
    self.scrollView.center = CGPointMake((self.view.frame.size.width/2), (self.view.frame.size.height/2));

    [self.scrollView addSubview:self.imageView];
    
    // [self displayImageSpecs];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end







