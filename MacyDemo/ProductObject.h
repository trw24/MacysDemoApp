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


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


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







