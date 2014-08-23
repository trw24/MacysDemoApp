//
//  ProductObject.h
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <Foundation/Foundation.h>


#define JSON_OBJECT_1   1
#define JSON_OBJECT_2   2
#define JSON_OBJECT_3   3
#define JSON_OBJECT_4   4
#define JSON_OBJECT_5   5


@interface ProductObject : NSObject


@property (nonatomic)   NSNumber    *id;
@property (nonatomic)   NSString    *name;
@property (nonatomic)   NSString    *description;
@property (nonatomic)   NSString    *imageThumb;
@property (nonatomic)   NSString    *imageFull;
@property (nonatomic)   NSString    *regularPrice;
@property (nonatomic)   NSString    *salePrice;
@property (nonatomic)   NSArray     *colorArray;


//@property (nonatomic)   NSDictionary    *storeDictionary; // not implemented


@end







